// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_database.dart';

// ignore_for_file: type=lint
class $CachedRecipesTable extends CachedRecipes
    with TableInfo<$CachedRecipesTable, CachedRecipeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<int> lastOpenedAt = GeneratedColumn<int>(
    'last_opened_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imageUrl,
    updatedAt,
    json,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_recipe';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedRecipeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastOpenedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedRecipeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedRecipeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_opened_at'],
      )!,
    );
  }

  @override
  $CachedRecipesTable createAlias(String alias) {
    return $CachedRecipesTable(attachedDatabase, alias);
  }
}

class CachedRecipeRow extends DataClass implements Insertable<CachedRecipeRow> {
  final int id;
  final String name;

  /// `Recipe.image`, to find the images no recipe uses any more.
  final String? imageUrl;
  final DateTime? updatedAt;
  final String json;

  /// Milliseconds since the epoch; the least recently opened go first.
  final int lastOpenedAt;
  const CachedRecipeRow({
    required this.id,
    required this.name,
    this.imageUrl,
    this.updatedAt,
    required this.json,
    required this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['json'] = Variable<String>(json);
    map['last_opened_at'] = Variable<int>(lastOpenedAt);
    return map;
  }

  CachedRecipesCompanion toCompanion(bool nullToAbsent) {
    return CachedRecipesCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      json: Value(json),
      lastOpenedAt: Value(lastOpenedAt),
    );
  }

