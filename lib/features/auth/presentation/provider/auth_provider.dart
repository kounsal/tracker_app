import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/common/widgets/common_functions.dart';
import '../../../../utils/common/widgets/snackBar.dart';
import '../../../../data/entity/user_entity.dart';
import '../../../../utils/services/api/api.service.dart';
import '../../../../utils/services/storage/storage_service.dart';
import '../../../../utils/theme/theme.extension.dart';
import '../../data/model/auth_params.dart';
import '../../domain/repository/auth_repository.dart';

@LazySingleton()
class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final StorageService storageService;

  AuthProvider({required this.authRepository, required this.storageService});

  bool _isLoading = false;
  bool _isInitialized = false;
  String? accessToken;
  UserEntity? _user;

  UserEntity? get user => _user;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => accessToken != null && _user != null;

  Future<void> setAccessToken(String token) async {
    accessToken = token;
    await storageService.saveAccessToken(token);
    notifyListeners();
  }

  Future<void> setRefreshToken(String token) async {
    await storageService.saveRefreshToken(token);
  }

  final Map<String, dynamic> _selectedLanguage = {};
  Map<String, dynamic> get selectedLanguage => _selectedLanguage;

  bool get isLoading => _isLoading;

  void configureInterceptor() {
    ApiService.configure(
      interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (accessToken != null && accessToken!.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
            log('Response: ${response.data}');
            return handler.next(response);
          },
          onError: (DioException e, handler) async {
            if (e.response?.statusCode == 403 ||
                e.response?.statusCode == 401) {
              log('Received 401/403, attempting to refresh token...');
              final success = await _refreshTokenLogic();
              if (success && accessToken != null) {
                // Retry request
                final opts = e.requestOptions;
                opts.headers['Authorization'] = 'Bearer $accessToken';
                try {
                  final cloneReq = await Dio().request(
                    opts.path,
                    options: Options(
                      method: opts.method,
                      headers: opts.headers,
                    ),
                    data: opts.data,
                    queryParameters: opts.queryParameters,
                  );
                  return handler.resolve(cloneReq);
                } catch (retryError) {
                  return handler.next(e);
                }
              } else {
                // Logout user and show message
                await logout();
                showSnackbar(
                  'Session expired. Please login again.',
                  bContext.colors.error,
                );
                return handler.next(e);
              }
            }
            return handler.next(e);
          },
        ),
      ],
    );
  }

  Future<bool> _refreshTokenLogic() async {
    final refreshToken = await storageService.getRefreshToken();
    if (refreshToken == null) return false;

    final res = await authRepository.refreshToken(refreshToken);
    bool success = false;
    res.fold(
      (failure) {
        success = false;
      },
      (token) {
        accessToken = token;
        success = true;
      },
    );

    if (success && accessToken != null) {
      await storageService.saveAccessToken(accessToken!);
      return true;
    }
    return false;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  void getNewAuthToken() async {
    final success = await _refreshTokenLogic();
    if (success) {
      await storageService.setLoggedIn(true);
      configureInterceptor();
      await fetchProfile();
    } else {
      showSnackbar(
        'Session expired. Please login again.',
        bContext.colors.error,
      );
      logout();
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    setLoading(true);

    // Load token from storage
    final storedToken = await storageService.getAccessToken();

    if (storedToken != null && storedToken.isNotEmpty) {
      accessToken = storedToken;
      configureInterceptor();
      // Fetch user profile
      await fetchProfile();
    }

    _isInitialized = true;
    setLoading(false);
  }

  Future<bool> fetchProfile() async {
    setLoading(true);
    final result = await authRepository.fetchProfile();
    setLoading(false);
    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (userEntity) {
        setUser(userEntity);
        return true;
      },
    );
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    final result = await authRepository.login(
      LoginRequestModel(email: email, password: password),
    );
    setLoading(false);
    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (response) async {
        await setAccessToken(response.accessToken);
        await setRefreshToken(response.refreshToken);
        await storageService.setLoggedIn(true);
        setUser(response.user);
        configureInterceptor();
        return true;
      },
    );
  }

  Future<bool> registerUser(String name, String email, String password) async {
    setLoading(true);
    final result = await authRepository.register(
      RegisterRequestModel(name: name, email: email, password: password),
    );
    setLoading(false);
    return result.fold(
      (failure) {
        showSnackbar(failure.message, bContext.colors.error);
        return false;
      },
      (response) async {
        await setAccessToken(response.accessToken);
        await setRefreshToken(response.refreshToken);
        await storageService.setLoggedIn(true);
        setUser(response.user);
        configureInterceptor();
        return true;
      },
    );
  }

  /// Logout user and clear all auth data
  Future<void> logout() async {
    // setLoading(true);

    // Clear storage
    await storageService.clearAuthData();

    // Clear in-memory state
    accessToken = null;
    _user = null;
    _isInitialized = false;

    // Call repository logout (if needed for API call)
    // await authRepository.logout();

    notifyListeners();
  }
}
