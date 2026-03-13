// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_profile_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhotoProfileInfo _$PhotoProfileInfoFromJson(Map<String, dynamic> json) {
  return _PhotoProfileInfo.fromJson(json);
}

/// @nodoc
mixin _$PhotoProfileInfo {
  int get id => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  PlaceShortForSearch get place => throw _privateConstructorUsedError;

  /// Serializes this PhotoProfileInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoProfileInfoCopyWith<PhotoProfileInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoProfileInfoCopyWith<$Res> {
  factory $PhotoProfileInfoCopyWith(
    PhotoProfileInfo value,
    $Res Function(PhotoProfileInfo) then,
  ) = _$PhotoProfileInfoCopyWithImpl<$Res, PhotoProfileInfo>;
  @useResult
  $Res call({
    int id,
    String? userName,
    String imageUrl,
    DateTime? createdAt,
    PlaceShortForSearch place,
  });
}

/// @nodoc
class _$PhotoProfileInfoCopyWithImpl<$Res, $Val extends PhotoProfileInfo>
    implements $PhotoProfileInfoCopyWith<$Res> {
  _$PhotoProfileInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userName = freezed,
    Object? imageUrl = null,
    Object? createdAt = freezed,
    Object? place = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userName: freezed == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            place: null == place
                ? _value.place
                : place // ignore: cast_nullable_to_non_nullable
                      as PlaceShortForSearch,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhotoProfileInfoImplCopyWith<$Res>
    implements $PhotoProfileInfoCopyWith<$Res> {
  factory _$$PhotoProfileInfoImplCopyWith(
    _$PhotoProfileInfoImpl value,
    $Res Function(_$PhotoProfileInfoImpl) then,
  ) = __$$PhotoProfileInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String? userName,
    String imageUrl,
    DateTime? createdAt,
    PlaceShortForSearch place,
  });
}

/// @nodoc
class __$$PhotoProfileInfoImplCopyWithImpl<$Res>
    extends _$PhotoProfileInfoCopyWithImpl<$Res, _$PhotoProfileInfoImpl>
    implements _$$PhotoProfileInfoImplCopyWith<$Res> {
  __$$PhotoProfileInfoImplCopyWithImpl(
    _$PhotoProfileInfoImpl _value,
    $Res Function(_$PhotoProfileInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userName = freezed,
    Object? imageUrl = null,
    Object? createdAt = freezed,
    Object? place = null,
  }) {
    return _then(
      _$PhotoProfileInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userName: freezed == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        place: null == place
            ? _value.place
            : place // ignore: cast_nullable_to_non_nullable
                  as PlaceShortForSearch,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoProfileInfoImpl implements _PhotoProfileInfo {
  const _$PhotoProfileInfoImpl({
    required this.id,
    this.userName,
    required this.imageUrl,
    this.createdAt,
    required this.place,
  });

  factory _$PhotoProfileInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoProfileInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String? userName;
  @override
  final String imageUrl;
  @override
  final DateTime? createdAt;
  @override
  final PlaceShortForSearch place;

  @override
  String toString() {
    return 'PhotoProfileInfo(id: $id, userName: $userName, imageUrl: $imageUrl, createdAt: $createdAt, place: $place)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoProfileInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.place, place) || other.place == place));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userName, imageUrl, createdAt, place);

  /// Create a copy of PhotoProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoProfileInfoImplCopyWith<_$PhotoProfileInfoImpl> get copyWith =>
      __$$PhotoProfileInfoImplCopyWithImpl<_$PhotoProfileInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoProfileInfoImplToJson(this);
  }
}

abstract class _PhotoProfileInfo implements PhotoProfileInfo {
  const factory _PhotoProfileInfo({
    required final int id,
    final String? userName,
    required final String imageUrl,
    final DateTime? createdAt,
    required final PlaceShortForSearch place,
  }) = _$PhotoProfileInfoImpl;

  factory _PhotoProfileInfo.fromJson(Map<String, dynamic> json) =
      _$PhotoProfileInfoImpl.fromJson;

  @override
  int get id;
  @override
  String? get userName;
  @override
  String get imageUrl;
  @override
  DateTime? get createdAt;
  @override
  PlaceShortForSearch get place;

  /// Create a copy of PhotoProfileInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoProfileInfoImplCopyWith<_$PhotoProfileInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
