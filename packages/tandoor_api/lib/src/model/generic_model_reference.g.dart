// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_model_reference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GenericModelReference extends GenericModelReference {
  @override
  final int? id;
  @override
  final String model;
  @override
  final String name;

  factory _$GenericModelReference([
    void Function(GenericModelReferenceBuilder)? updates,
  ]) => (GenericModelReferenceBuilder()..update(updates))._build();

  _$GenericModelReference._({this.id, required this.model, required this.name})
    : super._();
  @override
  GenericModelReference rebuild(
    void Function(GenericModelReferenceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  GenericModelReferenceBuilder toBuilder() =>
      GenericModelReferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GenericModelReference &&
        id == other.id &&
        model == other.model &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GenericModelReference')
          ..add('id', id)
          ..add('model', model)
          ..add('name', name))
        .toString();
  }
}

class GenericModelReferenceBuilder
    implements Builder<GenericModelReference, GenericModelReferenceBuilder> {
  _$GenericModelReference? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  GenericModelReferenceBuilder() {
    GenericModelReference._defaults(this);
  }

  GenericModelReferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _model = $v.model;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GenericModelReference other) {
    _$v = other as _$GenericModelReference;
  }

  @override
  void update(void Function(GenericModelReferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GenericModelReference build() => _build();

  _$GenericModelReference _build() {
    final _$result =
        _$v ??
        _$GenericModelReference._(
          id: id,
          model: BuiltValueNullFieldError.checkNotNull(
            model,
            r'GenericModelReference',
            'model',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'GenericModelReference',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
