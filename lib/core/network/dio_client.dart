import 'package:dio/dio.dart';
import 'package:place_see_app/core/config/app_config.dart';
import 'package:place_see_app/core/local_storage/token_storage.dart';
import 'package:place_see_app/core/network/auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  DioClient(this.tokenStorage) : dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.backendBaseUrl,
      connectTimeout: const Duration(seconds: AppConfig.connectTimeoutSeconds),
      receiveTimeout: const Duration(seconds: AppConfig.receiveTimeoutSeconds),
    ),
  ) {
    dio.interceptors.add(AuthInterceptor(dio: dio, tokenStorage: tokenStorage,),);
  }
}