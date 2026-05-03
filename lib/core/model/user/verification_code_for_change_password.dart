import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_code_for_change_password.g.dart';

@JsonSerializable()
class VerificationCodeForChangePassword {
  final int userId;
  final String code;

  VerificationCodeForChangePassword(this.userId, this.code);

  factory VerificationCodeForChangePassword.fromJson(Map<String, dynamic> rawCodeDto) =>
      _$VerificationCodeForChangePasswordFromJson(rawCodeDto);
}