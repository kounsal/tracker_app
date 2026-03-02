class ApiConfig {
  static const String baseUrl = "http://3.111.55.51:4000";
  static const int timeoutDuration = 15000; // in milliseconds

  //endpoints

  //auth endpoints
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String refreshToken = "/api/auth/refresh";
  static const String profile = "/api/users/me";

  //task Endpoints
  static const String task = "/api/tasks";
  static const String toggleTask = "/api/tasks/toggle";

  // Helper function to get full URL
  static String getUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
