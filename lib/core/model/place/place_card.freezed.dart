// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlaceCard _$PlaceCardFromJson(Map<String, dynamic> json) {
  return _PlaceCard.fromJson(json);
}

/// @nodoc
mixin _$PlaceCard {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool? get isFavorite => throw _privateConstructorUsedError;
  String? get mainImageUrl => throw _privateConstructorUsedError;

  /// Serializes this PlaceCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceCardCopyWith<PlaceCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceCardCopyWith<$Res> {
  factory $PlaceCardCopyWith(PlaceCard value, $Res Function(PlaceCard) then) =
      _$PlaceCardCopyWithImpl<$Res, PlaceCard>;
  @useResult
  $Res call({int id, String name, bool? isFavorite, String? mainImageUrl});
}

/// @nodoc
class _$PlaceCardCopyWithImpl<$Res, $Val extends PlaceCard>
    implements $PlaceCardCopyWith<$Res> {
  _$PlaceCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isFavorite = freezed,
    Object? mainImageUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isFavorite: freezed == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool?,
            mainImageUrl: freezed == mainImageUrl
                ? _value.mainImageUrl
                : mainImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaceCardImplCopyWith<$Res>
    implements $PlaceCardCopyWith<$Res> {
  factory _$$PlaceCardImplCopyWith(
    _$PlaceCardImpl value,
    $Res Function(_$PlaceCardImpl) then,
  ) = __$$PlaceCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, bool? isFavorite, String? mainImageUrl});
}

/// @nodoc
class __$$PlaceCardImplCopyWithImpl<$Res>
    extends _$PlaceCardCopyWithImpl<$Res, _$PlaceCardImpl>
    implements _$$PlaceCardImplCopyWith<$Res> {
  __$$PlaceCardImplCopyWithImpl(
    _$PlaceCardImpl _value,
    $Res Function(_$PlaceCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaceCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isFavorite = freezed,
    Object? mainImageUrl = freezed,
  }) {
    return _then(
      _$PlaceCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isFavorite: freezed == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool?,
        mainImageUrl: freezed == mainImageUrl
            ? _value.mainImageUrl
            : mainImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceCardImpl implements _PlaceCard {
  const _$PlaceCardImpl({
    required this.id,
    required this.name,
    this.isFavorite,
    this.mainImageUrl,
  });

  factory _$PlaceCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceCardImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final bool? isFavorite;
  @override
  final String? mainImageUrl;

  @override
  String toString() {
    return 'PlaceCard(id: $id, name: $name, isFavorite: $isFavorite, mainImageUrl: $mainImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, isFavorite, mainImageUrl);

  /// Create a copy of PlaceCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceCardImplCopyWith<_$PlaceCardImpl> get copyWith =>
      __$$PlaceCardImplCopyWithImpl<_$PlaceCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceCardImplToJson(this);
  }
}

abstract class _PlaceCard implements PlaceCard {
  const factory _PlaceCard({
    required final int id,
    required final String name,
    final bool? isFavorite,
    final String? mainImageUrl,
  }) = _$PlaceCardImpl;

  factory _PlaceCard.fromJson(Map<String, dynamic> json) =
      _$PlaceCardImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool? get isFavorite;
  @override
  String? get mainImageUrl;

  /// Create a copy of PlaceCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceCardImplCopyWith<_$PlaceCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
