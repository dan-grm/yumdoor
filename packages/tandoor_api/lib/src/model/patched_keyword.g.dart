// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_keyword.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedKeyword extends PatchedKeyword {
  @override
  final DateTime? createdAt;
  @override
  final String? description;
  @override
  final String? fullName;
  @override
  final int? id;
  @override
  final String? label;
  @override
  final String? name;
  @override
  final int? numchild;
  @override
  final int? parent;
  @override
  final DateTime? updatedAt;

  factory _$PatchedKeyword([void Function(PatchedKeywordBuilder)? updates]) =>
      (PatchedKeywordBuilder()..update(updates))._build();

  _$PatchedKeyword._({
    this.createdAt,
    this.description,
    this.fullName,
    this.id,
    this.label,
    this.name,
    this.numchild,
    this.parent,
    this.updatedAt,
  }) : super._();
  @override
  PatchedKeyword rebuild(void Function(PatchedKeywordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedKeywordBuilder toBuilder() => PatchedKeywordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedKeyword &&
        createdAt == other.createdAt &&
        description == other.description &&
        fullName == other.fullName &&
        id == other.id &&
        label == other.label &&
        name == other.name &&
        numchild == other.numchild &&
        parent == other.parent &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, numchild.hashCode);
    _$hash = $jc(_$hash, parent.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedKeyword')
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('fullName', fullName)
          ..add('id', id)
          ..add('label', label)
          ..add('name', name)
          ..add('numchild', numchild)
          ..add('parent', parent)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PatchedKeywordBuilder
    implements Builder<PatchedKeyword, PatchedKeywordBuilder> {
  _$PatchedKeyword? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _numchild;
  int? get numchild => _$this._numchild;
  set numchild(int? numchild) => _$this._numchild = numchild;

  int? _parent;
  int? get parent => _$this._parent;
  set parent(int? parent) => _$this._parent = parent;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PatchedKeywordBuilder() {
    PatchedKeyword._defaults(this);
  }

  PatchedKeywordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _description = $v.description;
      _fullName = $v.fullName;
      _id = $v.id;
      _label = $v.label;
      _name = $v.name;
      _numchild = $v.numchild;
      _parent = $v.parent;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedKeyword other) {
    _$v = other as _$PatchedKeyword;
  }

  @override
  void update(void Function(PatchedKeywordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedKeyword build() => _build();

  _$PatchedKeyword _build() {
    final _$result =
        _$v ??
        _$PatchedKeyword._(
          createdAt: createdAt,
          description: description,
          fullName: fullName,
          id: id,
          label: label,
          name: name,
          numchild: numchild,
          parent: parent,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
