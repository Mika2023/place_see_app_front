// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfileInfo _$UserProfileInfoFromJson(Map<String, dynamic> json) {
  return _UserProfileInfo.fromJson(json);
}

/// @nodoc
mixin _$UserProfileInfo {
  int get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String? get avatarImageUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this UserProfileInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileInfoCopyWith<UserProfileInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileInfoCopyWith<$Res> {
  factory $UserProfileInfoCopyWith(
    UserProfileInfo value,
    $Res Function(UserProfileInfo) then,
  ) = _$UserProfileInfoCopyWithImpl<$Res, UserProfileInfo>;
  @useResult
  $Res call({int id, String nickname, String? avatarImageUrl, String? email});
}

/// @nodoc
class _$UserProfileInfoCopyWithImpl<$Res, $Val extends UserProfileInfo>
    implements $UserProfileInfoCopyWith<$Res> {
  _$UserProfileInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? avatarImageUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarImageUrl: freezed == avatarImageUrl
                ? _value.avatarImageUrl
                : avatarImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileInfoImplCopyWith<$Res>
    implements $UserProfileInfoCopyWith<$Res> {
  factory _$$UserProfileInfoImplCopyWith(
    _$UserProfileInfoImpl value,
    $Res Function(_$UserProfileInfoImpl) then,
  ) = __$$UserProfileInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nickname, String? avatarImageUrl, String? email});
}

/// @nodoc
class __$$UserProfileInfoImplCopyWithImpl<$Res>
    extends _$UserProfileInfoCopyWithImpl<$Res, _$UserProfileInfoImpl>
    implements _$$UserProfileInfoImplCopyWith<$Res> {
  __$$UserProfileInfoImplCopyWithImpl(
    _$UserProfileInfoImpl _value,
    $Res Function(_$UserProfileInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? avatarImageUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(
      _$UserProfileInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarImageUrl: freezed == avatarImageUrl
            ? _value.avatarImageUrl
            : avatarImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileInfoImpl implements _UserProfileInfo {
  const _$UserProfileInfoImpl({
    required this.id,
    required this.nickname,
    this.avatarImageUrl,
    this.email,
  });

  factory _$UserProfileInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String nickname;
  @override
  final String? avatarImageUrl;
  @override
  final String? email;

  @override
  String toString() {
    return 'UserProfileInfo(id: $id, nickname: $nickname, avatarImageUrl: $avatarImageUrl, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarImageUrl, avatarImageUrl) ||
                other.avatarImageUrl == avatarImageUrl) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nickname, avatarImageUrl, email);

  /// Create a copy of UserProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileInfoImplCopyWith<_$UserProfileInfoImpl> get copyWith =>
      __$$UserProfileInfoImplCopyWithImpl<_$UserProfileInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileInfoImplToJson(this);
  }
}

abstract class _UserProfileInfo implements UserProfileInfo {
  const factory _UserProfileInfo({
    required final int id,
    required final String nickname,
    final String? avatarImageUrl,
    final String? email,
  }) = _$UserProfileInfoImpl;

  factory _UserProfileInfo.fromJson(Map<String, dynamic> json) =
      _$UserProfileInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get nickname;
  @override
  String? get avatarImageUrl;
  @override
  String? get email;

  /// Create a copy of UserProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileInfoImplCopyWith<_$UserProfileInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
