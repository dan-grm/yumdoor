// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_open_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportOpenData extends ImportOpenData {
  @override
  final BuiltList<String> selectedDatatypes;
  @override
  final String selectedVersion;
  @override
  final bool? updateExisting;
  @override
  final bool? useMetric;

  factory _$ImportOpenData([void Function(ImportOpenDataBuilder)? updates]) =>
      (ImportOpenDataBuilder()..update(updates))._build();

  _$ImportOpenData._({
    required this.selectedDatatypes,
    required this.selectedVersion,
    this.updateExisting,
    this.useMetric,
  }) : super._();
  @override
  ImportOpenData rebuild(void Function(ImportOpenDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImportOpenDataBuilder toBuilder() => ImportOpenDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportOpenData &&
        selectedDatatypes == other.selectedDatatypes &&
        selectedVersion == other.selectedVersion &&
        updateExisting == other.updateExisting &&
        useMetric == other.useMetric;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, selectedDatatypes.hashCode);
    _$hash = $jc(_$hash, selectedVersion.hashCode);
    _$hash = $jc(_$hash, updateExisting.hashCode);
    _$hash = $jc(_$hash, useMetric.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportOpenData')
          ..add('selectedDatatypes', selectedDatatypes)
          ..add('selectedVersion', selectedVersion)
          ..add('updateExisting', updateExisting)
          ..add('useMetric', useMetric))
        .toString();
  }
}

class ImportOpenDataBuilder
    implements Builder<ImportOpenData, ImportOpenDataBuilder> {
  _$ImportOpenData? _$v;

  ListBuilder<String>? _selectedDatatypes;
  ListBuilder<String> get selectedDatatypes =>
      _$this._selectedDatatypes ??= ListBuilder<String>();
  set selectedDatatypes(ListBuilder<String>? selectedDatatypes) =>
      _$this._selectedDatatypes = selectedDatatypes;

  String? _selectedVersion;
  String? get selectedVersion => _$this._selectedVersion;
  set selectedVersion(String? selectedVersion) =>
      _$this._selectedVersion = selectedVersion;

  bool? _updateExisting;
  bool? get updateExisting => _$this._updateExisting;
  set updateExisting(bool? updateExisting) =>
      _$this._updateExisting = updateExisting;

  bool? _useMetric;
  bool? get useMetric => _$this._useMetric;
  set useMetric(bool? useMetric) => _$this._useMetric = useMetric;

  ImportOpenDataBuilder() {
    ImportOpenData._defaults(this);
  }

  ImportOpenDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selectedDatatypes = $v.selectedDatatypes.toBuilder();
      _selectedVersion = $v.selectedVersion;
      _updateExisting = $v.updateExisting;
      _useMetric = $v.useMetric;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportOpenData other) {
    _$v = other as _$ImportOpenData;
  }

  @override
  void update(void Function(ImportOpenDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportOpenData build() => _build();

  _$ImportOpenData _build() {
    _$ImportOpenData _$result;
    try {
      _$result =
          _$v ??
          _$ImportOpenData._(
            selectedDatatypes: selectedDatatypes.build(),
            selectedVersion: BuiltValueNullFieldError.checkNotNull(
              selectedVersion,
              r'ImportOpenData',
              'selectedVersion',
            ),
            updateExisting: updateExisting,
            useMetric: useMetric,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selectedDatatypes';
        selectedDatatypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ImportOpenData',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
