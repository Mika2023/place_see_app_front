import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:place_see_app/core/model/filters/transport_type_enum.dart';

class TransportMapConverter implements JsonConverter<Map<TransportTypeEnum, List<String>>, Map<String, dynamic>>{
  const TransportMapConverter();

  @override
  Map<TransportTypeEnum, List<String>> fromJson(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(
      TransportTypeEnum.values.firstWhere((e) => e.name == key),
      List<String>.from(value as List)
    ));
  }

  @override
  Map<String, dynamic> toJson(Map<TransportTypeEnum, List<String>> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}