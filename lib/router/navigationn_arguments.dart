/// Base class for all navigation arguments
abstract class NavigationArguments {}

/// Arguments for verify OTP screen

/// Arguments for home screen (if needed for initial tab)
class HomeArguments extends NavigationArguments {
  final int? initialTab;
  final bool?
  refreshData; // Optional flag to indicate if data should be refreshed on home screen

  HomeArguments({this.initialTab, this.refreshData = false});
}