  factory CachedRecipeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedRecipeRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      json: serializer.fromJson<String>(json['json']),
      lastOpenedAt: serializer.fromJson<int>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'json': serializer.toJson<String>(json),
      'lastOpenedAt': serializer.toJson<int>(lastOpenedAt),
    };
  }

  CachedRecipeRow copyWith({
    int? id,
    String? name,
    Value<String?> imageUrl = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    String? json,
    int? lastOpenedAt,
  }) => CachedRecipeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    json: json ?? this.json,
    lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
  );
  CachedRecipeRow copyWithCompanion(CachedRecipesCompanion data) {
    return CachedRecipeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      json: data.json.present ? data.json.value : this.json,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedRecipeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('json: $json, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, imageUrl, updatedAt, json, lastOpenedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedRecipeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.updatedAt == this.updatedAt &&
          other.json == this.json &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class CachedRecipesCompanion extends UpdateCompanion<CachedRecipeRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<DateTime?> updatedAt;
  final Value<String> json;
  final Value<int> lastOpenedAt;
  const CachedRecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.json = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
  });
  CachedRecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.imageUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String json,
    required int lastOpenedAt,
  }) : name = Value(name),
       json = Value(json),
       lastOpenedAt = Value(lastOpenedAt);
  static Insertable<CachedRecipeRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<DateTime>? updatedAt,
    Expression<String>? json,
    Expression<int>? lastOpenedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (json != null) 'json': json,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
    });
  }

  CachedRecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? imageUrl,
    Value<DateTime?>? updatedAt,
    Value<String>? json,
    Value<int>? lastOpenedAt,
  }) {
    return CachedRecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      json: json ?? this.json,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<int>(lastOpenedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedRecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('json: $json, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }
}

class $CachedImagesTable extends CachedImages
    with TableInfo<$CachedImagesTable, CachedImageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [url, bytes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_image';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedImageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {url};
  @override
  CachedImageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedImageRow(
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
    );
  }

  @override
  $CachedImagesTable createAlias(String alias) {
    return $CachedImagesTable(attachedDatabase, alias);
  }
}

class CachedImageRow extends DataClass implements Insertable<CachedImageRow> {
  final String url;
  final Uint8List bytes;
  const CachedImageRow({required this.url, required this.bytes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['url'] = Variable<String>(url);
    map['bytes'] = Variable<Uint8List>(bytes);
    return map;
  }

  CachedImagesCompanion toCompanion(bool nullToAbsent) {
    return CachedImagesCompanion(url: Value(url), bytes: Value(bytes));
  }

  factory CachedImageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedImageRow(
      url: serializer.fromJson<String>(json['url']),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'url': serializer.toJson<String>(url),
      'bytes': serializer.toJson<Uint8List>(bytes),
    };
  }

  CachedImageRow copyWith({String? url, Uint8List? bytes}) =>
      CachedImageRow(url: url ?? this.url, bytes: bytes ?? this.bytes);
  CachedImageRow copyWithCompanion(CachedImagesCompanion data) {
    return CachedImageRow(
      url: data.url.present ? data.url.value : this.url,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedImageRow(')
          ..write('url: $url, ')
          ..write('bytes: $bytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(url, $driftBlobEquality.hash(bytes));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedImageRow &&
          other.url == this.url &&
          $driftBlobEquality.equals(other.bytes, this.bytes));
}

class CachedImagesCompanion extends UpdateCompanion<CachedImageRow> {
  final Value<String> url;
  final Value<Uint8List> bytes;
  final Value<int> rowid;
  const CachedImagesCompanion({
    this.url = const Value.absent(),
    this.bytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedImagesCompanion.insert({
    required String url,
    required Uint8List bytes,
    this.rowid = const Value.absent(),
  }) : url = Value(url),
       bytes = Value(bytes);
  static Insertable<CachedImageRow> custom({
    Expression<String>? url,
    Expression<Uint8List>? bytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (url != null) 'url': url,
      if (bytes != null) 'bytes': bytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedImagesCompanion copyWith({
    Value<String>? url,
    Value<Uint8List>? bytes,
    Value<int>? rowid,
  }) {
    return CachedImagesCompanion(
      url: url ?? this.url,
      bytes: bytes ?? this.bytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedImagesCompanion(')
          ..write('url: $url, ')
          ..write('bytes: $bytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSavedFiltersTable extends CachedSavedFilters
    with TableInfo<$CachedSavedFiltersTable, CachedSavedFilterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSavedFiltersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchMeta = const VerificationMeta('search');
  @override
  late final GeneratedColumn<String> search = GeneratedColumn<String>(
    'search',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownMeta = const VerificationMeta('own');
  @override
  late final GeneratedColumn<bool> own = GeneratedColumn<bool>(
    'own',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("own" IN (0, 1))',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, search, own, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_saved_filter';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSavedFilterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('search')) {
      context.handle(
        _searchMeta,
        search.isAcceptableOrUnknown(data['search']!, _searchMeta),
      );
    }
    if (data.containsKey('own')) {
      context.handle(
        _ownMeta,
        own.isAcceptableOrUnknown(data['own']!, _ownMeta),
      );
    } else if (isInserting) {
      context.missing(_ownMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSavedFilterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSavedFilterRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      search: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search'],
      ),
      own: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}own'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $CachedSavedFiltersTable createAlias(String alias) {
    return $CachedSavedFiltersTable(attachedDatabase, alias);
  }
}

class CachedSavedFilterRow extends DataClass
    implements Insertable<CachedSavedFilterRow> {
  final int id;
  final String name;

  /// The search as the `search` JSON of a saved search, `null` for one the
  /// filter chips can't show (`SavedFilter.query`).
  final String? search;
  final bool own;

  /// The position in the list.
  final int position;
  const CachedSavedFilterRow({
    required this.id,
    required this.name,
    this.search,
    required this.own,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || search != null) {
      map['search'] = Variable<String>(search);
    }
    map['own'] = Variable<bool>(own);
    map['position'] = Variable<int>(position);
    return map;
  }

  CachedSavedFiltersCompanion toCompanion(bool nullToAbsent) {
    return CachedSavedFiltersCompanion(
      id: Value(id),
      name: Value(name),
      search: search == null && nullToAbsent
          ? const Value.absent()
          : Value(search),
      own: Value(own),
      position: Value(position),
    );
  }

  factory CachedSavedFilterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSavedFilterRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      search: serializer.fromJson<String?>(json['search']),
      own: serializer.fromJson<bool>(json['own']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'search': serializer.toJson<String?>(search),
      'own': serializer.toJson<bool>(own),
      'position': serializer.toJson<int>(position),
    };
  }

  CachedSavedFilterRow copyWith({
    int? id,
    String? name,
    Value<String?> search = const Value.absent(),
    bool? own,
    int? position,
  }) => CachedSavedFilterRow(
    id: id ?? this.id,
    name: name ?? this.name,
    search: search.present ? search.value : this.search,
    own: own ?? this.own,
    position: position ?? this.position,
  );
  CachedSavedFilterRow copyWithCompanion(CachedSavedFiltersCompanion data) {
    return CachedSavedFilterRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      search: data.search.present ? data.search.value : this.search,
      own: data.own.present ? data.own.value : this.own,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSavedFilterRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('search: $search, ')
          ..write('own: $own, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, search, own, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSavedFilterRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.search == this.search &&
          other.own == this.own &&
          other.position == this.position);
}

class CachedSavedFiltersCompanion
    extends UpdateCompanion<CachedSavedFilterRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> search;
  final Value<bool> own;
  final Value<int> position;
  const CachedSavedFiltersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.search = const Value.absent(),
    this.own = const Value.absent(),
    this.position = const Value.absent(),
  });
  CachedSavedFiltersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.search = const Value.absent(),
    required bool own,
    required int position,
  }) : name = Value(name),
       own = Value(own),
       position = Value(position);
  static Insertable<CachedSavedFilterRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? search,
    Expression<bool>? own,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (search != null) 'search': search,
      if (own != null) 'own': own,
      if (position != null) 'position': position,
    });
  }

  CachedSavedFiltersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? search,
    Value<bool>? own,
    Value<int>? position,
  }) {
    return CachedSavedFiltersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      search: search ?? this.search,
      own: own ?? this.own,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (search.present) {
      map['search'] = Variable<String>(search.value);
    }
    if (own.present) {
      map['own'] = Variable<bool>(own.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSavedFiltersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('search: $search, ')
          ..write('own: $own, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $CachedMealPlansTable extends CachedMealPlans
    with TableInfo<$CachedMealPlansTable, CachedMealPlansRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMealPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fromDayMeta = const VerificationMeta(
    'fromDay',
  );
  @override
  late final GeneratedColumn<String> fromDay = GeneratedColumn<String>(
    'from_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toDayMeta = const VerificationMeta('toDay');
  @override
  late final GeneratedColumn<String> toDay = GeneratedColumn<String>(
    'to_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storedAtMeta = const VerificationMeta(
    'storedAt',
  );
  @override
  late final GeneratedColumn<int> storedAt = GeneratedColumn<int>(
    'stored_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fromDay, toDay, json, storedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_meal_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMealPlansRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('from_day')) {
      context.handle(
        _fromDayMeta,
        fromDay.isAcceptableOrUnknown(data['from_day']!, _fromDayMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDayMeta);
    }
    if (data.containsKey('to_day')) {
      context.handle(
        _toDayMeta,
        toDay.isAcceptableOrUnknown(data['to_day']!, _toDayMeta),
      );
    } else if (isInserting) {
      context.missing(_toDayMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('stored_at')) {
      context.handle(
        _storedAtMeta,
        storedAt.isAcceptableOrUnknown(data['stored_at']!, _storedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_storedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fromDay, toDay};
  @override
  CachedMealPlansRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMealPlansRow(
      fromDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_day'],
      )!,
      toDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_day'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      storedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stored_at'],
      )!,
    );
  }

  @override
  $CachedMealPlansTable createAlias(String alias) {
    return $CachedMealPlansTable(attachedDatabase, alias);
  }
}

class CachedMealPlansRow extends DataClass
    implements Insertable<CachedMealPlansRow> {
  /// The first and last day asked for, as `CalendarDay.toString`.
  final String fromDay;
  final String toDay;
  final String json;

  /// When they were read from the server, in milliseconds since the epoch;
  /// the oldest go first.
  final int storedAt;
  const CachedMealPlansRow({
    required this.fromDay,
    required this.toDay,
    required this.json,
    required this.storedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['from_day'] = Variable<String>(fromDay);
    map['to_day'] = Variable<String>(toDay);
    map['json'] = Variable<String>(json);
    map['stored_at'] = Variable<int>(storedAt);
    return map;
  }

  CachedMealPlansCompanion toCompanion(bool nullToAbsent) {
    return CachedMealPlansCompanion(
      fromDay: Value(fromDay),
      toDay: Value(toDay),
      json: Value(json),
      storedAt: Value(storedAt),
    );
  }

  factory CachedMealPlansRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMealPlansRow(
      fromDay: serializer.fromJson<String>(json['fromDay']),
      toDay: serializer.fromJson<String>(json['toDay']),
      json: serializer.fromJson<String>(json['json']),
      storedAt: serializer.fromJson<int>(json['storedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fromDay': serializer.toJson<String>(fromDay),
      'toDay': serializer.toJson<String>(toDay),
      'json': serializer.toJson<String>(json),
      'storedAt': serializer.toJson<int>(storedAt),
    };
  }

  CachedMealPlansRow copyWith({
    String? fromDay,
    String? toDay,
    String? json,
    int? storedAt,
  }) => CachedMealPlansRow(
    fromDay: fromDay ?? this.fromDay,
    toDay: toDay ?? this.toDay,
    json: json ?? this.json,
    storedAt: storedAt ?? this.storedAt,
  );
  CachedMealPlansRow copyWithCompanion(CachedMealPlansCompanion data) {
    return CachedMealPlansRow(
      fromDay: data.fromDay.present ? data.fromDay.value : this.fromDay,
      toDay: data.toDay.present ? data.toDay.value : this.toDay,
      json: data.json.present ? data.json.value : this.json,
      storedAt: data.storedAt.present ? data.storedAt.value : this.storedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMealPlansRow(')
          ..write('fromDay: $fromDay, ')
          ..write('toDay: $toDay, ')
          ..write('json: $json, ')
          ..write('storedAt: $storedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fromDay, toDay, json, storedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMealPlansRow &&
          other.fromDay == this.fromDay &&
          other.toDay == this.toDay &&
          other.json == this.json &&
          other.storedAt == this.storedAt);
}

class CachedMealPlansCompanion extends UpdateCompanion<CachedMealPlansRow> {
  final Value<String> fromDay;
  final Value<String> toDay;
  final Value<String> json;
  final Value<int> storedAt;
  final Value<int> rowid;
  const CachedMealPlansCompanion({
    this.fromDay = const Value.absent(),
    this.toDay = const Value.absent(),
    this.json = const Value.absent(),
    this.storedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMealPlansCompanion.insert({
    required String fromDay,
    required String toDay,
    required String json,
    required int storedAt,
    this.rowid = const Value.absent(),
  }) : fromDay = Value(fromDay),
       toDay = Value(toDay),
       json = Value(json),
       storedAt = Value(storedAt);
  static Insertable<CachedMealPlansRow> custom({
    Expression<String>? fromDay,
    Expression<String>? toDay,
    Expression<String>? json,
    Expression<int>? storedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fromDay != null) 'from_day': fromDay,
      if (toDay != null) 'to_day': toDay,
      if (json != null) 'json': json,
      if (storedAt != null) 'stored_at': storedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMealPlansCompanion copyWith({
    Value<String>? fromDay,
    Value<String>? toDay,
    Value<String>? json,
    Value<int>? storedAt,
    Value<int>? rowid,
  }) {
    return CachedMealPlansCompanion(
      fromDay: fromDay ?? this.fromDay,
      toDay: toDay ?? this.toDay,
      json: json ?? this.json,
      storedAt: storedAt ?? this.storedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fromDay.present) {
      map['from_day'] = Variable<String>(fromDay.value);
    }
    if (toDay.present) {
      map['to_day'] = Variable<String>(toDay.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (storedAt.present) {
      map['stored_at'] = Variable<int>(storedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMealPlansCompanion(')
          ..write('fromDay: $fromDay, ')
          ..write('toDay: $toDay, ')
          ..write('json: $json, ')
          ..write('storedAt: $storedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedShoppingEntriesTable extends CachedShoppingEntries
    with TableInfo<$CachedShoppingEntriesTable, CachedShoppingEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedShoppingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, position, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_shopping_entry';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedShoppingEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedShoppingEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedShoppingEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $CachedShoppingEntriesTable createAlias(String alias) {
    return $CachedShoppingEntriesTable(attachedDatabase, alias);
  }
}

class CachedShoppingEntryRow extends DataClass
    implements Insertable<CachedShoppingEntryRow> {
  final int id;

  /// The position in the list, as the server sent it.
  final int position;
  final String json;
  const CachedShoppingEntryRow({
    required this.id,
    required this.position,
    required this.json,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['position'] = Variable<int>(position);
    map['json'] = Variable<String>(json);
    return map;
  }

  CachedShoppingEntriesCompanion toCompanion(bool nullToAbsent) {
    return CachedShoppingEntriesCompanion(
      id: Value(id),
      position: Value(position),
      json: Value(json),
    );
  }

  factory CachedShoppingEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedShoppingEntryRow(
      id: serializer.fromJson<int>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'position': serializer.toJson<int>(position),
      'json': serializer.toJson<String>(json),
    };
  }

  CachedShoppingEntryRow copyWith({int? id, int? position, String? json}) =>
      CachedShoppingEntryRow(
        id: id ?? this.id,
        position: position ?? this.position,
        json: json ?? this.json,
      );
  CachedShoppingEntryRow copyWithCompanion(
    CachedShoppingEntriesCompanion data,
  ) {
    return CachedShoppingEntryRow(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedShoppingEntryRow(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, position, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedShoppingEntryRow &&
          other.id == this.id &&
          other.position == this.position &&
          other.json == this.json);
}

class CachedShoppingEntriesCompanion
    extends UpdateCompanion<CachedShoppingEntryRow> {
  final Value<int> id;
  final Value<int> position;
  final Value<String> json;
  const CachedShoppingEntriesCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.json = const Value.absent(),
  });
  CachedShoppingEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int position,
    required String json,
  }) : position = Value(position),
       json = Value(json);
  static Insertable<CachedShoppingEntryRow> custom({
    Expression<int>? id,
    Expression<int>? position,
    Expression<String>? json,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (json != null) 'json': json,
    });
  }

  CachedShoppingEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? position,
    Value<String>? json,
  }) {
    return CachedShoppingEntriesCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      json: json ?? this.json,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedShoppingEntriesCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }
}

class $CachedValuesTable extends CachedValues
    with TableInfo<$CachedValuesTable, CachedValueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_value';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedValueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CachedValueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedValueRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $CachedValuesTable createAlias(String alias) {
    return $CachedValuesTable(attachedDatabase, alias);
  }
}

class CachedValueRow extends DataClass implements Insertable<CachedValueRow> {
  final String key;
  final String json;
  const CachedValueRow({required this.key, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['json'] = Variable<String>(json);
    return map;
  }

  CachedValuesCompanion toCompanion(bool nullToAbsent) {
    return CachedValuesCompanion(key: Value(key), json: Value(json));
  }

  factory CachedValueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedValueRow(
      key: serializer.fromJson<String>(json['key']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'json': serializer.toJson<String>(json),
    };
  }

  CachedValueRow copyWith({String? key, String? json}) =>
      CachedValueRow(key: key ?? this.key, json: json ?? this.json);
  CachedValueRow copyWithCompanion(CachedValuesCompanion data) {
    return CachedValueRow(
      key: data.key.present ? data.key.value : this.key,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedValueRow(')
          ..write('key: $key, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedValueRow &&
          other.key == this.key &&
          other.json == this.json);
}

class CachedValuesCompanion extends UpdateCompanion<CachedValueRow> {
  final Value<String> key;
  final Value<String> json;
  final Value<int> rowid;
  const CachedValuesCompanion({
    this.key = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedValuesCompanion.insert({
    required String key,
    required String json,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       json = Value(json);
  static Insertable<CachedValueRow> custom({
    Expression<String>? key,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedValuesCompanion copyWith({
    Value<String>? key,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return CachedValuesCompanion(
      key: key ?? this.key,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedValuesCompanion(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EditorDraftsTable extends EditorDrafts
    with TableInfo<$EditorDraftsTable, EditorDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditorDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUpdatedAtMeta = const VerificationMeta(
    'baseUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> baseUpdatedAt = GeneratedColumn<int>(
    'base_updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageBytesMeta = const VerificationMeta(
    'imageBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> imageBytes = GeneratedColumn<Uint8List>(
    'image_bytes',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageFileNameMeta = const VerificationMeta(
    'imageFileName',
  );
  @override
  late final GeneratedColumn<String> imageFileName = GeneratedColumn<String>(
    'image_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageMimeTypeMeta = const VerificationMeta(
    'imageMimeType',
  );
  @override
  late final GeneratedColumn<String> imageMimeType = GeneratedColumn<String>(
    'image_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _removeImageMeta = const VerificationMeta(
    'removeImage',
  );
  @override
  late final GeneratedColumn<bool> removeImage = GeneratedColumn<bool>(
    'remove_image',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remove_image" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    recipeId,
    json,
    savedAt,
    baseUpdatedAt,
    imageBytes,
    imageFileName,
    imageMimeType,
    removeImage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'editor_draft';
  @override
  VerificationContext validateIntegrity(
    Insertable<EditorDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    if (data.containsKey('base_updated_at')) {
      context.handle(
        _baseUpdatedAtMeta,
        baseUpdatedAt.isAcceptableOrUnknown(
          data['base_updated_at']!,
          _baseUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('image_bytes')) {
      context.handle(
        _imageBytesMeta,
        imageBytes.isAcceptableOrUnknown(data['image_bytes']!, _imageBytesMeta),
      );
    }
    if (data.containsKey('image_file_name')) {
      context.handle(
        _imageFileNameMeta,
        imageFileName.isAcceptableOrUnknown(
          data['image_file_name']!,
          _imageFileNameMeta,
        ),
      );
    }
    if (data.containsKey('image_mime_type')) {
      context.handle(
        _imageMimeTypeMeta,
        imageMimeType.isAcceptableOrUnknown(
          data['image_mime_type']!,
          _imageMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('remove_image')) {
      context.handle(
        _removeImageMeta,
        removeImage.isAcceptableOrUnknown(
          data['remove_image']!,
          _removeImageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_removeImageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId};
  @override
  EditorDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EditorDraftRow(
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
      baseUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_updated_at'],
      ),
      imageBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}image_bytes'],
      ),
      imageFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_file_name'],
      ),
      imageMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_mime_type'],
      ),
      removeImage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remove_image'],
      )!,
    );
  }

  @override
  $EditorDraftsTable createAlias(String alias) {
    return $EditorDraftsTable(attachedDatabase, alias);
  }
}

class EditorDraftRow extends DataClass implements Insertable<EditorDraftRow> {
  /// The recipe's id; [newRecipeDraftId] for a new recipe.
  final int recipeId;

  /// The `RecipeDraft` as JSON.
  final String json;
  final DateTime savedAt;

  /// `StoredDraft.baseUpdatedAt` in microseconds since the epoch: exact,
  /// to compare with the recipe's (a date time column keeps only seconds).
  final int? baseUpdatedAt;

  /// A photo chosen to replace the recipe's, with its name and type.
  final Uint8List? imageBytes;
  final String? imageFileName;
  final String? imageMimeType;
  final bool removeImage;
  const EditorDraftRow({
    required this.recipeId,
    required this.json,
    required this.savedAt,
    this.baseUpdatedAt,
    this.imageBytes,
    this.imageFileName,
    this.imageMimeType,
    required this.removeImage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<int>(recipeId);
    map['json'] = Variable<String>(json);
    map['saved_at'] = Variable<DateTime>(savedAt);
    if (!nullToAbsent || baseUpdatedAt != null) {
      map['base_updated_at'] = Variable<int>(baseUpdatedAt);
    }
    if (!nullToAbsent || imageBytes != null) {
      map['image_bytes'] = Variable<Uint8List>(imageBytes);
    }
    if (!nullToAbsent || imageFileName != null) {
      map['image_file_name'] = Variable<String>(imageFileName);
    }
    if (!nullToAbsent || imageMimeType != null) {
      map['image_mime_type'] = Variable<String>(imageMimeType);
    }
    map['remove_image'] = Variable<bool>(removeImage);
    return map;
  }

  EditorDraftsCompanion toCompanion(bool nullToAbsent) {
    return EditorDraftsCompanion(
      recipeId: Value(recipeId),
      json: Value(json),
      savedAt: Value(savedAt),
      baseUpdatedAt: baseUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUpdatedAt),
      imageBytes: imageBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(imageBytes),
      imageFileName: imageFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(imageFileName),
      imageMimeType: imageMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(imageMimeType),
      removeImage: Value(removeImage),
    );
  }

  factory EditorDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EditorDraftRow(
      recipeId: serializer.fromJson<int>(json['recipeId']),
      json: serializer.fromJson<String>(json['json']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
      baseUpdatedAt: serializer.fromJson<int?>(json['baseUpdatedAt']),
      imageBytes: serializer.fromJson<Uint8List?>(json['imageBytes']),
      imageFileName: serializer.fromJson<String?>(json['imageFileName']),
      imageMimeType: serializer.fromJson<String?>(json['imageMimeType']),
      removeImage: serializer.fromJson<bool>(json['removeImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<int>(recipeId),
      'json': serializer.toJson<String>(json),
      'savedAt': serializer.toJson<DateTime>(savedAt),
      'baseUpdatedAt': serializer.toJson<int?>(baseUpdatedAt),
      'imageBytes': serializer.toJson<Uint8List?>(imageBytes),
      'imageFileName': serializer.toJson<String?>(imageFileName),
      'imageMimeType': serializer.toJson<String?>(imageMimeType),
      'removeImage': serializer.toJson<bool>(removeImage),
    };
  }

  EditorDraftRow copyWith({
    int? recipeId,
    String? json,
    DateTime? savedAt,
    Value<int?> baseUpdatedAt = const Value.absent(),
    Value<Uint8List?> imageBytes = const Value.absent(),
    Value<String?> imageFileName = const Value.absent(),
    Value<String?> imageMimeType = const Value.absent(),
    bool? removeImage,
  }) => EditorDraftRow(
    recipeId: recipeId ?? this.recipeId,
    json: json ?? this.json,
    savedAt: savedAt ?? this.savedAt,
    baseUpdatedAt: baseUpdatedAt.present
        ? baseUpdatedAt.value
        : this.baseUpdatedAt,
    imageBytes: imageBytes.present ? imageBytes.value : this.imageBytes,
    imageFileName: imageFileName.present
        ? imageFileName.value
        : this.imageFileName,
    imageMimeType: imageMimeType.present
        ? imageMimeType.value
        : this.imageMimeType,
    removeImage: removeImage ?? this.removeImage,
  );
  EditorDraftRow copyWithCompanion(EditorDraftsCompanion data) {
    return EditorDraftRow(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      json: data.json.present ? data.json.value : this.json,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
      baseUpdatedAt: data.baseUpdatedAt.present
          ? data.baseUpdatedAt.value
          : this.baseUpdatedAt,
      imageBytes: data.imageBytes.present
          ? data.imageBytes.value
          : this.imageBytes,
      imageFileName: data.imageFileName.present
          ? data.imageFileName.value
          : this.imageFileName,
      imageMimeType: data.imageMimeType.present
          ? data.imageMimeType.value
          : this.imageMimeType,
      removeImage: data.removeImage.present
          ? data.removeImage.value
          : this.removeImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EditorDraftRow(')
          ..write('recipeId: $recipeId, ')
          ..write('json: $json, ')
          ..write('savedAt: $savedAt, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('imageFileName: $imageFileName, ')
          ..write('imageMimeType: $imageMimeType, ')
          ..write('removeImage: $removeImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    recipeId,
    json,
    savedAt,
    baseUpdatedAt,
    $driftBlobEquality.hash(imageBytes),
    imageFileName,
    imageMimeType,
    removeImage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EditorDraftRow &&
          other.recipeId == this.recipeId &&
          other.json == this.json &&
          other.savedAt == this.savedAt &&
          other.baseUpdatedAt == this.baseUpdatedAt &&
          $driftBlobEquality.equals(other.imageBytes, this.imageBytes) &&
          other.imageFileName == this.imageFileName &&
          other.imageMimeType == this.imageMimeType &&
          other.removeImage == this.removeImage);
}

class EditorDraftsCompanion extends UpdateCompanion<EditorDraftRow> {
  final Value<int> recipeId;
  final Value<String> json;
  final Value<DateTime> savedAt;
  final Value<int?> baseUpdatedAt;
  final Value<Uint8List?> imageBytes;
  final Value<String?> imageFileName;
  final Value<String?> imageMimeType;
  final Value<bool> removeImage;
  const EditorDraftsCompanion({
    this.recipeId = const Value.absent(),
    this.json = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.baseUpdatedAt = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.imageFileName = const Value.absent(),
    this.imageMimeType = const Value.absent(),
    this.removeImage = const Value.absent(),
  });
  EditorDraftsCompanion.insert({
    this.recipeId = const Value.absent(),
    required String json,
    required DateTime savedAt,
    this.baseUpdatedAt = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.imageFileName = const Value.absent(),
    this.imageMimeType = const Value.absent(),
    required bool removeImage,
  }) : json = Value(json),
       savedAt = Value(savedAt),
       removeImage = Value(removeImage);
  static Insertable<EditorDraftRow> custom({
    Expression<int>? recipeId,
    Expression<String>? json,
    Expression<DateTime>? savedAt,
    Expression<int>? baseUpdatedAt,
    Expression<Uint8List>? imageBytes,
    Expression<String>? imageFileName,
    Expression<String>? imageMimeType,
    Expression<bool>? removeImage,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (json != null) 'json': json,
      if (savedAt != null) 'saved_at': savedAt,
      if (baseUpdatedAt != null) 'base_updated_at': baseUpdatedAt,
      if (imageBytes != null) 'image_bytes': imageBytes,
      if (imageFileName != null) 'image_file_name': imageFileName,
      if (imageMimeType != null) 'image_mime_type': imageMimeType,
      if (removeImage != null) 'remove_image': removeImage,
    });
  }

  EditorDraftsCompanion copyWith({
    Value<int>? recipeId,
    Value<String>? json,
    Value<DateTime>? savedAt,
    Value<int?>? baseUpdatedAt,
    Value<Uint8List?>? imageBytes,
    Value<String?>? imageFileName,
    Value<String?>? imageMimeType,
    Value<bool>? removeImage,
  }) {
    return EditorDraftsCompanion(
      recipeId: recipeId ?? this.recipeId,
      json: json ?? this.json,
      savedAt: savedAt ?? this.savedAt,
      baseUpdatedAt: baseUpdatedAt ?? this.baseUpdatedAt,
      imageBytes: imageBytes ?? this.imageBytes,
      imageFileName: imageFileName ?? this.imageFileName,
      imageMimeType: imageMimeType ?? this.imageMimeType,
      removeImage: removeImage ?? this.removeImage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (baseUpdatedAt.present) {
      map['base_updated_at'] = Variable<int>(baseUpdatedAt.value);
    }
    if (imageBytes.present) {
      map['image_bytes'] = Variable<Uint8List>(imageBytes.value);
    }
    if (imageFileName.present) {
      map['image_file_name'] = Variable<String>(imageFileName.value);
    }
    if (imageMimeType.present) {
      map['image_mime_type'] = Variable<String>(imageMimeType.value);
    }
    if (removeImage.present) {
      map['remove_image'] = Variable<bool>(removeImage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditorDraftsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('json: $json, ')
          ..write('savedAt: $savedAt, ')
          ..write('baseUpdatedAt: $baseUpdatedAt, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('imageFileName: $imageFileName, ')
          ..write('imageMimeType: $imageMimeType, ')
          ..write('removeImage: $removeImage')
          ..write(')'))
        .toString();
  }
}

abstract class _$CacheDatabase extends GeneratedDatabase {
  _$CacheDatabase(QueryExecutor e) : super(e);
  $CacheDatabaseManager get managers => $CacheDatabaseManager(this);
  late final $CachedRecipesTable cachedRecipes = $CachedRecipesTable(this);
  late final $CachedImagesTable cachedImages = $CachedImagesTable(this);
  late final $CachedSavedFiltersTable cachedSavedFilters =
      $CachedSavedFiltersTable(this);
  late final $CachedMealPlansTable cachedMealPlans = $CachedMealPlansTable(
    this,
  );
  late final $CachedShoppingEntriesTable cachedShoppingEntries =
      $CachedShoppingEntriesTable(this);
  late final $CachedValuesTable cachedValues = $CachedValuesTable(this);
  late final $EditorDraftsTable editorDrafts = $EditorDraftsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedRecipes,
    cachedImages,
    cachedSavedFilters,
    cachedMealPlans,
    cachedShoppingEntries,
    cachedValues,
    editorDrafts,
  ];
}

typedef $$CachedRecipesTableCreateCompanionBuilder =
    CachedRecipesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> imageUrl,
      Value<DateTime?> updatedAt,
      required String json,
      required int lastOpenedAt,
    });
typedef $$CachedRecipesTableUpdateCompanionBuilder =
    CachedRecipesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> imageUrl,
      Value<DateTime?> updatedAt,
      Value<String> json,
      Value<int> lastOpenedAt,
    });

class $$CachedRecipesTableFilterComposer
    extends Composer<_$CacheDatabase, $CachedRecipesTable> {
  $$CachedRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedRecipesTableOrderingComposer
    extends Composer<_$CacheDatabase, $CachedRecipesTable> {
  $$CachedRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedRecipesTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CachedRecipesTable> {
  $$CachedRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<int> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );
}

class $$CachedRecipesTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CachedRecipesTable,
          CachedRecipeRow,
          $$CachedRecipesTableFilterComposer,
          $$CachedRecipesTableOrderingComposer,
          $$CachedRecipesTableAnnotationComposer,
          $$CachedRecipesTableCreateCompanionBuilder,
          $$CachedRecipesTableUpdateCompanionBuilder,
          (
            CachedRecipeRow,
            BaseReferences<
              _$CacheDatabase,
              $CachedRecipesTable,
              CachedRecipeRow
            >,
          ),
          CachedRecipeRow,
          PrefetchHooks Function()
        > {
  $$CachedRecipesTableTableManager(
    _$CacheDatabase db,
    $CachedRecipesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> lastOpenedAt = const Value.absent(),
              }) => CachedRecipesCompanion(
                id: id,
                name: name,
                imageUrl: imageUrl,
                updatedAt: updatedAt,
                json: json,
                lastOpenedAt: lastOpenedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required String json,
                required int lastOpenedAt,
              }) => CachedRecipesCompanion.insert(
                id: id,
                name: name,
                imageUrl: imageUrl,
                updatedAt: updatedAt,
                json: json,
                lastOpenedAt: lastOpenedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedRecipesTable, CachedRecipeRow>(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $CachedRecipesTable,
                    CachedRecipeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedRecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CachedRecipesTable,
      CachedRecipeRow,
      $$CachedRecipesTableFilterComposer,
      $$CachedRecipesTableOrderingComposer,
      $$CachedRecipesTableAnnotationComposer,
      $$CachedRecipesTableCreateCompanionBuilder,
      $$CachedRecipesTableUpdateCompanionBuilder,
      (
        CachedRecipeRow,
        BaseReferences<_$CacheDatabase, $CachedRecipesTable, CachedRecipeRow>,
      ),
      CachedRecipeRow,
      PrefetchHooks Function()
    >;
typedef $$CachedImagesTableCreateCompanionBuilder =
    CachedImagesCompanion Function({
      required String url,
      required Uint8List bytes,
      Value<int> rowid,
    });
typedef $$CachedImagesTableUpdateCompanionBuilder =
    CachedImagesCompanion Function({
      Value<String> url,
      Value<Uint8List> bytes,
      Value<int> rowid,
    });

class $$CachedImagesTableFilterComposer
    extends Composer<_$CacheDatabase, $CachedImagesTable> {
  $$CachedImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedImagesTableOrderingComposer
    extends Composer<_$CacheDatabase, $CachedImagesTable> {
  $$CachedImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedImagesTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CachedImagesTable> {
  $$CachedImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);
}

class $$CachedImagesTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CachedImagesTable,
          CachedImageRow,
          $$CachedImagesTableFilterComposer,
          $$CachedImagesTableOrderingComposer,
          $$CachedImagesTableAnnotationComposer,
          $$CachedImagesTableCreateCompanionBuilder,
          $$CachedImagesTableUpdateCompanionBuilder,
          (
            CachedImageRow,
            BaseReferences<_$CacheDatabase, $CachedImagesTable, CachedImageRow>,
          ),
          CachedImageRow,
          PrefetchHooks Function()
        > {
  $$CachedImagesTableTableManager(_$CacheDatabase db, $CachedImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> url = const Value.absent(),
            Value<Uint8List> bytes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CachedImagesCompanion(url: url, bytes: bytes, rowid: rowid),
          createCompanionCallback:
              ({
                required String url,
                required Uint8List bytes,
                Value<int> rowid = const Value.absent(),
              }) => CachedImagesCompanion.insert(
                url: url,
                bytes: bytes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedImagesTable, CachedImageRow>(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $CachedImagesTable,
                    CachedImageRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CachedImagesTable,
      CachedImageRow,
      $$CachedImagesTableFilterComposer,
      $$CachedImagesTableOrderingComposer,
      $$CachedImagesTableAnnotationComposer,
      $$CachedImagesTableCreateCompanionBuilder,
      $$CachedImagesTableUpdateCompanionBuilder,
      (
        CachedImageRow,
        BaseReferences<_$CacheDatabase, $CachedImagesTable, CachedImageRow>,
      ),
      CachedImageRow,
      PrefetchHooks Function()
    >;
typedef $$CachedSavedFiltersTableCreateCompanionBuilder =
    CachedSavedFiltersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> search,
      required bool own,
      required int position,
    });
typedef $$CachedSavedFiltersTableUpdateCompanionBuilder =
    CachedSavedFiltersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> search,
      Value<bool> own,
      Value<int> position,
    });

class $$CachedSavedFiltersTableFilterComposer
    extends Composer<_$CacheDatabase, $CachedSavedFiltersTable> {
  $$CachedSavedFiltersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get search => $composableBuilder(
    column: $table.search,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get own => $composableBuilder(
    column: $table.own,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSavedFiltersTableOrderingComposer
    extends Composer<_$CacheDatabase, $CachedSavedFiltersTable> {
  $$CachedSavedFiltersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get search => $composableBuilder(
    column: $table.search,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get own => $composableBuilder(
    column: $table.own,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSavedFiltersTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CachedSavedFiltersTable> {
  $$CachedSavedFiltersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get search =>
      $composableBuilder(column: $table.search, builder: (column) => column);

  GeneratedColumn<bool> get own =>
      $composableBuilder(column: $table.own, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CachedSavedFiltersTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CachedSavedFiltersTable,
          CachedSavedFilterRow,
          $$CachedSavedFiltersTableFilterComposer,
          $$CachedSavedFiltersTableOrderingComposer,
          $$CachedSavedFiltersTableAnnotationComposer,
          $$CachedSavedFiltersTableCreateCompanionBuilder,
          $$CachedSavedFiltersTableUpdateCompanionBuilder,
          (
            CachedSavedFilterRow,
            BaseReferences<
              _$CacheDatabase,
              $CachedSavedFiltersTable,
              CachedSavedFilterRow
            >,
          ),
          CachedSavedFilterRow,
          PrefetchHooks Function()
        > {
  $$CachedSavedFiltersTableTableManager(
    _$CacheDatabase db,
    $CachedSavedFiltersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSavedFiltersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSavedFiltersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSavedFiltersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> search = const Value.absent(),
                Value<bool> own = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => CachedSavedFiltersCompanion(
                id: id,
                name: name,
                search: search,
                own: own,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> search = const Value.absent(),
                required bool own,
                required int position,
              }) => CachedSavedFiltersCompanion.insert(
                id: id,
                name: name,
                search: search,
                own: own,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedSavedFiltersTable, CachedSavedFilterRow>(
                    table,
                  ),
                  BaseReferences<
                    _$CacheDatabase,
                    $CachedSavedFiltersTable,
                    CachedSavedFilterRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSavedFiltersTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CachedSavedFiltersTable,
      CachedSavedFilterRow,
      $$CachedSavedFiltersTableFilterComposer,
      $$CachedSavedFiltersTableOrderingComposer,
      $$CachedSavedFiltersTableAnnotationComposer,
      $$CachedSavedFiltersTableCreateCompanionBuilder,
      $$CachedSavedFiltersTableUpdateCompanionBuilder,
      (
        CachedSavedFilterRow,
        BaseReferences<
          _$CacheDatabase,
          $CachedSavedFiltersTable,
          CachedSavedFilterRow
        >,
      ),
      CachedSavedFilterRow,
      PrefetchHooks Function()
    >;
typedef $$CachedMealPlansTableCreateCompanionBuilder =
    CachedMealPlansCompanion Function({
      required String fromDay,
      required String toDay,
      required String json,
      required int storedAt,
      Value<int> rowid,
    });
typedef $$CachedMealPlansTableUpdateCompanionBuilder =
    CachedMealPlansCompanion Function({
      Value<String> fromDay,
      Value<String> toDay,
      Value<String> json,
      Value<int> storedAt,
      Value<int> rowid,
    });

class $$CachedMealPlansTableFilterComposer
    extends Composer<_$CacheDatabase, $CachedMealPlansTable> {
  $$CachedMealPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fromDay => $composableBuilder(
    column: $table.fromDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toDay => $composableBuilder(
    column: $table.toDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get storedAt => $composableBuilder(
    column: $table.storedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMealPlansTableOrderingComposer
    extends Composer<_$CacheDatabase, $CachedMealPlansTable> {
  $$CachedMealPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fromDay => $composableBuilder(
    column: $table.fromDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toDay => $composableBuilder(
    column: $table.toDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get storedAt => $composableBuilder(
    column: $table.storedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMealPlansTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CachedMealPlansTable> {
  $$CachedMealPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fromDay =>
      $composableBuilder(column: $table.fromDay, builder: (column) => column);

  GeneratedColumn<String> get toDay =>
      $composableBuilder(column: $table.toDay, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<int> get storedAt =>
      $composableBuilder(column: $table.storedAt, builder: (column) => column);
}

class $$CachedMealPlansTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CachedMealPlansTable,
          CachedMealPlansRow,
          $$CachedMealPlansTableFilterComposer,
          $$CachedMealPlansTableOrderingComposer,
          $$CachedMealPlansTableAnnotationComposer,
          $$CachedMealPlansTableCreateCompanionBuilder,
          $$CachedMealPlansTableUpdateCompanionBuilder,
          (
            CachedMealPlansRow,
            BaseReferences<
              _$CacheDatabase,
              $CachedMealPlansTable,
              CachedMealPlansRow
            >,
          ),
          CachedMealPlansRow,
          PrefetchHooks Function()
        > {
  $$CachedMealPlansTableTableManager(
    _$CacheDatabase db,
    $CachedMealPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMealPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMealPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMealPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fromDay = const Value.absent(),
                Value<String> toDay = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> storedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMealPlansCompanion(
                fromDay: fromDay,
                toDay: toDay,
                json: json,
                storedAt: storedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fromDay,
                required String toDay,
                required String json,
                required int storedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedMealPlansCompanion.insert(
                fromDay: fromDay,
                toDay: toDay,
                json: json,
                storedAt: storedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedMealPlansTable, CachedMealPlansRow>(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $CachedMealPlansTable,
                    CachedMealPlansRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMealPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CachedMealPlansTable,
      CachedMealPlansRow,
      $$CachedMealPlansTableFilterComposer,
      $$CachedMealPlansTableOrderingComposer,
      $$CachedMealPlansTableAnnotationComposer,
      $$CachedMealPlansTableCreateCompanionBuilder,
      $$CachedMealPlansTableUpdateCompanionBuilder,
      (
        CachedMealPlansRow,
        BaseReferences<
          _$CacheDatabase,
          $CachedMealPlansTable,
          CachedMealPlansRow
        >,
      ),
      CachedMealPlansRow,
      PrefetchHooks Function()
    >;
typedef $$CachedShoppingEntriesTableCreateCompanionBuilder =
    CachedShoppingEntriesCompanion Function({
      Value<int> id,
      required int position,
      required String json,
    });
typedef $$CachedShoppingEntriesTableUpdateCompanionBuilder =
    CachedShoppingEntriesCompanion Function({
      Value<int> id,
      Value<int> position,
      Value<String> json,
    });

class $$CachedShoppingEntriesTableFilterComposer
    extends Composer<_$CacheDatabase, $CachedShoppingEntriesTable> {
  $$CachedShoppingEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedShoppingEntriesTableOrderingComposer
    extends Composer<_$CacheDatabase, $CachedShoppingEntriesTable> {
  $$CachedShoppingEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedShoppingEntriesTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CachedShoppingEntriesTable> {
  $$CachedShoppingEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$CachedShoppingEntriesTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CachedShoppingEntriesTable,
          CachedShoppingEntryRow,
          $$CachedShoppingEntriesTableFilterComposer,
          $$CachedShoppingEntriesTableOrderingComposer,
          $$CachedShoppingEntriesTableAnnotationComposer,
          $$CachedShoppingEntriesTableCreateCompanionBuilder,
          $$CachedShoppingEntriesTableUpdateCompanionBuilder,
          (
            CachedShoppingEntryRow,
            BaseReferences<
              _$CacheDatabase,
              $CachedShoppingEntriesTable,
              CachedShoppingEntryRow
            >,
          ),
          CachedShoppingEntryRow,
          PrefetchHooks Function()
        > {
  $$CachedShoppingEntriesTableTableManager(
    _$CacheDatabase db,
    $CachedShoppingEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedShoppingEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedShoppingEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedShoppingEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> json = const Value.absent(),
              }) => CachedShoppingEntriesCompanion(
                id: id,
                position: position,
                json: json,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int position,
                required String json,
              }) => CachedShoppingEntriesCompanion.insert(
                id: id,
                position: position,
                json: json,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CachedShoppingEntriesTable,
                    CachedShoppingEntryRow
                  >(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $CachedShoppingEntriesTable,
                    CachedShoppingEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedShoppingEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CachedShoppingEntriesTable,
      CachedShoppingEntryRow,
      $$CachedShoppingEntriesTableFilterComposer,
      $$CachedShoppingEntriesTableOrderingComposer,
      $$CachedShoppingEntriesTableAnnotationComposer,
      $$CachedShoppingEntriesTableCreateCompanionBuilder,
      $$CachedShoppingEntriesTableUpdateCompanionBuilder,
      (
        CachedShoppingEntryRow,
        BaseReferences<
          _$CacheDatabase,
          $CachedShoppingEntriesTable,
          CachedShoppingEntryRow
        >,
      ),
      CachedShoppingEntryRow,
      PrefetchHooks Function()
    >;
typedef $$CachedValuesTableCreateCompanionBuilder =
    CachedValuesCompanion Function({
      required String key,
      required String json,
      Value<int> rowid,
    });
typedef $$CachedValuesTableUpdateCompanionBuilder =
    CachedValuesCompanion Function({
      Value<String> key,
      Value<String> json,
      Value<int> rowid,
    });

class $$CachedValuesTableFilterComposer
    extends Composer<_$CacheDatabase, $CachedValuesTable> {
  $$CachedValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedValuesTableOrderingComposer
    extends Composer<_$CacheDatabase, $CachedValuesTable> {
  $$CachedValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedValuesTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CachedValuesTable> {
  $$CachedValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$CachedValuesTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CachedValuesTable,
          CachedValueRow,
          $$CachedValuesTableFilterComposer,
          $$CachedValuesTableOrderingComposer,
          $$CachedValuesTableAnnotationComposer,
          $$CachedValuesTableCreateCompanionBuilder,
          $$CachedValuesTableUpdateCompanionBuilder,
          (
            CachedValueRow,
            BaseReferences<_$CacheDatabase, $CachedValuesTable, CachedValueRow>,
          ),
          CachedValueRow,
          PrefetchHooks Function()
        > {
  $$CachedValuesTableTableManager(_$CacheDatabase db, $CachedValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CachedValuesCompanion(key: key, json: json, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => CachedValuesCompanion.insert(
                key: key,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedValuesTable, CachedValueRow>(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $CachedValuesTable,
                    CachedValueRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CachedValuesTable,
      CachedValueRow,
      $$CachedValuesTableFilterComposer,
      $$CachedValuesTableOrderingComposer,
      $$CachedValuesTableAnnotationComposer,
      $$CachedValuesTableCreateCompanionBuilder,
      $$CachedValuesTableUpdateCompanionBuilder,
      (
        CachedValueRow,
        BaseReferences<_$CacheDatabase, $CachedValuesTable, CachedValueRow>,
      ),
      CachedValueRow,
      PrefetchHooks Function()
    >;
typedef $$EditorDraftsTableCreateCompanionBuilder =
    EditorDraftsCompanion Function({
      Value<int> recipeId,
      required String json,
      required DateTime savedAt,
      Value<int?> baseUpdatedAt,
      Value<Uint8List?> imageBytes,
      Value<String?> imageFileName,
      Value<String?> imageMimeType,
      required bool removeImage,
    });
typedef $$EditorDraftsTableUpdateCompanionBuilder =
    EditorDraftsCompanion Function({
      Value<int> recipeId,
      Value<String> json,
      Value<DateTime> savedAt,
      Value<int?> baseUpdatedAt,
      Value<Uint8List?> imageBytes,
      Value<String?> imageFileName,
      Value<String?> imageMimeType,
      Value<bool> removeImage,
    });

class $$EditorDraftsTableFilterComposer
    extends Composer<_$CacheDatabase, $EditorDraftsTable> {
  $$EditorDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageFileName => $composableBuilder(
    column: $table.imageFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageMimeType => $composableBuilder(
    column: $table.imageMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get removeImage => $composableBuilder(
    column: $table.removeImage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EditorDraftsTableOrderingComposer
    extends Composer<_$CacheDatabase, $EditorDraftsTable> {
  $$EditorDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageFileName => $composableBuilder(
    column: $table.imageFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageMimeType => $composableBuilder(
    column: $table.imageMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get removeImage => $composableBuilder(
    column: $table.removeImage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EditorDraftsTableAnnotationComposer
    extends Composer<_$CacheDatabase, $EditorDraftsTable> {
  $$EditorDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  GeneratedColumn<int> get baseUpdatedAt => $composableBuilder(
    column: $table.baseUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageFileName => $composableBuilder(
    column: $table.imageFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageMimeType => $composableBuilder(
    column: $table.imageMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get removeImage => $composableBuilder(
    column: $table.removeImage,
    builder: (column) => column,
  );
}

class $$EditorDraftsTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $EditorDraftsTable,
          EditorDraftRow,
          $$EditorDraftsTableFilterComposer,
          $$EditorDraftsTableOrderingComposer,
          $$EditorDraftsTableAnnotationComposer,
          $$EditorDraftsTableCreateCompanionBuilder,
          $$EditorDraftsTableUpdateCompanionBuilder,
          (
            EditorDraftRow,
            BaseReferences<_$CacheDatabase, $EditorDraftsTable, EditorDraftRow>,
          ),
          EditorDraftRow,
          PrefetchHooks Function()
        > {
  $$EditorDraftsTableTableManager(_$CacheDatabase db, $EditorDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EditorDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EditorDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EditorDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> recipeId = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int?> baseUpdatedAt = const Value.absent(),
                Value<Uint8List?> imageBytes = const Value.absent(),
                Value<String?> imageFileName = const Value.absent(),
                Value<String?> imageMimeType = const Value.absent(),
                Value<bool> removeImage = const Value.absent(),
              }) => EditorDraftsCompanion(
                recipeId: recipeId,
                json: json,
                savedAt: savedAt,
                baseUpdatedAt: baseUpdatedAt,
                imageBytes: imageBytes,
                imageFileName: imageFileName,
                imageMimeType: imageMimeType,
                removeImage: removeImage,
              ),
          createCompanionCallback:
              ({
                Value<int> recipeId = const Value.absent(),
                required String json,
                required DateTime savedAt,
                Value<int?> baseUpdatedAt = const Value.absent(),
                Value<Uint8List?> imageBytes = const Value.absent(),
                Value<String?> imageFileName = const Value.absent(),
                Value<String?> imageMimeType = const Value.absent(),
                required bool removeImage,
              }) => EditorDraftsCompanion.insert(
                recipeId: recipeId,
                json: json,
                savedAt: savedAt,
                baseUpdatedAt: baseUpdatedAt,
                imageBytes: imageBytes,
                imageFileName: imageFileName,
                imageMimeType: imageMimeType,
                removeImage: removeImage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EditorDraftsTable, EditorDraftRow>(table),
                  BaseReferences<
                    _$CacheDatabase,
                    $EditorDraftsTable,
                    EditorDraftRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EditorDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $EditorDraftsTable,
      EditorDraftRow,
      $$EditorDraftsTableFilterComposer,
      $$EditorDraftsTableOrderingComposer,
      $$EditorDraftsTableAnnotationComposer,
      $$EditorDraftsTableCreateCompanionBuilder,
      $$EditorDraftsTableUpdateCompanionBuilder,
      (
        EditorDraftRow,
        BaseReferences<_$CacheDatabase, $EditorDraftsTable, EditorDraftRow>,
      ),
      EditorDraftRow,
      PrefetchHooks Function()
    >;

class $CacheDatabaseManager {
  final _$CacheDatabase _db;
  $CacheDatabaseManager(this._db);
  $$CachedRecipesTableTableManager get cachedRecipes =>
      $$CachedRecipesTableTableManager(_db, _db.cachedRecipes);
  $$CachedImagesTableTableManager get cachedImages =>
      $$CachedImagesTableTableManager(_db, _db.cachedImages);
  $$CachedSavedFiltersTableTableManager get cachedSavedFilters =>
      $$CachedSavedFiltersTableTableManager(_db, _db.cachedSavedFilters);
  $$CachedMealPlansTableTableManager get cachedMealPlans =>
      $$CachedMealPlansTableTableManager(_db, _db.cachedMealPlans);
  $$CachedShoppingEntriesTableTableManager get cachedShoppingEntries =>
      $$CachedShoppingEntriesTableTableManager(_db, _db.cachedShoppingEntries);
  $$CachedValuesTableTableManager get cachedValues =>
      $$CachedValuesTableTableManager(_db, _db.cachedValues);
  $$EditorDraftsTableTableManager get editorDrafts =>
      $$EditorDraftsTableTableManager(_db, _db.editorDrafts);
}
