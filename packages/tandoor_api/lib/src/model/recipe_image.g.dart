// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_image.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeImage extends RecipeImage {
  @override
  final String? image;
  @override
  final String? imageUrl;

  factory _$RecipeImage([void Function(RecipeImageBuilder)? updates]) =>
      (RecipeImageBuilder()..update(updates))._build();

  _$RecipeImage._({this.image, this.imageUrl}) : super._();
  @override
  RecipeImage rebuild(void Function(RecipeImageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeImageBuilder toBuilder() => RecipeImageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeImage &&
        image == other.image &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeImage')
          ..add('image', image)
          ..add('imageUrl', imageUrl))
        .toString();
  }
}

class RecipeImageBuilder implements Builder<RecipeImage, RecipeImageBuilder> {
  _$RecipeImage? _$v;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  RecipeImageBuilder() {
    RecipeImage._defaults(this);
  }

  RecipeImageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _image = $v.image;
      _imageUrl = $v.imageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeImage other) {
    _$v = other as _$RecipeImage;
  }

  @override
  void update(void Function(RecipeImageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeImage build() => _build();

  _$RecipeImage _build() {
    final _$result = _$v ?? _$RecipeImage._(image: image, imageUrl: imageUrl);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
