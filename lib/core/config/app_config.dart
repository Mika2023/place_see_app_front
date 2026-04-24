import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String backendBaseUrl = dotenv.env['BACKEND_BASE_URL']!;
  static const int connectTimeoutSeconds = 20;
  static const int receiveTimeoutSeconds = 20;
  static final String baseUrlFs = dotenv.env['BASE_FS_URL']!;
  static final String twoGisApiKey = dotenv.env['TWO_GIS_API_KEY']!;
  static final String surveyUrl = dotenv.env['SURVEY_URL']!;
}