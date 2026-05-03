// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_code_for_change_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCodeForChangePassword _$VerificationCodeForChangePasswordFromJson(
  Map<String, dynamic> json,
) => VerificationCodeForChangePassword(
  (json['userId'] as num).toInt(),
  json['code'] as String,
);

Map<String, dynamic> _$VerificationCodeForChangePasswordToJson(
  VerificationCodeForChangePassword instance,
) => <String, dynamic>{'userId': instance.userId, 'code': instance.code};
