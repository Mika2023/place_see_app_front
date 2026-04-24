import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:place_see_app/core/model/system_event_names_enum.dart';

class SystemEventsApi {
  final Dio dio;

  SystemEventsApi(this.dio);

  Future<void> createEvent(SystemEventNamesEnum eventName) async {
    try {
      dio.post(
        '/system-events',
        data: {
          'eventName': eventName.eventName
        }
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}