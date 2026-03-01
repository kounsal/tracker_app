// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'features/auth/data/auth_remote_data_source.dart' as _i516;
import 'features/auth/data/repository/auth_repository_impl.dart' as _i814;
import 'features/auth/domain/repository/auth_repository.dart' as _i279;
import 'features/auth/presentation/provider/auth_provider.dart' as _i588;
import 'features/auth/presentation/provider/home_provider.dart' as _i394;
import 'utils/services/storage/storage_service.dart' as _i565;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i394.HomeProvider>(() => _i394.HomeProvider());
    gh.lazySingleton<_i516.AuthRemoteDataSource>(
      () => _i516.AuthRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i279.AuthRepository>(
      () => _i814.AuthRepositoryImpl(gh<_i516.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i565.StorageService>(
      () => _i565.StorageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i588.AuthProvider>(
      () => _i588.AuthProvider(
        authRepository: gh<_i279.AuthRepository>(),
        storageService: gh<_i565.StorageService>(),
      ),
    );
    return this;
  }
}
