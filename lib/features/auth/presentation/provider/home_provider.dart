import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HomeProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setBottomNavIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Add more states and methods as needed for the dashboard/home tab
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchDashboardData() async {
    // Example placeholder
    setLoading(true);
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    setLoading(false);
  }
}
