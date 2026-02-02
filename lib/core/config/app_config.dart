class AppConfig {
  static const String backendBaseUrl = String.fromEnvironment('BACKEND_BASE_URL');
  static const int connectTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 10;
}