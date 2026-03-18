// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileInfoImpl _$$UserProfileInfoImplFromJson(
  Map<String, dynamic> json,
) => _$UserProfileInfoImpl(
  id: (json['id'] as num).toInt(),
  nickname: json['nickname'] as String,
  avatarImageUrl: json['avatarImageUrl'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$$UserProfileInfoImplToJson(
  _$UserProfileInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nickname': instance.nickname,
  'avatarImageUrl': instance.avatarImageUrl,
  'email': instance.email,
};
