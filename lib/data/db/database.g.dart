// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  @override
  late final GeneratedColumnWithTypeConverter<AccountKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AccountKind>($AccountsTable.$converterkind);
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    institution,
    last4,
    color,
    archived,
    currency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
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
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $AccountsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountKind, int, int> $converterkind =
      const EnumIndexConverter<AccountKind>(AccountKind.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final AccountKind kind;
  final String? institution;

  /// Last 3–4 digits of account / card number, used to match messages.
  final String? last4;
  final int color;
  final bool archived;

  /// ISO 4217 code the account is held in. Rows from before v4 are INR.
  final String currency;
  const Account({
    required this.id,
    required this.name,
    required this.kind,
    this.institution,
    this.last4,
    required this.color,
    required this.archived,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<int>($AccountsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    map['color'] = Variable<int>(color);
    map['archived'] = Variable<bool>(archived);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      color: Value(color),
      archived: Value(archived),
      currency: Value(currency),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $AccountsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      institution: serializer.fromJson<String?>(json['institution']),
      last4: serializer.fromJson<String?>(json['last4']),
      color: serializer.fromJson<int>(json['color']),
      archived: serializer.fromJson<bool>(json['archived']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<int>(
        $AccountsTable.$converterkind.toJson(kind),
      ),
      'institution': serializer.toJson<String?>(institution),
      'last4': serializer.toJson<String?>(last4),
      'color': serializer.toJson<int>(color),
      'archived': serializer.toJson<bool>(archived),
      'currency': serializer.toJson<String>(currency),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    AccountKind? kind,
    Value<String?> institution = const Value.absent(),
    Value<String?> last4 = const Value.absent(),
    int? color,
    bool? archived,
    String? currency,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    institution: institution.present ? institution.value : this.institution,
    last4: last4.present ? last4.value : this.last4,
    color: color ?? this.color,
    archived: archived ?? this.archived,
    currency: currency ?? this.currency,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      last4: data.last4.present ? data.last4.value : this.last4,
      color: data.color.present ? data.color.value : this.color,
      archived: data.archived.present ? data.archived.value : this.archived,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('institution: $institution, ')
          ..write('last4: $last4, ')
          ..write('color: $color, ')
          ..write('archived: $archived, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    institution,
    last4,
    color,
    archived,
    currency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.institution == this.institution &&
          other.last4 == this.last4 &&
          other.color == this.color &&
          other.archived == this.archived &&
          other.currency == this.currency);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<AccountKind> kind;
  final Value<String?> institution;
  final Value<String?> last4;
  final Value<int> color;
  final Value<bool> archived;
  final Value<String> currency;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.institution = const Value.absent(),
    this.last4 = const Value.absent(),
    this.color = const Value.absent(),
    this.archived = const Value.absent(),
    this.currency = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountKind kind,
    this.institution = const Value.absent(),
    this.last4 = const Value.absent(),
    required int color,
    this.archived = const Value.absent(),
    this.currency = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       color = Value(color);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? kind,
    Expression<String>? institution,
    Expression<String>? last4,
    Expression<int>? color,
    Expression<bool>? archived,
    Expression<String>? currency,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (institution != null) 'institution': institution,
      if (last4 != null) 'last4': last4,
      if (color != null) 'color': color,
      if (archived != null) 'archived': archived,
      if (currency != null) 'currency': currency,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<AccountKind>? kind,
    Value<String?>? institution,
    Value<String?>? last4,
    Value<int>? color,
    Value<bool>? archived,
    Value<String>? currency,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      institution: institution ?? this.institution,
      last4: last4 ?? this.last4,
      color: color ?? this.color,
      archived: archived ?? this.archived,
      currency: currency ?? this.currency,
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
    if (kind.present) {
      map['kind'] = Variable<int>(
        $AccountsTable.$converterkind.toSql(kind.value),
      );
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('institution: $institution, ')
          ..write('last4: $last4, ')
          ..write('color: $color, ')
          ..write('archived: $archived, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isIncomeMeta = const VerificationMeta(
    'isIncome',
  );
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
    'is_income',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_income" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _seedNameMeta = const VerificationMeta(
    'seedName',
  );
  @override
  late final GeneratedColumn<String> seedName = GeneratedColumn<String>(
    'seed_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    color,
    isIncome,
    sortOrder,
    seedName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
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
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(
        _isIncomeMeta,
        isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('seed_name')) {
      context.handle(
        _seedNameMeta,
        seedName.isAcceptableOrUnknown(data['seed_name']!, _seedNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_income'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      seedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_name'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;

  /// Key into [CategoryIcons]; stored as text so icon sets can change.
  final String icon;
  final int color;
  final bool isIncome;
  final int sortOrder;

  /// Name of the seed category this row was created from (null for
  /// user-made ones). Keeps keyword rules working after a rename.
  final String? seedName;
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isIncome,
    required this.sortOrder,
    this.seedName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['is_income'] = Variable<bool>(isIncome);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || seedName != null) {
      map['seed_name'] = Variable<String>(seedName);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      isIncome: Value(isIncome),
      sortOrder: Value(sortOrder),
      seedName: seedName == null && nullToAbsent
          ? const Value.absent()
          : Value(seedName),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      seedName: serializer.fromJson<String?>(json['seedName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'isIncome': serializer.toJson<bool>(isIncome),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'seedName': serializer.toJson<String?>(seedName),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    int? color,
    bool? isIncome,
    int? sortOrder,
    Value<String?> seedName = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    isIncome: isIncome ?? this.isIncome,
    sortOrder: sortOrder ?? this.sortOrder,
    seedName: seedName.present ? seedName.value : this.seedName,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      seedName: data.seedName.present ? data.seedName.value : this.seedName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isIncome: $isIncome, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('seedName: $seedName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, color, isIncome, sortOrder, seedName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isIncome == this.isIncome &&
          other.sortOrder == this.sortOrder &&
          other.seedName == this.seedName);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<bool> isIncome;
  final Value<int> sortOrder;
  final Value<String?> seedName;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.seedName = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    required int color,
    this.isIncome = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.seedName = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<bool>? isIncome,
    Expression<int>? sortOrder,
    Expression<String>? seedName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isIncome != null) 'is_income': isIncome,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (seedName != null) 'seed_name': seedName,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? color,
    Value<bool>? isIncome,
    Value<int>? sortOrder,
    Value<String?>? seedName,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
      sortOrder: sortOrder ?? this.sortOrder,
      seedName: seedName ?? this.seedName,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (seedName.present) {
      map['seed_name'] = Variable<String>(seedName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isIncome: $isIncome, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('seedName: $seedName')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _convertedMinorMeta = const VerificationMeta(
    'convertedMinor',
  );
  @override
  late final GeneratedColumn<int> convertedMinor = GeneratedColumn<int>(
    'converted_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _convertedCurrencyMeta = const VerificationMeta(
    'convertedCurrency',
  );
  @override
  late final GeneratedColumn<String> convertedCurrency =
      GeneratedColumn<String>(
        'converted_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TxnDirection, int> direction =
      GeneratedColumn<int>(
        'direction',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TxnDirection>($TransactionsTable.$converterdirection);
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _counterpartyMeta = const VerificationMeta(
    'counterparty',
  );
  @override
  late final GeneratedColumn<String> counterparty = GeneratedColumn<String>(
    'counterparty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _accountHintMeta = const VerificationMeta(
    'accountHint',
  );
  @override
  late final GeneratedColumn<String> accountHint = GeneratedColumn<String>(
    'account_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, int> mode =
      GeneratedColumn<int>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PaymentMode>($TransactionsTable.$convertermode);
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TxnStatus>($TransactionsTable.$converterstatus);
  static const VerificationMeta _isTransferMeta = const VerificationMeta(
    'isTransfer',
  );
  @override
  late final GeneratedColumn<bool> isTransfer = GeneratedColumn<bool>(
    'is_transfer',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_transfer" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _categoryLockedMeta = const VerificationMeta(
    'categoryLocked',
  );
  @override
  late final GeneratedColumn<bool> categoryLocked = GeneratedColumn<bool>(
    'category_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("category_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _businessUseBpsMeta = const VerificationMeta(
    'businessUseBps',
  );
  @override
  late final GeneratedColumn<int> businessUseBps = GeneratedColumn<int>(
    'business_use_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unreviewed'),
  );
  static const VerificationMeta _duplicateOfIdMeta = const VerificationMeta(
    'duplicateOfId',
  );
  @override
  late final GeneratedColumn<int> duplicateOfId = GeneratedColumn<int>(
    'duplicate_of_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountMinor,
    currency,
    convertedMinor,
    convertedCurrency,
    direction,
    occurredAt,
    merchant,
    counterparty,
    note,
    categoryId,
    accountId,
    accountHint,
    mode,
    reference,
    status,
    isTransfer,
    categoryLocked,
    businessUseBps,
    reviewStatus,
    duplicateOfId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('converted_minor')) {
      context.handle(
        _convertedMinorMeta,
        convertedMinor.isAcceptableOrUnknown(
          data['converted_minor']!,
          _convertedMinorMeta,
        ),
      );
    }
    if (data.containsKey('converted_currency')) {
      context.handle(
        _convertedCurrencyMeta,
        convertedCurrency.isAcceptableOrUnknown(
          data['converted_currency']!,
          _convertedCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('counterparty')) {
      context.handle(
        _counterpartyMeta,
        counterparty.isAcceptableOrUnknown(
          data['counterparty']!,
          _counterpartyMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('account_hint')) {
      context.handle(
        _accountHintMeta,
        accountHint.isAcceptableOrUnknown(
          data['account_hint']!,
          _accountHintMeta,
        ),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('is_transfer')) {
      context.handle(
        _isTransferMeta,
        isTransfer.isAcceptableOrUnknown(data['is_transfer']!, _isTransferMeta),
      );
    }
    if (data.containsKey('category_locked')) {
      context.handle(
        _categoryLockedMeta,
        categoryLocked.isAcceptableOrUnknown(
          data['category_locked']!,
          _categoryLockedMeta,
        ),
      );
    }
    if (data.containsKey('business_use_bps')) {
      context.handle(
        _businessUseBpsMeta,
        businessUseBps.isAcceptableOrUnknown(
          data['business_use_bps']!,
          _businessUseBpsMeta,
        ),
      );
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_of_id')) {
      context.handle(
        _duplicateOfIdMeta,
        duplicateOfId.isAcceptableOrUnknown(
          data['duplicate_of_id']!,
          _duplicateOfIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      convertedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}converted_minor'],
      ),
      convertedCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}converted_currency'],
      ),
      direction: $TransactionsTable.$converterdirection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}direction'],
        )!,
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      counterparty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      accountHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_hint'],
      ),
      mode: $TransactionsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}mode'],
        )!,
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      status: $TransactionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      isTransfer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_transfer'],
      )!,
      categoryLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}category_locked'],
      )!,
      businessUseBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_use_bps'],
      )!,
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      duplicateOfId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duplicate_of_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnDirection, int, int> $converterdirection =
      const EnumIndexConverter<TxnDirection>(TxnDirection.values);
  static JsonTypeConverter2<PaymentMode, int, int> $convertermode =
      const EnumIndexConverter<PaymentMode>(PaymentMode.values);
  static JsonTypeConverter2<TxnStatus, int, int> $converterstatus =
      const EnumIndexConverter<TxnStatus>(TxnStatus.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;

  /// In minor units of [currency] (paise, cents; whole yen for JPY, fils
  /// for KWD) to avoid floating point drift.
  final int amountMinor;

  /// ISO 4217 code of [amountMinor]. Rows from before v4 are INR.
  final String currency;

  /// The same payment in another currency, normally the home currency:
  /// stated by the message ("USD 12.50 (INR 1,045.30)") or entered by the
  /// user. A foreign transaction counts towards totals and budgets only
  /// with a converted amount in the home currency. Null for most rows.
  final int? convertedMinor;
  final String? convertedCurrency;
  final TxnDirection direction;
  final DateTime occurredAt;
  final String? merchant;

  /// VPA / raw counterparty string as it appeared in the message.
  final String? counterparty;
  final String? note;
  final int? categoryId;
  final int? accountId;
  final String? accountHint;
  final PaymentMode mode;

  /// UPI ref / RRN / bank reference. The strongest dedup signal.
  final String? reference;
  final TxnStatus status;

  /// Self-transfers between own accounts are excluded from spend.
  final bool isTransfer;
  final bool categoryLocked;
  final int businessUseBps;
  final String reviewStatus;

  /// Set when dedup found a borderline match the user should confirm.
  final int? duplicateOfId;
  final DateTime createdAt;
  const Transaction({
    required this.id,
    required this.amountMinor,
    required this.currency,
    this.convertedMinor,
    this.convertedCurrency,
    required this.direction,
    required this.occurredAt,
    this.merchant,
    this.counterparty,
    this.note,
    this.categoryId,
    this.accountId,
    this.accountHint,
    required this.mode,
    this.reference,
    required this.status,
    required this.isTransfer,
    required this.categoryLocked,
    required this.businessUseBps,
    required this.reviewStatus,
    this.duplicateOfId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || convertedMinor != null) {
      map['converted_minor'] = Variable<int>(convertedMinor);
    }
    if (!nullToAbsent || convertedCurrency != null) {
      map['converted_currency'] = Variable<String>(convertedCurrency);
    }
    {
      map['direction'] = Variable<int>(
        $TransactionsTable.$converterdirection.toSql(direction),
      );
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || counterparty != null) {
      map['counterparty'] = Variable<String>(counterparty);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || accountHint != null) {
      map['account_hint'] = Variable<String>(accountHint);
    }
    {
      map['mode'] = Variable<int>(
        $TransactionsTable.$convertermode.toSql(mode),
      );
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    {
      map['status'] = Variable<int>(
        $TransactionsTable.$converterstatus.toSql(status),
      );
    }
    map['is_transfer'] = Variable<bool>(isTransfer);
    map['category_locked'] = Variable<bool>(categoryLocked);
    map['business_use_bps'] = Variable<int>(businessUseBps);
    map['review_status'] = Variable<String>(reviewStatus);
    if (!nullToAbsent || duplicateOfId != null) {
      map['duplicate_of_id'] = Variable<int>(duplicateOfId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      convertedMinor: convertedMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(convertedMinor),
      convertedCurrency: convertedCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(convertedCurrency),
      direction: Value(direction),
      occurredAt: Value(occurredAt),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      counterparty: counterparty == null && nullToAbsent
          ? const Value.absent()
          : Value(counterparty),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      accountHint: accountHint == null && nullToAbsent
          ? const Value.absent()
          : Value(accountHint),
      mode: Value(mode),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      status: Value(status),
      isTransfer: Value(isTransfer),
      categoryLocked: Value(categoryLocked),
      businessUseBps: Value(businessUseBps),
      reviewStatus: Value(reviewStatus),
      duplicateOfId: duplicateOfId == null && nullToAbsent
          ? const Value.absent()
          : Value(duplicateOfId),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      convertedMinor: serializer.fromJson<int?>(json['convertedMinor']),
      convertedCurrency: serializer.fromJson<String?>(
        json['convertedCurrency'],
      ),
      direction: $TransactionsTable.$converterdirection.fromJson(
        serializer.fromJson<int>(json['direction']),
      ),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      counterparty: serializer.fromJson<String?>(json['counterparty']),
      note: serializer.fromJson<String?>(json['note']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      accountHint: serializer.fromJson<String?>(json['accountHint']),
      mode: $TransactionsTable.$convertermode.fromJson(
        serializer.fromJson<int>(json['mode']),
      ),
      reference: serializer.fromJson<String?>(json['reference']),
      status: $TransactionsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      isTransfer: serializer.fromJson<bool>(json['isTransfer']),
      categoryLocked: serializer.fromJson<bool>(json['categoryLocked']),
      businessUseBps: serializer.fromJson<int>(json['businessUseBps']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      duplicateOfId: serializer.fromJson<int?>(json['duplicateOfId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'convertedMinor': serializer.toJson<int?>(convertedMinor),
      'convertedCurrency': serializer.toJson<String?>(convertedCurrency),
      'direction': serializer.toJson<int>(
        $TransactionsTable.$converterdirection.toJson(direction),
      ),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'merchant': serializer.toJson<String?>(merchant),
      'counterparty': serializer.toJson<String?>(counterparty),
      'note': serializer.toJson<String?>(note),
      'categoryId': serializer.toJson<int?>(categoryId),
      'accountId': serializer.toJson<int?>(accountId),
      'accountHint': serializer.toJson<String?>(accountHint),
      'mode': serializer.toJson<int>(
        $TransactionsTable.$convertermode.toJson(mode),
      ),
      'reference': serializer.toJson<String?>(reference),
      'status': serializer.toJson<int>(
        $TransactionsTable.$converterstatus.toJson(status),
      ),
      'isTransfer': serializer.toJson<bool>(isTransfer),
      'categoryLocked': serializer.toJson<bool>(categoryLocked),
      'businessUseBps': serializer.toJson<int>(businessUseBps),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'duplicateOfId': serializer.toJson<int?>(duplicateOfId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith({
    int? id,
    int? amountMinor,
    String? currency,
    Value<int?> convertedMinor = const Value.absent(),
    Value<String?> convertedCurrency = const Value.absent(),
    TxnDirection? direction,
    DateTime? occurredAt,
    Value<String?> merchant = const Value.absent(),
    Value<String?> counterparty = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    Value<String?> accountHint = const Value.absent(),
    PaymentMode? mode,
    Value<String?> reference = const Value.absent(),
    TxnStatus? status,
    bool? isTransfer,
    bool? categoryLocked,
    int? businessUseBps,
    String? reviewStatus,
    Value<int?> duplicateOfId = const Value.absent(),
    DateTime? createdAt,
  }) => Transaction(
    id: id ?? this.id,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    convertedMinor: convertedMinor.present
        ? convertedMinor.value
        : this.convertedMinor,
    convertedCurrency: convertedCurrency.present
        ? convertedCurrency.value
        : this.convertedCurrency,
    direction: direction ?? this.direction,
    occurredAt: occurredAt ?? this.occurredAt,
    merchant: merchant.present ? merchant.value : this.merchant,
    counterparty: counterparty.present ? counterparty.value : this.counterparty,
    note: note.present ? note.value : this.note,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId.present ? accountId.value : this.accountId,
    accountHint: accountHint.present ? accountHint.value : this.accountHint,
    mode: mode ?? this.mode,
    reference: reference.present ? reference.value : this.reference,
    status: status ?? this.status,
    isTransfer: isTransfer ?? this.isTransfer,
    categoryLocked: categoryLocked ?? this.categoryLocked,
    businessUseBps: businessUseBps ?? this.businessUseBps,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    duplicateOfId: duplicateOfId.present
        ? duplicateOfId.value
        : this.duplicateOfId,
    createdAt: createdAt ?? this.createdAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      convertedMinor: data.convertedMinor.present
          ? data.convertedMinor.value
          : this.convertedMinor,
      convertedCurrency: data.convertedCurrency.present
          ? data.convertedCurrency.value
          : this.convertedCurrency,
      direction: data.direction.present ? data.direction.value : this.direction,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      counterparty: data.counterparty.present
          ? data.counterparty.value
          : this.counterparty,
      note: data.note.present ? data.note.value : this.note,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountHint: data.accountHint.present
          ? data.accountHint.value
          : this.accountHint,
      mode: data.mode.present ? data.mode.value : this.mode,
      reference: data.reference.present ? data.reference.value : this.reference,
      status: data.status.present ? data.status.value : this.status,
      isTransfer: data.isTransfer.present
          ? data.isTransfer.value
          : this.isTransfer,
      categoryLocked: data.categoryLocked.present
          ? data.categoryLocked.value
          : this.categoryLocked,
      businessUseBps: data.businessUseBps.present
          ? data.businessUseBps.value
          : this.businessUseBps,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      duplicateOfId: data.duplicateOfId.present
          ? data.duplicateOfId.value
          : this.duplicateOfId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('convertedMinor: $convertedMinor, ')
          ..write('convertedCurrency: $convertedCurrency, ')
          ..write('direction: $direction, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('merchant: $merchant, ')
          ..write('counterparty: $counterparty, ')
          ..write('note: $note, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('accountHint: $accountHint, ')
          ..write('mode: $mode, ')
          ..write('reference: $reference, ')
          ..write('status: $status, ')
          ..write('isTransfer: $isTransfer, ')
          ..write('categoryLocked: $categoryLocked, ')
          ..write('businessUseBps: $businessUseBps, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('duplicateOfId: $duplicateOfId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    amountMinor,
    currency,
    convertedMinor,
    convertedCurrency,
    direction,
    occurredAt,
    merchant,
    counterparty,
    note,
    categoryId,
    accountId,
    accountHint,
    mode,
    reference,
    status,
    isTransfer,
    categoryLocked,
    businessUseBps,
    reviewStatus,
    duplicateOfId,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.convertedMinor == this.convertedMinor &&
          other.convertedCurrency == this.convertedCurrency &&
          other.direction == this.direction &&
          other.occurredAt == this.occurredAt &&
          other.merchant == this.merchant &&
          other.counterparty == this.counterparty &&
          other.note == this.note &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.accountHint == this.accountHint &&
          other.mode == this.mode &&
          other.reference == this.reference &&
          other.status == this.status &&
          other.isTransfer == this.isTransfer &&
          other.categoryLocked == this.categoryLocked &&
          other.businessUseBps == this.businessUseBps &&
          other.reviewStatus == this.reviewStatus &&
          other.duplicateOfId == this.duplicateOfId &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<int?> convertedMinor;
  final Value<String?> convertedCurrency;
  final Value<TxnDirection> direction;
  final Value<DateTime> occurredAt;
  final Value<String?> merchant;
  final Value<String?> counterparty;
  final Value<String?> note;
  final Value<int?> categoryId;
  final Value<int?> accountId;
  final Value<String?> accountHint;
  final Value<PaymentMode> mode;
  final Value<String?> reference;
  final Value<TxnStatus> status;
  final Value<bool> isTransfer;
  final Value<bool> categoryLocked;
  final Value<int> businessUseBps;
  final Value<String> reviewStatus;
  final Value<int?> duplicateOfId;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.convertedMinor = const Value.absent(),
    this.convertedCurrency = const Value.absent(),
    this.direction = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.merchant = const Value.absent(),
    this.counterparty = const Value.absent(),
    this.note = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountHint = const Value.absent(),
    this.mode = const Value.absent(),
    this.reference = const Value.absent(),
    this.status = const Value.absent(),
    this.isTransfer = const Value.absent(),
    this.categoryLocked = const Value.absent(),
    this.businessUseBps = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.duplicateOfId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int amountMinor,
    this.currency = const Value.absent(),
    this.convertedMinor = const Value.absent(),
    this.convertedCurrency = const Value.absent(),
    required TxnDirection direction,
    required DateTime occurredAt,
    this.merchant = const Value.absent(),
    this.counterparty = const Value.absent(),
    this.note = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountHint = const Value.absent(),
    required PaymentMode mode,
    this.reference = const Value.absent(),
    required TxnStatus status,
    this.isTransfer = const Value.absent(),
    this.categoryLocked = const Value.absent(),
    this.businessUseBps = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.duplicateOfId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : amountMinor = Value(amountMinor),
       direction = Value(direction),
       occurredAt = Value(occurredAt),
       mode = Value(mode),
       status = Value(status);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<int>? convertedMinor,
    Expression<String>? convertedCurrency,
    Expression<int>? direction,
    Expression<DateTime>? occurredAt,
    Expression<String>? merchant,
    Expression<String>? counterparty,
    Expression<String>? note,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<String>? accountHint,
    Expression<int>? mode,
    Expression<String>? reference,
    Expression<int>? status,
    Expression<bool>? isTransfer,
    Expression<bool>? categoryLocked,
    Expression<int>? businessUseBps,
    Expression<String>? reviewStatus,
    Expression<int>? duplicateOfId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (convertedMinor != null) 'converted_minor': convertedMinor,
      if (convertedCurrency != null) 'converted_currency': convertedCurrency,
      if (direction != null) 'direction': direction,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (merchant != null) 'merchant': merchant,
      if (counterparty != null) 'counterparty': counterparty,
      if (note != null) 'note': note,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (accountHint != null) 'account_hint': accountHint,
      if (mode != null) 'mode': mode,
      if (reference != null) 'reference': reference,
      if (status != null) 'status': status,
      if (isTransfer != null) 'is_transfer': isTransfer,
      if (categoryLocked != null) 'category_locked': categoryLocked,
      if (businessUseBps != null) 'business_use_bps': businessUseBps,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (duplicateOfId != null) 'duplicate_of_id': duplicateOfId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<int?>? convertedMinor,
    Value<String?>? convertedCurrency,
    Value<TxnDirection>? direction,
    Value<DateTime>? occurredAt,
    Value<String?>? merchant,
    Value<String?>? counterparty,
    Value<String?>? note,
    Value<int?>? categoryId,
    Value<int?>? accountId,
    Value<String?>? accountHint,
    Value<PaymentMode>? mode,
    Value<String?>? reference,
    Value<TxnStatus>? status,
    Value<bool>? isTransfer,
    Value<bool>? categoryLocked,
    Value<int>? businessUseBps,
    Value<String>? reviewStatus,
    Value<int?>? duplicateOfId,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      convertedMinor: convertedMinor ?? this.convertedMinor,
      convertedCurrency: convertedCurrency ?? this.convertedCurrency,
      direction: direction ?? this.direction,
      occurredAt: occurredAt ?? this.occurredAt,
      merchant: merchant ?? this.merchant,
      counterparty: counterparty ?? this.counterparty,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      accountHint: accountHint ?? this.accountHint,
      mode: mode ?? this.mode,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      isTransfer: isTransfer ?? this.isTransfer,
      categoryLocked: categoryLocked ?? this.categoryLocked,
      businessUseBps: businessUseBps ?? this.businessUseBps,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      duplicateOfId: duplicateOfId ?? this.duplicateOfId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (convertedMinor.present) {
      map['converted_minor'] = Variable<int>(convertedMinor.value);
    }
    if (convertedCurrency.present) {
      map['converted_currency'] = Variable<String>(convertedCurrency.value);
    }
    if (direction.present) {
      map['direction'] = Variable<int>(
        $TransactionsTable.$converterdirection.toSql(direction.value),
      );
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (counterparty.present) {
      map['counterparty'] = Variable<String>(counterparty.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (accountHint.present) {
      map['account_hint'] = Variable<String>(accountHint.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(
        $TransactionsTable.$convertermode.toSql(mode.value),
      );
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $TransactionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (isTransfer.present) {
      map['is_transfer'] = Variable<bool>(isTransfer.value);
    }
    if (categoryLocked.present) {
      map['category_locked'] = Variable<bool>(categoryLocked.value);
    }
    if (businessUseBps.present) {
      map['business_use_bps'] = Variable<int>(businessUseBps.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (duplicateOfId.present) {
      map['duplicate_of_id'] = Variable<int>(duplicateOfId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('convertedMinor: $convertedMinor, ')
          ..write('convertedCurrency: $convertedCurrency, ')
          ..write('direction: $direction, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('merchant: $merchant, ')
          ..write('counterparty: $counterparty, ')
          ..write('note: $note, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('accountHint: $accountHint, ')
          ..write('mode: $mode, ')
          ..write('reference: $reference, ')
          ..write('status: $status, ')
          ..write('isTransfer: $isTransfer, ')
          ..write('categoryLocked: $categoryLocked, ')
          ..write('businessUseBps: $businessUseBps, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('duplicateOfId: $duplicateOfId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RawMessagesTable extends RawMessages
    with TableInfo<$RawMessagesTable, RawMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SourceKind, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SourceKind>($RawMessagesTable.$convertersource);
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ParseStatus, int> parseStatus =
      GeneratedColumn<int>(
        'parse_status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ParseStatus>($RawMessagesTable.$converterparseStatus);
  static const VerificationMeta _ignoreReasonMeta = const VerificationMeta(
    'ignoreReason',
  );
  @override
  late final GeneratedColumn<String> ignoreReason = GeneratedColumn<String>(
    'ignore_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _mergeScoreMeta = const VerificationMeta(
    'mergeScore',
  );
  @override
  late final GeneratedColumn<double> mergeScore = GeneratedColumn<double>(
    'merge_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    externalId,
    sender,
    body,
    receivedAt,
    parseStatus,
    ignoreReason,
    transactionId,
    mergeScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('ignore_reason')) {
      context.handle(
        _ignoreReasonMeta,
        ignoreReason.isAcceptableOrUnknown(
          data['ignore_reason']!,
          _ignoreReasonMeta,
        ),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('merge_score')) {
      context.handle(
        _mergeScoreMeta,
        mergeScore.isAcceptableOrUnknown(data['merge_score']!, _mergeScoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {source, externalId},
  ];
  @override
  RawMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      source: $RawMessagesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      parseStatus: $RawMessagesTable.$converterparseStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}parse_status'],
        )!,
      ),
      ignoreReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ignore_reason'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      mergeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}merge_score'],
      ),
    );
  }

  @override
  $RawMessagesTable createAlias(String alias) {
    return $RawMessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceKind, int, int> $convertersource =
      const EnumIndexConverter<SourceKind>(SourceKind.values);
  static JsonTypeConverter2<ParseStatus, int, int> $converterparseStatus =
      const EnumIndexConverter<ParseStatus>(ParseStatus.values);
}

class RawMessage extends DataClass implements Insertable<RawMessage> {
  final int id;
  final SourceKind source;

  /// Provider-side id (SMS _id, Gmail message id) — unique per source.
  final String externalId;
  final String sender;
  final String body;
  final DateTime receivedAt;
  final ParseStatus parseStatus;
  final String? ignoreReason;
  final int? transactionId;

  /// Dedup score that linked this message to an existing transaction.
  final double? mergeScore;
  const RawMessage({
    required this.id,
    required this.source,
    required this.externalId,
    required this.sender,
    required this.body,
    required this.receivedAt,
    required this.parseStatus,
    this.ignoreReason,
    this.transactionId,
    this.mergeScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['source'] = Variable<int>(
        $RawMessagesTable.$convertersource.toSql(source),
      );
    }
    map['external_id'] = Variable<String>(externalId);
    map['sender'] = Variable<String>(sender);
    map['body'] = Variable<String>(body);
    map['received_at'] = Variable<DateTime>(receivedAt);
    {
      map['parse_status'] = Variable<int>(
        $RawMessagesTable.$converterparseStatus.toSql(parseStatus),
      );
    }
    if (!nullToAbsent || ignoreReason != null) {
      map['ignore_reason'] = Variable<String>(ignoreReason);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    if (!nullToAbsent || mergeScore != null) {
      map['merge_score'] = Variable<double>(mergeScore);
    }
    return map;
  }

  RawMessagesCompanion toCompanion(bool nullToAbsent) {
    return RawMessagesCompanion(
      id: Value(id),
      source: Value(source),
      externalId: Value(externalId),
      sender: Value(sender),
      body: Value(body),
      receivedAt: Value(receivedAt),
      parseStatus: Value(parseStatus),
      ignoreReason: ignoreReason == null && nullToAbsent
          ? const Value.absent()
          : Value(ignoreReason),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      mergeScore: mergeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(mergeScore),
    );
  }

  factory RawMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawMessage(
      id: serializer.fromJson<int>(json['id']),
      source: $RawMessagesTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      externalId: serializer.fromJson<String>(json['externalId']),
      sender: serializer.fromJson<String>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      parseStatus: $RawMessagesTable.$converterparseStatus.fromJson(
        serializer.fromJson<int>(json['parseStatus']),
      ),
      ignoreReason: serializer.fromJson<String?>(json['ignoreReason']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      mergeScore: serializer.fromJson<double?>(json['mergeScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<int>(
        $RawMessagesTable.$convertersource.toJson(source),
      ),
      'externalId': serializer.toJson<String>(externalId),
      'sender': serializer.toJson<String>(sender),
      'body': serializer.toJson<String>(body),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'parseStatus': serializer.toJson<int>(
        $RawMessagesTable.$converterparseStatus.toJson(parseStatus),
      ),
      'ignoreReason': serializer.toJson<String?>(ignoreReason),
      'transactionId': serializer.toJson<int?>(transactionId),
      'mergeScore': serializer.toJson<double?>(mergeScore),
    };
  }

  RawMessage copyWith({
    int? id,
    SourceKind? source,
    String? externalId,
    String? sender,
    String? body,
    DateTime? receivedAt,
    ParseStatus? parseStatus,
    Value<String?> ignoreReason = const Value.absent(),
    Value<int?> transactionId = const Value.absent(),
    Value<double?> mergeScore = const Value.absent(),
  }) => RawMessage(
    id: id ?? this.id,
    source: source ?? this.source,
    externalId: externalId ?? this.externalId,
    sender: sender ?? this.sender,
    body: body ?? this.body,
    receivedAt: receivedAt ?? this.receivedAt,
    parseStatus: parseStatus ?? this.parseStatus,
    ignoreReason: ignoreReason.present ? ignoreReason.value : this.ignoreReason,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    mergeScore: mergeScore.present ? mergeScore.value : this.mergeScore,
  );
  RawMessage copyWithCompanion(RawMessagesCompanion data) {
    return RawMessage(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      parseStatus: data.parseStatus.present
          ? data.parseStatus.value
          : this.parseStatus,
      ignoreReason: data.ignoreReason.present
          ? data.ignoreReason.value
          : this.ignoreReason,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      mergeScore: data.mergeScore.present
          ? data.mergeScore.value
          : this.mergeScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawMessage(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('parseStatus: $parseStatus, ')
          ..write('ignoreReason: $ignoreReason, ')
          ..write('transactionId: $transactionId, ')
          ..write('mergeScore: $mergeScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    externalId,
    sender,
    body,
    receivedAt,
    parseStatus,
    ignoreReason,
    transactionId,
    mergeScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawMessage &&
          other.id == this.id &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.sender == this.sender &&
          other.body == this.body &&
          other.receivedAt == this.receivedAt &&
          other.parseStatus == this.parseStatus &&
          other.ignoreReason == this.ignoreReason &&
          other.transactionId == this.transactionId &&
          other.mergeScore == this.mergeScore);
}

class RawMessagesCompanion extends UpdateCompanion<RawMessage> {
  final Value<int> id;
  final Value<SourceKind> source;
  final Value<String> externalId;
  final Value<String> sender;
  final Value<String> body;
  final Value<DateTime> receivedAt;
  final Value<ParseStatus> parseStatus;
  final Value<String?> ignoreReason;
  final Value<int?> transactionId;
  final Value<double?> mergeScore;
  const RawMessagesCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.parseStatus = const Value.absent(),
    this.ignoreReason = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.mergeScore = const Value.absent(),
  });
  RawMessagesCompanion.insert({
    this.id = const Value.absent(),
    required SourceKind source,
    required String externalId,
    required String sender,
    required String body,
    required DateTime receivedAt,
    required ParseStatus parseStatus,
    this.ignoreReason = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.mergeScore = const Value.absent(),
  }) : source = Value(source),
       externalId = Value(externalId),
       sender = Value(sender),
       body = Value(body),
       receivedAt = Value(receivedAt),
       parseStatus = Value(parseStatus);
  static Insertable<RawMessage> custom({
    Expression<int>? id,
    Expression<int>? source,
    Expression<String>? externalId,
    Expression<String>? sender,
    Expression<String>? body,
    Expression<DateTime>? receivedAt,
    Expression<int>? parseStatus,
    Expression<String>? ignoreReason,
    Expression<int>? transactionId,
    Expression<double>? mergeScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
      if (receivedAt != null) 'received_at': receivedAt,
      if (parseStatus != null) 'parse_status': parseStatus,
      if (ignoreReason != null) 'ignore_reason': ignoreReason,
      if (transactionId != null) 'transaction_id': transactionId,
      if (mergeScore != null) 'merge_score': mergeScore,
    });
  }

  RawMessagesCompanion copyWith({
    Value<int>? id,
    Value<SourceKind>? source,
    Value<String>? externalId,
    Value<String>? sender,
    Value<String>? body,
    Value<DateTime>? receivedAt,
    Value<ParseStatus>? parseStatus,
    Value<String?>? ignoreReason,
    Value<int?>? transactionId,
    Value<double?>? mergeScore,
  }) {
    return RawMessagesCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      parseStatus: parseStatus ?? this.parseStatus,
      ignoreReason: ignoreReason ?? this.ignoreReason,
      transactionId: transactionId ?? this.transactionId,
      mergeScore: mergeScore ?? this.mergeScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $RawMessagesTable.$convertersource.toSql(source.value),
      );
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (parseStatus.present) {
      map['parse_status'] = Variable<int>(
        $RawMessagesTable.$converterparseStatus.toSql(parseStatus.value),
      );
    }
    if (ignoreReason.present) {
      map['ignore_reason'] = Variable<String>(ignoreReason.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (mergeScore.present) {
      map['merge_score'] = Variable<double>(mergeScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawMessagesCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('parseStatus: $parseStatus, ')
          ..write('ignoreReason: $ignoreReason, ')
          ..write('transactionId: $transactionId, ')
          ..write('mergeScore: $mergeScore')
          ..write(')'))
        .toString();
  }
}

class $MerchantRulesTable extends MerchantRules
    with TableInfo<$MerchantRulesTable, MerchantRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, pattern, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $MerchantRulesTable createAlias(String alias) {
    return $MerchantRulesTable(attachedDatabase, alias);
  }
}

class MerchantRule extends DataClass implements Insertable<MerchantRule> {
  final int id;
  final String pattern;
  final int categoryId;
  const MerchantRule({
    required this.id,
    required this.pattern,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern'] = Variable<String>(pattern);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  MerchantRulesCompanion toCompanion(bool nullToAbsent) {
    return MerchantRulesCompanion(
      id: Value(id),
      pattern: Value(pattern),
      categoryId: Value(categoryId),
    );
  }

  factory MerchantRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantRule(
      id: serializer.fromJson<int>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pattern': serializer.toJson<String>(pattern),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  MerchantRule copyWith({int? id, String? pattern, int? categoryId}) =>
      MerchantRule(
        id: id ?? this.id,
        pattern: pattern ?? this.pattern,
        categoryId: categoryId ?? this.categoryId,
      );
  MerchantRule copyWithCompanion(MerchantRulesCompanion data) {
    return MerchantRule(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantRule(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pattern, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantRule &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.categoryId == this.categoryId);
}

class MerchantRulesCompanion extends UpdateCompanion<MerchantRule> {
  final Value<int> id;
  final Value<String> pattern;
  final Value<int> categoryId;
  const MerchantRulesCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  MerchantRulesCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    required int categoryId,
  }) : pattern = Value(pattern),
       categoryId = Value(categoryId);
  static Insertable<MerchantRule> custom({
    Expression<int>? id,
    Expression<String>? pattern,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  MerchantRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? pattern,
    Value<int>? categoryId,
  }) {
    return MerchantRulesCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantRulesCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    amountMinor,
    currency,
    active,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int? categoryId;

  /// Limit per month, in minor units of [currency].
  final int amountMinor;

  /// A budget applies only while this is the home currency. Rows from
  /// before v4 are INR.
  final String currency;
  final bool active;
  final DateTime createdAt;
  const Budget({
    required this.id,
    this.categoryId,
    required this.amountMinor,
    required this.currency,
    required this.active,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      active: Value(active),
      createdAt: Value(createdAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int?>(categoryId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Budget copyWith({
    int? id,
    Value<int?> categoryId = const Value.absent(),
    int? amountMinor,
    String? currency,
    bool? active,
    DateTime? createdAt,
  }) => Budget(
    id: id ?? this.id,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, amountMinor, currency, active, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.active == this.active &&
          other.createdAt == this.createdAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int?> categoryId;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int amountMinor,
    this.currency = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : amountMinor = Value(amountMinor);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int?>? categoryId,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<bool>? active,
    Value<DateTime>? createdAt,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ImportJobsTable extends ImportJobs
    with TableInfo<$ImportJobsTable, ImportJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceAccountIdMeta = const VerificationMeta(
    'sourceAccountId',
  );
  @override
  late final GeneratedColumn<int> sourceAccountId = GeneratedColumn<int>(
    'source_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bank_csv'),
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parserVersionMeta = const VerificationMeta(
    'parserVersion',
  );
  @override
  late final GeneratedColumn<int> parserVersion = GeneratedColumn<int>(
    'parser_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mappingJsonMeta = const VerificationMeta(
    'mappingJson',
  );
  @override
  late final GeneratedColumn<String> mappingJson = GeneratedColumn<String>(
    'mapping_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _openingMinorMeta = const VerificationMeta(
    'openingMinor',
  );
  @override
  late final GeneratedColumn<int> openingMinor = GeneratedColumn<int>(
    'opening_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closingMinorMeta = const VerificationMeta(
    'closingMinor',
  );
  @override
  late final GeneratedColumn<int> closingMinor = GeneratedColumn<int>(
    'closing_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitMinorMeta = const VerificationMeta(
    'debitMinor',
  );
  @override
  late final GeneratedColumn<int> debitMinor = GeneratedColumn<int>(
    'debit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditMinorMeta = const VerificationMeta(
    'creditMinor',
  );
  @override
  late final GeneratedColumn<int> creditMinor = GeneratedColumn<int>(
    'credit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowCountMeta = const VerificationMeta(
    'rowCount',
  );
  @override
  late final GeneratedColumn<int> rowCount = GeneratedColumn<int>(
    'row_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedCountMeta = const VerificationMeta(
    'addedCount',
  );
  @override
  late final GeneratedColumn<int> addedCount = GeneratedColumn<int>(
    'added_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _matchedCountMeta = const VerificationMeta(
    'matchedCount',
  );
  @override
  late final GeneratedColumn<int> matchedCount = GeneratedColumn<int>(
    'matched_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _skippedCountMeta = const VerificationMeta(
    'skippedCount',
  );
  @override
  late final GeneratedColumn<int> skippedCount = GeneratedColumn<int>(
    'skipped_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceAccountId,
    source,
    fileHash,
    fileName,
    parserVersion,
    mappingJson,
    status,
    currency,
    openingMinor,
    closingMinor,
    debitMinor,
    creditMinor,
    rowCount,
    addedCount,
    matchedCount,
    skippedCount,
    error,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
        _sourceAccountIdMeta,
        sourceAccountId.isAcceptableOrUnknown(
          data['source_account_id']!,
          _sourceAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAccountIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('parser_version')) {
      context.handle(
        _parserVersionMeta,
        parserVersion.isAcceptableOrUnknown(
          data['parser_version']!,
          _parserVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parserVersionMeta);
    }
    if (data.containsKey('mapping_json')) {
      context.handle(
        _mappingJsonMeta,
        mappingJson.isAcceptableOrUnknown(
          data['mapping_json']!,
          _mappingJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mappingJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('opening_minor')) {
      context.handle(
        _openingMinorMeta,
        openingMinor.isAcceptableOrUnknown(
          data['opening_minor']!,
          _openingMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingMinorMeta);
    }
    if (data.containsKey('closing_minor')) {
      context.handle(
        _closingMinorMeta,
        closingMinor.isAcceptableOrUnknown(
          data['closing_minor']!,
          _closingMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_closingMinorMeta);
    }
    if (data.containsKey('debit_minor')) {
      context.handle(
        _debitMinorMeta,
        debitMinor.isAcceptableOrUnknown(data['debit_minor']!, _debitMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_debitMinorMeta);
    }
    if (data.containsKey('credit_minor')) {
      context.handle(
        _creditMinorMeta,
        creditMinor.isAcceptableOrUnknown(
          data['credit_minor']!,
          _creditMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditMinorMeta);
    }
    if (data.containsKey('row_count')) {
      context.handle(
        _rowCountMeta,
        rowCount.isAcceptableOrUnknown(data['row_count']!, _rowCountMeta),
      );
    } else if (isInserting) {
      context.missing(_rowCountMeta);
    }
    if (data.containsKey('added_count')) {
      context.handle(
        _addedCountMeta,
        addedCount.isAcceptableOrUnknown(data['added_count']!, _addedCountMeta),
      );
    }
    if (data.containsKey('matched_count')) {
      context.handle(
        _matchedCountMeta,
        matchedCount.isAcceptableOrUnknown(
          data['matched_count']!,
          _matchedCountMeta,
        ),
      );
    }
    if (data.containsKey('skipped_count')) {
      context.handle(
        _skippedCountMeta,
        skippedCount.isAcceptableOrUnknown(
          data['skipped_count']!,
          _skippedCountMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {source, sourceAccountId, fileHash},
  ];
  @override
  ImportJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_account_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      parserVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parser_version'],
      )!,
      mappingJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mapping_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      openingMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_minor'],
      )!,
      closingMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closing_minor'],
      )!,
      debitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debit_minor'],
      )!,
      creditMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_minor'],
      )!,
      rowCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_count'],
      )!,
      addedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_count'],
      )!,
      matchedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}matched_count'],
      )!,
      skippedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skipped_count'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ImportJobsTable createAlias(String alias) {
    return $ImportJobsTable(attachedDatabase, alias);
  }
}

class ImportJob extends DataClass implements Insertable<ImportJob> {
  final int id;
  final int sourceAccountId;
  final String source;
  final String fileHash;
  final String fileName;
  final int parserVersion;
  final String mappingJson;
  final String status;
  final String currency;
  final int openingMinor;
  final int closingMinor;
  final int debitMinor;
  final int creditMinor;
  final int rowCount;
  final int addedCount;
  final int matchedCount;
  final int skippedCount;
  final String? error;
  final DateTime createdAt;
  const ImportJob({
    required this.id,
    required this.sourceAccountId,
    required this.source,
    required this.fileHash,
    required this.fileName,
    required this.parserVersion,
    required this.mappingJson,
    required this.status,
    required this.currency,
    required this.openingMinor,
    required this.closingMinor,
    required this.debitMinor,
    required this.creditMinor,
    required this.rowCount,
    required this.addedCount,
    required this.matchedCount,
    required this.skippedCount,
    this.error,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_account_id'] = Variable<int>(sourceAccountId);
    map['source'] = Variable<String>(source);
    map['file_hash'] = Variable<String>(fileHash);
    map['file_name'] = Variable<String>(fileName);
    map['parser_version'] = Variable<int>(parserVersion);
    map['mapping_json'] = Variable<String>(mappingJson);
    map['status'] = Variable<String>(status);
    map['currency'] = Variable<String>(currency);
    map['opening_minor'] = Variable<int>(openingMinor);
    map['closing_minor'] = Variable<int>(closingMinor);
    map['debit_minor'] = Variable<int>(debitMinor);
    map['credit_minor'] = Variable<int>(creditMinor);
    map['row_count'] = Variable<int>(rowCount);
    map['added_count'] = Variable<int>(addedCount);
    map['matched_count'] = Variable<int>(matchedCount);
    map['skipped_count'] = Variable<int>(skippedCount);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ImportJobsCompanion toCompanion(bool nullToAbsent) {
    return ImportJobsCompanion(
      id: Value(id),
      sourceAccountId: Value(sourceAccountId),
      source: Value(source),
      fileHash: Value(fileHash),
      fileName: Value(fileName),
      parserVersion: Value(parserVersion),
      mappingJson: Value(mappingJson),
      status: Value(status),
      currency: Value(currency),
      openingMinor: Value(openingMinor),
      closingMinor: Value(closingMinor),
      debitMinor: Value(debitMinor),
      creditMinor: Value(creditMinor),
      rowCount: Value(rowCount),
      addedCount: Value(addedCount),
      matchedCount: Value(matchedCount),
      skippedCount: Value(skippedCount),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      createdAt: Value(createdAt),
    );
  }

  factory ImportJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportJob(
      id: serializer.fromJson<int>(json['id']),
      sourceAccountId: serializer.fromJson<int>(json['sourceAccountId']),
      source: serializer.fromJson<String>(json['source']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      fileName: serializer.fromJson<String>(json['fileName']),
      parserVersion: serializer.fromJson<int>(json['parserVersion']),
      mappingJson: serializer.fromJson<String>(json['mappingJson']),
      status: serializer.fromJson<String>(json['status']),
      currency: serializer.fromJson<String>(json['currency']),
      openingMinor: serializer.fromJson<int>(json['openingMinor']),
      closingMinor: serializer.fromJson<int>(json['closingMinor']),
      debitMinor: serializer.fromJson<int>(json['debitMinor']),
      creditMinor: serializer.fromJson<int>(json['creditMinor']),
      rowCount: serializer.fromJson<int>(json['rowCount']),
      addedCount: serializer.fromJson<int>(json['addedCount']),
      matchedCount: serializer.fromJson<int>(json['matchedCount']),
      skippedCount: serializer.fromJson<int>(json['skippedCount']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceAccountId': serializer.toJson<int>(sourceAccountId),
      'source': serializer.toJson<String>(source),
      'fileHash': serializer.toJson<String>(fileHash),
      'fileName': serializer.toJson<String>(fileName),
      'parserVersion': serializer.toJson<int>(parserVersion),
      'mappingJson': serializer.toJson<String>(mappingJson),
      'status': serializer.toJson<String>(status),
      'currency': serializer.toJson<String>(currency),
      'openingMinor': serializer.toJson<int>(openingMinor),
      'closingMinor': serializer.toJson<int>(closingMinor),
      'debitMinor': serializer.toJson<int>(debitMinor),
      'creditMinor': serializer.toJson<int>(creditMinor),
      'rowCount': serializer.toJson<int>(rowCount),
      'addedCount': serializer.toJson<int>(addedCount),
      'matchedCount': serializer.toJson<int>(matchedCount),
      'skippedCount': serializer.toJson<int>(skippedCount),
      'error': serializer.toJson<String?>(error),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ImportJob copyWith({
    int? id,
    int? sourceAccountId,
    String? source,
    String? fileHash,
    String? fileName,
    int? parserVersion,
    String? mappingJson,
    String? status,
    String? currency,
    int? openingMinor,
    int? closingMinor,
    int? debitMinor,
    int? creditMinor,
    int? rowCount,
    int? addedCount,
    int? matchedCount,
    int? skippedCount,
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
  }) => ImportJob(
    id: id ?? this.id,
    sourceAccountId: sourceAccountId ?? this.sourceAccountId,
    source: source ?? this.source,
    fileHash: fileHash ?? this.fileHash,
    fileName: fileName ?? this.fileName,
    parserVersion: parserVersion ?? this.parserVersion,
    mappingJson: mappingJson ?? this.mappingJson,
    status: status ?? this.status,
    currency: currency ?? this.currency,
    openingMinor: openingMinor ?? this.openingMinor,
    closingMinor: closingMinor ?? this.closingMinor,
    debitMinor: debitMinor ?? this.debitMinor,
    creditMinor: creditMinor ?? this.creditMinor,
    rowCount: rowCount ?? this.rowCount,
    addedCount: addedCount ?? this.addedCount,
    matchedCount: matchedCount ?? this.matchedCount,
    skippedCount: skippedCount ?? this.skippedCount,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
  );
  ImportJob copyWithCompanion(ImportJobsCompanion data) {
    return ImportJob(
      id: data.id.present ? data.id.value : this.id,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      source: data.source.present ? data.source.value : this.source,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      parserVersion: data.parserVersion.present
          ? data.parserVersion.value
          : this.parserVersion,
      mappingJson: data.mappingJson.present
          ? data.mappingJson.value
          : this.mappingJson,
      status: data.status.present ? data.status.value : this.status,
      currency: data.currency.present ? data.currency.value : this.currency,
      openingMinor: data.openingMinor.present
          ? data.openingMinor.value
          : this.openingMinor,
      closingMinor: data.closingMinor.present
          ? data.closingMinor.value
          : this.closingMinor,
      debitMinor: data.debitMinor.present
          ? data.debitMinor.value
          : this.debitMinor,
      creditMinor: data.creditMinor.present
          ? data.creditMinor.value
          : this.creditMinor,
      rowCount: data.rowCount.present ? data.rowCount.value : this.rowCount,
      addedCount: data.addedCount.present
          ? data.addedCount.value
          : this.addedCount,
      matchedCount: data.matchedCount.present
          ? data.matchedCount.value
          : this.matchedCount,
      skippedCount: data.skippedCount.present
          ? data.skippedCount.value
          : this.skippedCount,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportJob(')
          ..write('id: $id, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('source: $source, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileName: $fileName, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('mappingJson: $mappingJson, ')
          ..write('status: $status, ')
          ..write('currency: $currency, ')
          ..write('openingMinor: $openingMinor, ')
          ..write('closingMinor: $closingMinor, ')
          ..write('debitMinor: $debitMinor, ')
          ..write('creditMinor: $creditMinor, ')
          ..write('rowCount: $rowCount, ')
          ..write('addedCount: $addedCount, ')
          ..write('matchedCount: $matchedCount, ')
          ..write('skippedCount: $skippedCount, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceAccountId,
    source,
    fileHash,
    fileName,
    parserVersion,
    mappingJson,
    status,
    currency,
    openingMinor,
    closingMinor,
    debitMinor,
    creditMinor,
    rowCount,
    addedCount,
    matchedCount,
    skippedCount,
    error,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportJob &&
          other.id == this.id &&
          other.sourceAccountId == this.sourceAccountId &&
          other.source == this.source &&
          other.fileHash == this.fileHash &&
          other.fileName == this.fileName &&
          other.parserVersion == this.parserVersion &&
          other.mappingJson == this.mappingJson &&
          other.status == this.status &&
          other.currency == this.currency &&
          other.openingMinor == this.openingMinor &&
          other.closingMinor == this.closingMinor &&
          other.debitMinor == this.debitMinor &&
          other.creditMinor == this.creditMinor &&
          other.rowCount == this.rowCount &&
          other.addedCount == this.addedCount &&
          other.matchedCount == this.matchedCount &&
          other.skippedCount == this.skippedCount &&
          other.error == this.error &&
          other.createdAt == this.createdAt);
}

class ImportJobsCompanion extends UpdateCompanion<ImportJob> {
  final Value<int> id;
  final Value<int> sourceAccountId;
  final Value<String> source;
  final Value<String> fileHash;
  final Value<String> fileName;
  final Value<int> parserVersion;
  final Value<String> mappingJson;
  final Value<String> status;
  final Value<String> currency;
  final Value<int> openingMinor;
  final Value<int> closingMinor;
  final Value<int> debitMinor;
  final Value<int> creditMinor;
  final Value<int> rowCount;
  final Value<int> addedCount;
  final Value<int> matchedCount;
  final Value<int> skippedCount;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  const ImportJobsCompanion({
    this.id = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.source = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileName = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.mappingJson = const Value.absent(),
    this.status = const Value.absent(),
    this.currency = const Value.absent(),
    this.openingMinor = const Value.absent(),
    this.closingMinor = const Value.absent(),
    this.debitMinor = const Value.absent(),
    this.creditMinor = const Value.absent(),
    this.rowCount = const Value.absent(),
    this.addedCount = const Value.absent(),
    this.matchedCount = const Value.absent(),
    this.skippedCount = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ImportJobsCompanion.insert({
    this.id = const Value.absent(),
    required int sourceAccountId,
    this.source = const Value.absent(),
    required String fileHash,
    required String fileName,
    required int parserVersion,
    required String mappingJson,
    this.status = const Value.absent(),
    this.currency = const Value.absent(),
    required int openingMinor,
    required int closingMinor,
    required int debitMinor,
    required int creditMinor,
    required int rowCount,
    this.addedCount = const Value.absent(),
    this.matchedCount = const Value.absent(),
    this.skippedCount = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sourceAccountId = Value(sourceAccountId),
       fileHash = Value(fileHash),
       fileName = Value(fileName),
       parserVersion = Value(parserVersion),
       mappingJson = Value(mappingJson),
       openingMinor = Value(openingMinor),
       closingMinor = Value(closingMinor),
       debitMinor = Value(debitMinor),
       creditMinor = Value(creditMinor),
       rowCount = Value(rowCount);
  static Insertable<ImportJob> custom({
    Expression<int>? id,
    Expression<int>? sourceAccountId,
    Expression<String>? source,
    Expression<String>? fileHash,
    Expression<String>? fileName,
    Expression<int>? parserVersion,
    Expression<String>? mappingJson,
    Expression<String>? status,
    Expression<String>? currency,
    Expression<int>? openingMinor,
    Expression<int>? closingMinor,
    Expression<int>? debitMinor,
    Expression<int>? creditMinor,
    Expression<int>? rowCount,
    Expression<int>? addedCount,
    Expression<int>? matchedCount,
    Expression<int>? skippedCount,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (source != null) 'source': source,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileName != null) 'file_name': fileName,
      if (parserVersion != null) 'parser_version': parserVersion,
      if (mappingJson != null) 'mapping_json': mappingJson,
      if (status != null) 'status': status,
      if (currency != null) 'currency': currency,
      if (openingMinor != null) 'opening_minor': openingMinor,
      if (closingMinor != null) 'closing_minor': closingMinor,
      if (debitMinor != null) 'debit_minor': debitMinor,
      if (creditMinor != null) 'credit_minor': creditMinor,
      if (rowCount != null) 'row_count': rowCount,
      if (addedCount != null) 'added_count': addedCount,
      if (matchedCount != null) 'matched_count': matchedCount,
      if (skippedCount != null) 'skipped_count': skippedCount,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ImportJobsCompanion copyWith({
    Value<int>? id,
    Value<int>? sourceAccountId,
    Value<String>? source,
    Value<String>? fileHash,
    Value<String>? fileName,
    Value<int>? parserVersion,
    Value<String>? mappingJson,
    Value<String>? status,
    Value<String>? currency,
    Value<int>? openingMinor,
    Value<int>? closingMinor,
    Value<int>? debitMinor,
    Value<int>? creditMinor,
    Value<int>? rowCount,
    Value<int>? addedCount,
    Value<int>? matchedCount,
    Value<int>? skippedCount,
    Value<String?>? error,
    Value<DateTime>? createdAt,
  }) {
    return ImportJobsCompanion(
      id: id ?? this.id,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      source: source ?? this.source,
      fileHash: fileHash ?? this.fileHash,
      fileName: fileName ?? this.fileName,
      parserVersion: parserVersion ?? this.parserVersion,
      mappingJson: mappingJson ?? this.mappingJson,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      openingMinor: openingMinor ?? this.openingMinor,
      closingMinor: closingMinor ?? this.closingMinor,
      debitMinor: debitMinor ?? this.debitMinor,
      creditMinor: creditMinor ?? this.creditMinor,
      rowCount: rowCount ?? this.rowCount,
      addedCount: addedCount ?? this.addedCount,
      matchedCount: matchedCount ?? this.matchedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<int>(sourceAccountId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (parserVersion.present) {
      map['parser_version'] = Variable<int>(parserVersion.value);
    }
    if (mappingJson.present) {
      map['mapping_json'] = Variable<String>(mappingJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (openingMinor.present) {
      map['opening_minor'] = Variable<int>(openingMinor.value);
    }
    if (closingMinor.present) {
      map['closing_minor'] = Variable<int>(closingMinor.value);
    }
    if (debitMinor.present) {
      map['debit_minor'] = Variable<int>(debitMinor.value);
    }
    if (creditMinor.present) {
      map['credit_minor'] = Variable<int>(creditMinor.value);
    }
    if (rowCount.present) {
      map['row_count'] = Variable<int>(rowCount.value);
    }
    if (addedCount.present) {
      map['added_count'] = Variable<int>(addedCount.value);
    }
    if (matchedCount.present) {
      map['matched_count'] = Variable<int>(matchedCount.value);
    }
    if (skippedCount.present) {
      map['skipped_count'] = Variable<int>(skippedCount.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportJobsCompanion(')
          ..write('id: $id, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('source: $source, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileName: $fileName, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('mappingJson: $mappingJson, ')
          ..write('status: $status, ')
          ..write('currency: $currency, ')
          ..write('openingMinor: $openingMinor, ')
          ..write('closingMinor: $closingMinor, ')
          ..write('debitMinor: $debitMinor, ')
          ..write('creditMinor: $creditMinor, ')
          ..write('rowCount: $rowCount, ')
          ..write('addedCount: $addedCount, ')
          ..write('matchedCount: $matchedCount, ')
          ..write('skippedCount: $skippedCount, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _encryptedFilePathMeta = const VerificationMeta(
    'encryptedFilePath',
  );
  @override
  late final GeneratedColumn<String> encryptedFilePath =
      GeneratedColumn<String>(
        'encrypted_file_path',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      );
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentTypeMeta = const VerificationMeta(
    'documentType',
  );
  @override
  late final GeneratedColumn<String> documentType = GeneratedColumn<String>(
    'document_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('invoice_pdf'),
  );
  static const VerificationMeta _byteLengthMeta = const VerificationMeta(
    'byteLength',
  );
  @override
  late final GeneratedColumn<int> byteLength = GeneratedColumn<int>(
    'byte_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptionVersionMeta = const VerificationMeta(
    'encryptionVersion',
  );
  @override
  late final GeneratedColumn<int> encryptionVersion = GeneratedColumn<int>(
    'encryption_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _extractionVersionMeta = const VerificationMeta(
    'extractionVersion',
  );
  @override
  late final GeneratedColumn<int> extractionVersion = GeneratedColumn<int>(
    'extraction_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _extractionStatusMeta = const VerificationMeta(
    'extractionStatus',
  );
  @override
  late final GeneratedColumn<String> extractionStatus = GeneratedColumn<String>(
    'extraction_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_extracted'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sha256,
    encryptedFilePath,
    originalName,
    documentType,
    byteLength,
    encryptionVersion,
    extractionVersion,
    extractionStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('encrypted_file_path')) {
      context.handle(
        _encryptedFilePathMeta,
        encryptedFilePath.isAcceptableOrUnknown(
          data['encrypted_file_path']!,
          _encryptedFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedFilePathMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('document_type')) {
      context.handle(
        _documentTypeMeta,
        documentType.isAcceptableOrUnknown(
          data['document_type']!,
          _documentTypeMeta,
        ),
      );
    }
    if (data.containsKey('byte_length')) {
      context.handle(
        _byteLengthMeta,
        byteLength.isAcceptableOrUnknown(data['byte_length']!, _byteLengthMeta),
      );
    } else if (isInserting) {
      context.missing(_byteLengthMeta);
    }
    if (data.containsKey('encryption_version')) {
      context.handle(
        _encryptionVersionMeta,
        encryptionVersion.isAcceptableOrUnknown(
          data['encryption_version']!,
          _encryptionVersionMeta,
        ),
      );
    }
    if (data.containsKey('extraction_version')) {
      context.handle(
        _extractionVersionMeta,
        extractionVersion.isAcceptableOrUnknown(
          data['extraction_version']!,
          _extractionVersionMeta,
        ),
      );
    }
    if (data.containsKey('extraction_status')) {
      context.handle(
        _extractionStatusMeta,
        extractionStatus.isAcceptableOrUnknown(
          data['extraction_status']!,
          _extractionStatusMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      encryptedFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_file_path'],
      )!,
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      )!,
      documentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_type'],
      )!,
      byteLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_length'],
      )!,
      encryptionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}encryption_version'],
      )!,
      extractionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extraction_version'],
      )!,
      extractionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final String sha256;
  final String encryptedFilePath;
  final String originalName;
  final String documentType;
  final int byteLength;
  final int encryptionVersion;
  final int extractionVersion;
  final String extractionStatus;
  final DateTime createdAt;
  const Document({
    required this.id,
    required this.sha256,
    required this.encryptedFilePath,
    required this.originalName,
    required this.documentType,
    required this.byteLength,
    required this.encryptionVersion,
    required this.extractionVersion,
    required this.extractionStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sha256'] = Variable<String>(sha256);
    map['encrypted_file_path'] = Variable<String>(encryptedFilePath);
    map['original_name'] = Variable<String>(originalName);
    map['document_type'] = Variable<String>(documentType);
    map['byte_length'] = Variable<int>(byteLength);
    map['encryption_version'] = Variable<int>(encryptionVersion);
    map['extraction_version'] = Variable<int>(extractionVersion);
    map['extraction_status'] = Variable<String>(extractionStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      sha256: Value(sha256),
      encryptedFilePath: Value(encryptedFilePath),
      originalName: Value(originalName),
      documentType: Value(documentType),
      byteLength: Value(byteLength),
      encryptionVersion: Value(encryptionVersion),
      extractionVersion: Value(extractionVersion),
      extractionStatus: Value(extractionStatus),
      createdAt: Value(createdAt),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      sha256: serializer.fromJson<String>(json['sha256']),
      encryptedFilePath: serializer.fromJson<String>(json['encryptedFilePath']),
      originalName: serializer.fromJson<String>(json['originalName']),
      documentType: serializer.fromJson<String>(json['documentType']),
      byteLength: serializer.fromJson<int>(json['byteLength']),
      encryptionVersion: serializer.fromJson<int>(json['encryptionVersion']),
      extractionVersion: serializer.fromJson<int>(json['extractionVersion']),
      extractionStatus: serializer.fromJson<String>(json['extractionStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sha256': serializer.toJson<String>(sha256),
      'encryptedFilePath': serializer.toJson<String>(encryptedFilePath),
      'originalName': serializer.toJson<String>(originalName),
      'documentType': serializer.toJson<String>(documentType),
      'byteLength': serializer.toJson<int>(byteLength),
      'encryptionVersion': serializer.toJson<int>(encryptionVersion),
      'extractionVersion': serializer.toJson<int>(extractionVersion),
      'extractionStatus': serializer.toJson<String>(extractionStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Document copyWith({
    int? id,
    String? sha256,
    String? encryptedFilePath,
    String? originalName,
    String? documentType,
    int? byteLength,
    int? encryptionVersion,
    int? extractionVersion,
    String? extractionStatus,
    DateTime? createdAt,
  }) => Document(
    id: id ?? this.id,
    sha256: sha256 ?? this.sha256,
    encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
    originalName: originalName ?? this.originalName,
    documentType: documentType ?? this.documentType,
    byteLength: byteLength ?? this.byteLength,
    encryptionVersion: encryptionVersion ?? this.encryptionVersion,
    extractionVersion: extractionVersion ?? this.extractionVersion,
    extractionStatus: extractionStatus ?? this.extractionStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      encryptedFilePath: data.encryptedFilePath.present
          ? data.encryptedFilePath.value
          : this.encryptedFilePath,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      byteLength: data.byteLength.present
          ? data.byteLength.value
          : this.byteLength,
      encryptionVersion: data.encryptionVersion.present
          ? data.encryptionVersion.value
          : this.encryptionVersion,
      extractionVersion: data.extractionVersion.present
          ? data.extractionVersion.value
          : this.extractionVersion,
      extractionStatus: data.extractionStatus.present
          ? data.extractionStatus.value
          : this.extractionStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('sha256: $sha256, ')
          ..write('encryptedFilePath: $encryptedFilePath, ')
          ..write('originalName: $originalName, ')
          ..write('documentType: $documentType, ')
          ..write('byteLength: $byteLength, ')
          ..write('encryptionVersion: $encryptionVersion, ')
          ..write('extractionVersion: $extractionVersion, ')
          ..write('extractionStatus: $extractionStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sha256,
    encryptedFilePath,
    originalName,
    documentType,
    byteLength,
    encryptionVersion,
    extractionVersion,
    extractionStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.sha256 == this.sha256 &&
          other.encryptedFilePath == this.encryptedFilePath &&
          other.originalName == this.originalName &&
          other.documentType == this.documentType &&
          other.byteLength == this.byteLength &&
          other.encryptionVersion == this.encryptionVersion &&
          other.extractionVersion == this.extractionVersion &&
          other.extractionStatus == this.extractionStatus &&
          other.createdAt == this.createdAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<String> sha256;
  final Value<String> encryptedFilePath;
  final Value<String> originalName;
  final Value<String> documentType;
  final Value<int> byteLength;
  final Value<int> encryptionVersion;
  final Value<int> extractionVersion;
  final Value<String> extractionStatus;
  final Value<DateTime> createdAt;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.encryptedFilePath = const Value.absent(),
    this.originalName = const Value.absent(),
    this.documentType = const Value.absent(),
    this.byteLength = const Value.absent(),
    this.encryptionVersion = const Value.absent(),
    this.extractionVersion = const Value.absent(),
    this.extractionStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String sha256,
    required String encryptedFilePath,
    required String originalName,
    this.documentType = const Value.absent(),
    required int byteLength,
    this.encryptionVersion = const Value.absent(),
    this.extractionVersion = const Value.absent(),
    this.extractionStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sha256 = Value(sha256),
       encryptedFilePath = Value(encryptedFilePath),
       originalName = Value(originalName),
       byteLength = Value(byteLength);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<String>? sha256,
    Expression<String>? encryptedFilePath,
    Expression<String>? originalName,
    Expression<String>? documentType,
    Expression<int>? byteLength,
    Expression<int>? encryptionVersion,
    Expression<int>? extractionVersion,
    Expression<String>? extractionStatus,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sha256 != null) 'sha256': sha256,
      if (encryptedFilePath != null) 'encrypted_file_path': encryptedFilePath,
      if (originalName != null) 'original_name': originalName,
      if (documentType != null) 'document_type': documentType,
      if (byteLength != null) 'byte_length': byteLength,
      if (encryptionVersion != null) 'encryption_version': encryptionVersion,
      if (extractionVersion != null) 'extraction_version': extractionVersion,
      if (extractionStatus != null) 'extraction_status': extractionStatus,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocumentsCompanion copyWith({
    Value<int>? id,
    Value<String>? sha256,
    Value<String>? encryptedFilePath,
    Value<String>? originalName,
    Value<String>? documentType,
    Value<int>? byteLength,
    Value<int>? encryptionVersion,
    Value<int>? extractionVersion,
    Value<String>? extractionStatus,
    Value<DateTime>? createdAt,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      sha256: sha256 ?? this.sha256,
      encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
      originalName: originalName ?? this.originalName,
      documentType: documentType ?? this.documentType,
      byteLength: byteLength ?? this.byteLength,
      encryptionVersion: encryptionVersion ?? this.encryptionVersion,
      extractionVersion: extractionVersion ?? this.extractionVersion,
      extractionStatus: extractionStatus ?? this.extractionStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (encryptedFilePath.present) {
      map['encrypted_file_path'] = Variable<String>(encryptedFilePath.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(documentType.value);
    }
    if (byteLength.present) {
      map['byte_length'] = Variable<int>(byteLength.value);
    }
    if (encryptionVersion.present) {
      map['encryption_version'] = Variable<int>(encryptionVersion.value);
    }
    if (extractionVersion.present) {
      map['extraction_version'] = Variable<int>(extractionVersion.value);
    }
    if (extractionStatus.present) {
      map['extraction_status'] = Variable<String>(extractionStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('sha256: $sha256, ')
          ..write('encryptedFilePath: $encryptedFilePath, ')
          ..write('originalName: $originalName, ')
          ..write('documentType: $documentType, ')
          ..write('byteLength: $byteLength, ')
          ..write('encryptionVersion: $encryptionVersion, ')
          ..write('extractionVersion: $extractionVersion, ')
          ..write('extractionStatus: $extractionStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('invoice'),
  );
  static const VerificationMeta _supplierGstinMeta = const VerificationMeta(
    'supplierGstin',
  );
  @override
  late final GeneratedColumn<String> supplierGstin = GeneratedColumn<String>(
    'supplier_gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recipientGstinMeta = const VerificationMeta(
    'recipientGstin',
  );
  @override
  late final GeneratedColumn<String> recipientGstin = GeneratedColumn<String>(
    'recipient_gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vendorNameMeta = const VerificationMeta(
    'vendorName',
  );
  @override
  late final GeneratedColumn<String> vendorName = GeneratedColumn<String>(
    'vendor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> invoiceDate = GeneratedColumn<DateTime>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _taxableMinorMeta = const VerificationMeta(
    'taxableMinor',
  );
  @override
  late final GeneratedColumn<int> taxableMinor = GeneratedColumn<int>(
    'taxable_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cgstMinorMeta = const VerificationMeta(
    'cgstMinor',
  );
  @override
  late final GeneratedColumn<int> cgstMinor = GeneratedColumn<int>(
    'cgst_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sgstMinorMeta = const VerificationMeta(
    'sgstMinor',
  );
  @override
  late final GeneratedColumn<int> sgstMinor = GeneratedColumn<int>(
    'sgst_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _igstMinorMeta = const VerificationMeta(
    'igstMinor',
  );
  @override
  late final GeneratedColumn<int> igstMinor = GeneratedColumn<int>(
    'igst_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cessMinorMeta = const VerificationMeta(
    'cessMinor',
  );
  @override
  late final GeneratedColumn<int> cessMinor = GeneratedColumn<int>(
    'cess_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _roundingMinorMeta = const VerificationMeta(
    'roundingMinor',
  );
  @override
  late final GeneratedColumn<int> roundingMinor = GeneratedColumn<int>(
    'rounding_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arithmeticStatusMeta = const VerificationMeta(
    'arithmeticStatus',
  );
  @override
  late final GeneratedColumn<String> arithmeticStatus = GeneratedColumn<String>(
    'arithmetic_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('needs_review'),
  );
  static const VerificationMeta _gstEligibilityStatusMeta =
      const VerificationMeta('gstEligibilityStatus');
  @override
  late final GeneratedColumn<String> gstEligibilityStatus =
      GeneratedColumn<String>(
        'gst_eligibility_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('not_assessed'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    kind,
    supplierGstin,
    recipientGstin,
    vendorName,
    invoiceNumber,
    invoiceDate,
    currency,
    taxableMinor,
    cgstMinor,
    sgstMinor,
    igstMinor,
    cessMinor,
    roundingMinor,
    totalMinor,
    arithmeticStatus,
    gstEligibilityStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('supplier_gstin')) {
      context.handle(
        _supplierGstinMeta,
        supplierGstin.isAcceptableOrUnknown(
          data['supplier_gstin']!,
          _supplierGstinMeta,
        ),
      );
    }
    if (data.containsKey('recipient_gstin')) {
      context.handle(
        _recipientGstinMeta,
        recipientGstin.isAcceptableOrUnknown(
          data['recipient_gstin']!,
          _recipientGstinMeta,
        ),
      );
    }
    if (data.containsKey('vendor_name')) {
      context.handle(
        _vendorNameMeta,
        vendorName.isAcceptableOrUnknown(data['vendor_name']!, _vendorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorNameMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('taxable_minor')) {
      context.handle(
        _taxableMinorMeta,
        taxableMinor.isAcceptableOrUnknown(
          data['taxable_minor']!,
          _taxableMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxableMinorMeta);
    }
    if (data.containsKey('cgst_minor')) {
      context.handle(
        _cgstMinorMeta,
        cgstMinor.isAcceptableOrUnknown(data['cgst_minor']!, _cgstMinorMeta),
      );
    }
    if (data.containsKey('sgst_minor')) {
      context.handle(
        _sgstMinorMeta,
        sgstMinor.isAcceptableOrUnknown(data['sgst_minor']!, _sgstMinorMeta),
      );
    }
    if (data.containsKey('igst_minor')) {
      context.handle(
        _igstMinorMeta,
        igstMinor.isAcceptableOrUnknown(data['igst_minor']!, _igstMinorMeta),
      );
    }
    if (data.containsKey('cess_minor')) {
      context.handle(
        _cessMinorMeta,
        cessMinor.isAcceptableOrUnknown(data['cess_minor']!, _cessMinorMeta),
      );
    }
    if (data.containsKey('rounding_minor')) {
      context.handle(
        _roundingMinorMeta,
        roundingMinor.isAcceptableOrUnknown(
          data['rounding_minor']!,
          _roundingMinorMeta,
        ),
      );
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    if (data.containsKey('arithmetic_status')) {
      context.handle(
        _arithmeticStatusMeta,
        arithmeticStatus.isAcceptableOrUnknown(
          data['arithmetic_status']!,
          _arithmeticStatusMeta,
        ),
      );
    }
    if (data.containsKey('gst_eligibility_status')) {
      context.handle(
        _gstEligibilityStatusMeta,
        gstEligibilityStatus.isAcceptableOrUnknown(
          data['gst_eligibility_status']!,
          _gstEligibilityStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      supplierGstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_gstin'],
      ),
      recipientGstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_gstin'],
      ),
      vendorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_name'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}invoice_date'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      taxableMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxable_minor'],
      )!,
      cgstMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cgst_minor'],
      )!,
      sgstMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sgst_minor'],
      )!,
      igstMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}igst_minor'],
      )!,
      cessMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cess_minor'],
      )!,
      roundingMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounding_minor'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      arithmeticStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arithmetic_status'],
      )!,
      gstEligibilityStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_eligibility_status'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final int documentId;
  final String kind;
  final String? supplierGstin;
  final String? recipientGstin;
  final String vendorName;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final String currency;
  final int taxableMinor;
  final int cgstMinor;
  final int sgstMinor;
  final int igstMinor;
  final int cessMinor;
  final int roundingMinor;
  final int totalMinor;
  final String arithmeticStatus;
  final String gstEligibilityStatus;
  const Invoice({
    required this.id,
    required this.documentId,
    required this.kind,
    this.supplierGstin,
    this.recipientGstin,
    required this.vendorName,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.currency,
    required this.taxableMinor,
    required this.cgstMinor,
    required this.sgstMinor,
    required this.igstMinor,
    required this.cessMinor,
    required this.roundingMinor,
    required this.totalMinor,
    required this.arithmeticStatus,
    required this.gstEligibilityStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<int>(documentId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || supplierGstin != null) {
      map['supplier_gstin'] = Variable<String>(supplierGstin);
    }
    if (!nullToAbsent || recipientGstin != null) {
      map['recipient_gstin'] = Variable<String>(recipientGstin);
    }
    map['vendor_name'] = Variable<String>(vendorName);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    map['currency'] = Variable<String>(currency);
    map['taxable_minor'] = Variable<int>(taxableMinor);
    map['cgst_minor'] = Variable<int>(cgstMinor);
    map['sgst_minor'] = Variable<int>(sgstMinor);
    map['igst_minor'] = Variable<int>(igstMinor);
    map['cess_minor'] = Variable<int>(cessMinor);
    map['rounding_minor'] = Variable<int>(roundingMinor);
    map['total_minor'] = Variable<int>(totalMinor);
    map['arithmetic_status'] = Variable<String>(arithmeticStatus);
    map['gst_eligibility_status'] = Variable<String>(gstEligibilityStatus);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      kind: Value(kind),
      supplierGstin: supplierGstin == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierGstin),
      recipientGstin: recipientGstin == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientGstin),
      vendorName: Value(vendorName),
      invoiceNumber: Value(invoiceNumber),
      invoiceDate: Value(invoiceDate),
      currency: Value(currency),
      taxableMinor: Value(taxableMinor),
      cgstMinor: Value(cgstMinor),
      sgstMinor: Value(sgstMinor),
      igstMinor: Value(igstMinor),
      cessMinor: Value(cessMinor),
      roundingMinor: Value(roundingMinor),
      totalMinor: Value(totalMinor),
      arithmeticStatus: Value(arithmeticStatus),
      gstEligibilityStatus: Value(gstEligibilityStatus),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<int>(json['documentId']),
      kind: serializer.fromJson<String>(json['kind']),
      supplierGstin: serializer.fromJson<String?>(json['supplierGstin']),
      recipientGstin: serializer.fromJson<String?>(json['recipientGstin']),
      vendorName: serializer.fromJson<String>(json['vendorName']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      currency: serializer.fromJson<String>(json['currency']),
      taxableMinor: serializer.fromJson<int>(json['taxableMinor']),
      cgstMinor: serializer.fromJson<int>(json['cgstMinor']),
      sgstMinor: serializer.fromJson<int>(json['sgstMinor']),
      igstMinor: serializer.fromJson<int>(json['igstMinor']),
      cessMinor: serializer.fromJson<int>(json['cessMinor']),
      roundingMinor: serializer.fromJson<int>(json['roundingMinor']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      arithmeticStatus: serializer.fromJson<String>(json['arithmeticStatus']),
      gstEligibilityStatus: serializer.fromJson<String>(
        json['gstEligibilityStatus'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<int>(documentId),
      'kind': serializer.toJson<String>(kind),
      'supplierGstin': serializer.toJson<String?>(supplierGstin),
      'recipientGstin': serializer.toJson<String?>(recipientGstin),
      'vendorName': serializer.toJson<String>(vendorName),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'currency': serializer.toJson<String>(currency),
      'taxableMinor': serializer.toJson<int>(taxableMinor),
      'cgstMinor': serializer.toJson<int>(cgstMinor),
      'sgstMinor': serializer.toJson<int>(sgstMinor),
      'igstMinor': serializer.toJson<int>(igstMinor),
      'cessMinor': serializer.toJson<int>(cessMinor),
      'roundingMinor': serializer.toJson<int>(roundingMinor),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'arithmeticStatus': serializer.toJson<String>(arithmeticStatus),
      'gstEligibilityStatus': serializer.toJson<String>(gstEligibilityStatus),
    };
  }

  Invoice copyWith({
    int? id,
    int? documentId,
    String? kind,
    Value<String?> supplierGstin = const Value.absent(),
    Value<String?> recipientGstin = const Value.absent(),
    String? vendorName,
    String? invoiceNumber,
    DateTime? invoiceDate,
    String? currency,
    int? taxableMinor,
    int? cgstMinor,
    int? sgstMinor,
    int? igstMinor,
    int? cessMinor,
    int? roundingMinor,
    int? totalMinor,
    String? arithmeticStatus,
    String? gstEligibilityStatus,
  }) => Invoice(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    kind: kind ?? this.kind,
    supplierGstin: supplierGstin.present
        ? supplierGstin.value
        : this.supplierGstin,
    recipientGstin: recipientGstin.present
        ? recipientGstin.value
        : this.recipientGstin,
    vendorName: vendorName ?? this.vendorName,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    currency: currency ?? this.currency,
    taxableMinor: taxableMinor ?? this.taxableMinor,
    cgstMinor: cgstMinor ?? this.cgstMinor,
    sgstMinor: sgstMinor ?? this.sgstMinor,
    igstMinor: igstMinor ?? this.igstMinor,
    cessMinor: cessMinor ?? this.cessMinor,
    roundingMinor: roundingMinor ?? this.roundingMinor,
    totalMinor: totalMinor ?? this.totalMinor,
    arithmeticStatus: arithmeticStatus ?? this.arithmeticStatus,
    gstEligibilityStatus: gstEligibilityStatus ?? this.gstEligibilityStatus,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      supplierGstin: data.supplierGstin.present
          ? data.supplierGstin.value
          : this.supplierGstin,
      recipientGstin: data.recipientGstin.present
          ? data.recipientGstin.value
          : this.recipientGstin,
      vendorName: data.vendorName.present
          ? data.vendorName.value
          : this.vendorName,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      taxableMinor: data.taxableMinor.present
          ? data.taxableMinor.value
          : this.taxableMinor,
      cgstMinor: data.cgstMinor.present ? data.cgstMinor.value : this.cgstMinor,
      sgstMinor: data.sgstMinor.present ? data.sgstMinor.value : this.sgstMinor,
      igstMinor: data.igstMinor.present ? data.igstMinor.value : this.igstMinor,
      cessMinor: data.cessMinor.present ? data.cessMinor.value : this.cessMinor,
      roundingMinor: data.roundingMinor.present
          ? data.roundingMinor.value
          : this.roundingMinor,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      arithmeticStatus: data.arithmeticStatus.present
          ? data.arithmeticStatus.value
          : this.arithmeticStatus,
      gstEligibilityStatus: data.gstEligibilityStatus.present
          ? data.gstEligibilityStatus.value
          : this.gstEligibilityStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('kind: $kind, ')
          ..write('supplierGstin: $supplierGstin, ')
          ..write('recipientGstin: $recipientGstin, ')
          ..write('vendorName: $vendorName, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('currency: $currency, ')
          ..write('taxableMinor: $taxableMinor, ')
          ..write('cgstMinor: $cgstMinor, ')
          ..write('sgstMinor: $sgstMinor, ')
          ..write('igstMinor: $igstMinor, ')
          ..write('cessMinor: $cessMinor, ')
          ..write('roundingMinor: $roundingMinor, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('arithmeticStatus: $arithmeticStatus, ')
          ..write('gstEligibilityStatus: $gstEligibilityStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    kind,
    supplierGstin,
    recipientGstin,
    vendorName,
    invoiceNumber,
    invoiceDate,
    currency,
    taxableMinor,
    cgstMinor,
    sgstMinor,
    igstMinor,
    cessMinor,
    roundingMinor,
    totalMinor,
    arithmeticStatus,
    gstEligibilityStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.kind == this.kind &&
          other.supplierGstin == this.supplierGstin &&
          other.recipientGstin == this.recipientGstin &&
          other.vendorName == this.vendorName &&
          other.invoiceNumber == this.invoiceNumber &&
          other.invoiceDate == this.invoiceDate &&
          other.currency == this.currency &&
          other.taxableMinor == this.taxableMinor &&
          other.cgstMinor == this.cgstMinor &&
          other.sgstMinor == this.sgstMinor &&
          other.igstMinor == this.igstMinor &&
          other.cessMinor == this.cessMinor &&
          other.roundingMinor == this.roundingMinor &&
          other.totalMinor == this.totalMinor &&
          other.arithmeticStatus == this.arithmeticStatus &&
          other.gstEligibilityStatus == this.gstEligibilityStatus);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<int> documentId;
  final Value<String> kind;
  final Value<String?> supplierGstin;
  final Value<String?> recipientGstin;
  final Value<String> vendorName;
  final Value<String> invoiceNumber;
  final Value<DateTime> invoiceDate;
  final Value<String> currency;
  final Value<int> taxableMinor;
  final Value<int> cgstMinor;
  final Value<int> sgstMinor;
  final Value<int> igstMinor;
  final Value<int> cessMinor;
  final Value<int> roundingMinor;
  final Value<int> totalMinor;
  final Value<String> arithmeticStatus;
  final Value<String> gstEligibilityStatus;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.supplierGstin = const Value.absent(),
    this.recipientGstin = const Value.absent(),
    this.vendorName = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.taxableMinor = const Value.absent(),
    this.cgstMinor = const Value.absent(),
    this.sgstMinor = const Value.absent(),
    this.igstMinor = const Value.absent(),
    this.cessMinor = const Value.absent(),
    this.roundingMinor = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.arithmeticStatus = const Value.absent(),
    this.gstEligibilityStatus = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required int documentId,
    this.kind = const Value.absent(),
    this.supplierGstin = const Value.absent(),
    this.recipientGstin = const Value.absent(),
    required String vendorName,
    required String invoiceNumber,
    required DateTime invoiceDate,
    this.currency = const Value.absent(),
    required int taxableMinor,
    this.cgstMinor = const Value.absent(),
    this.sgstMinor = const Value.absent(),
    this.igstMinor = const Value.absent(),
    this.cessMinor = const Value.absent(),
    this.roundingMinor = const Value.absent(),
    required int totalMinor,
    this.arithmeticStatus = const Value.absent(),
    this.gstEligibilityStatus = const Value.absent(),
  }) : documentId = Value(documentId),
       vendorName = Value(vendorName),
       invoiceNumber = Value(invoiceNumber),
       invoiceDate = Value(invoiceDate),
       taxableMinor = Value(taxableMinor),
       totalMinor = Value(totalMinor);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<int>? documentId,
    Expression<String>? kind,
    Expression<String>? supplierGstin,
    Expression<String>? recipientGstin,
    Expression<String>? vendorName,
    Expression<String>? invoiceNumber,
    Expression<DateTime>? invoiceDate,
    Expression<String>? currency,
    Expression<int>? taxableMinor,
    Expression<int>? cgstMinor,
    Expression<int>? sgstMinor,
    Expression<int>? igstMinor,
    Expression<int>? cessMinor,
    Expression<int>? roundingMinor,
    Expression<int>? totalMinor,
    Expression<String>? arithmeticStatus,
    Expression<String>? gstEligibilityStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (kind != null) 'kind': kind,
      if (supplierGstin != null) 'supplier_gstin': supplierGstin,
      if (recipientGstin != null) 'recipient_gstin': recipientGstin,
      if (vendorName != null) 'vendor_name': vendorName,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (currency != null) 'currency': currency,
      if (taxableMinor != null) 'taxable_minor': taxableMinor,
      if (cgstMinor != null) 'cgst_minor': cgstMinor,
      if (sgstMinor != null) 'sgst_minor': sgstMinor,
      if (igstMinor != null) 'igst_minor': igstMinor,
      if (cessMinor != null) 'cess_minor': cessMinor,
      if (roundingMinor != null) 'rounding_minor': roundingMinor,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (arithmeticStatus != null) 'arithmetic_status': arithmeticStatus,
      if (gstEligibilityStatus != null)
        'gst_eligibility_status': gstEligibilityStatus,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<int>? documentId,
    Value<String>? kind,
    Value<String?>? supplierGstin,
    Value<String?>? recipientGstin,
    Value<String>? vendorName,
    Value<String>? invoiceNumber,
    Value<DateTime>? invoiceDate,
    Value<String>? currency,
    Value<int>? taxableMinor,
    Value<int>? cgstMinor,
    Value<int>? sgstMinor,
    Value<int>? igstMinor,
    Value<int>? cessMinor,
    Value<int>? roundingMinor,
    Value<int>? totalMinor,
    Value<String>? arithmeticStatus,
    Value<String>? gstEligibilityStatus,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      kind: kind ?? this.kind,
      supplierGstin: supplierGstin ?? this.supplierGstin,
      recipientGstin: recipientGstin ?? this.recipientGstin,
      vendorName: vendorName ?? this.vendorName,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      currency: currency ?? this.currency,
      taxableMinor: taxableMinor ?? this.taxableMinor,
      cgstMinor: cgstMinor ?? this.cgstMinor,
      sgstMinor: sgstMinor ?? this.sgstMinor,
      igstMinor: igstMinor ?? this.igstMinor,
      cessMinor: cessMinor ?? this.cessMinor,
      roundingMinor: roundingMinor ?? this.roundingMinor,
      totalMinor: totalMinor ?? this.totalMinor,
      arithmeticStatus: arithmeticStatus ?? this.arithmeticStatus,
      gstEligibilityStatus: gstEligibilityStatus ?? this.gstEligibilityStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (supplierGstin.present) {
      map['supplier_gstin'] = Variable<String>(supplierGstin.value);
    }
    if (recipientGstin.present) {
      map['recipient_gstin'] = Variable<String>(recipientGstin.value);
    }
    if (vendorName.present) {
      map['vendor_name'] = Variable<String>(vendorName.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<DateTime>(invoiceDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (taxableMinor.present) {
      map['taxable_minor'] = Variable<int>(taxableMinor.value);
    }
    if (cgstMinor.present) {
      map['cgst_minor'] = Variable<int>(cgstMinor.value);
    }
    if (sgstMinor.present) {
      map['sgst_minor'] = Variable<int>(sgstMinor.value);
    }
    if (igstMinor.present) {
      map['igst_minor'] = Variable<int>(igstMinor.value);
    }
    if (cessMinor.present) {
      map['cess_minor'] = Variable<int>(cessMinor.value);
    }
    if (roundingMinor.present) {
      map['rounding_minor'] = Variable<int>(roundingMinor.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (arithmeticStatus.present) {
      map['arithmetic_status'] = Variable<String>(arithmeticStatus.value);
    }
    if (gstEligibilityStatus.present) {
      map['gst_eligibility_status'] = Variable<String>(
        gstEligibilityStatus.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('kind: $kind, ')
          ..write('supplierGstin: $supplierGstin, ')
          ..write('recipientGstin: $recipientGstin, ')
          ..write('vendorName: $vendorName, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('currency: $currency, ')
          ..write('taxableMinor: $taxableMinor, ')
          ..write('cgstMinor: $cgstMinor, ')
          ..write('sgstMinor: $sgstMinor, ')
          ..write('igstMinor: $igstMinor, ')
          ..write('cessMinor: $cessMinor, ')
          ..write('roundingMinor: $roundingMinor, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('arithmeticStatus: $arithmeticStatus, ')
          ..write('gstEligibilityStatus: $gstEligibilityStatus')
          ..write(')'))
        .toString();
  }
}

class $InvoiceLinesTable extends InvoiceLines
    with TableInfo<$InvoiceLinesTable, InvoiceLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lineNumberMeta = const VerificationMeta(
    'lineNumber',
  );
  @override
  late final GeneratedColumn<int> lineNumber = GeneratedColumn<int>(
    'line_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnSacMeta = const VerificationMeta('hsnSac');
  @override
  late final GeneratedColumn<String> hsnSac = GeneratedColumn<String>(
    'hsn_sac',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateBpsMeta = const VerificationMeta(
    'taxRateBps',
  );
  @override
  late final GeneratedColumn<int> taxRateBps = GeneratedColumn<int>(
    'tax_rate_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxableMinorMeta = const VerificationMeta(
    'taxableMinor',
  );
  @override
  late final GeneratedColumn<int> taxableMinor = GeneratedColumn<int>(
    'taxable_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cgstMinorMeta = const VerificationMeta(
    'cgstMinor',
  );
  @override
  late final GeneratedColumn<int> cgstMinor = GeneratedColumn<int>(
    'cgst_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sgstMinorMeta = const VerificationMeta(
    'sgstMinor',
  );
  @override
  late final GeneratedColumn<int> sgstMinor = GeneratedColumn<int>(
    'sgst_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _igstMinorMeta = const VerificationMeta(
    'igstMinor',
  );
  @override
  late final GeneratedColumn<int> igstMinor = GeneratedColumn<int>(
    'igst_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cessMinorMeta = const VerificationMeta(
    'cessMinor',
  );
  @override
  late final GeneratedColumn<int> cessMinor = GeneratedColumn<int>(
    'cess_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    lineNumber,
    description,
    hsnSac,
    taxRateBps,
    taxableMinor,
    cgstMinor,
    sgstMinor,
    igstMinor,
    cessMinor,
    totalMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('line_number')) {
      context.handle(
        _lineNumberMeta,
        lineNumber.isAcceptableOrUnknown(data['line_number']!, _lineNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_lineNumberMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('hsn_sac')) {
      context.handle(
        _hsnSacMeta,
        hsnSac.isAcceptableOrUnknown(data['hsn_sac']!, _hsnSacMeta),
      );
    }
    if (data.containsKey('tax_rate_bps')) {
      context.handle(
        _taxRateBpsMeta,
        taxRateBps.isAcceptableOrUnknown(
          data['tax_rate_bps']!,
          _taxRateBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxRateBpsMeta);
    }
    if (data.containsKey('taxable_minor')) {
      context.handle(
        _taxableMinorMeta,
        taxableMinor.isAcceptableOrUnknown(
          data['taxable_minor']!,
          _taxableMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxableMinorMeta);
    }
    if (data.containsKey('cgst_minor')) {
      context.handle(
        _cgstMinorMeta,
        cgstMinor.isAcceptableOrUnknown(data['cgst_minor']!, _cgstMinorMeta),
      );
    }
    if (data.containsKey('sgst_minor')) {
      context.handle(
        _sgstMinorMeta,
        sgstMinor.isAcceptableOrUnknown(data['sgst_minor']!, _sgstMinorMeta),
      );
    }
    if (data.containsKey('igst_minor')) {
      context.handle(
        _igstMinorMeta,
        igstMinor.isAcceptableOrUnknown(data['igst_minor']!, _igstMinorMeta),
      );
    }
    if (data.containsKey('cess_minor')) {
      context.handle(
        _cessMinorMeta,
        cessMinor.isAcceptableOrUnknown(data['cess_minor']!, _cessMinorMeta),
      );
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {invoiceId, lineNumber},
  ];
  @override
  InvoiceLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      lineNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_number'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      hsnSac: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_sac'],
      ),
      taxRateBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_rate_bps'],
      )!,
      taxableMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxable_minor'],
      )!,
      cgstMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cgst_minor'],
      )!,
      sgstMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sgst_minor'],
      )!,
      igstMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}igst_minor'],
      )!,
      cessMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cess_minor'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
    );
  }

  @override
  $InvoiceLinesTable createAlias(String alias) {
    return $InvoiceLinesTable(attachedDatabase, alias);
  }
}

class InvoiceLine extends DataClass implements Insertable<InvoiceLine> {
  final int id;
  final int invoiceId;
  final int lineNumber;
  final String description;
  final String? hsnSac;
  final int taxRateBps;
  final int taxableMinor;
  final int cgstMinor;
  final int sgstMinor;
  final int igstMinor;
  final int cessMinor;
  final int totalMinor;
  const InvoiceLine({
    required this.id,
    required this.invoiceId,
    required this.lineNumber,
    required this.description,
    this.hsnSac,
    required this.taxRateBps,
    required this.taxableMinor,
    required this.cgstMinor,
    required this.sgstMinor,
    required this.igstMinor,
    required this.cessMinor,
    required this.totalMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['line_number'] = Variable<int>(lineNumber);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || hsnSac != null) {
      map['hsn_sac'] = Variable<String>(hsnSac);
    }
    map['tax_rate_bps'] = Variable<int>(taxRateBps);
    map['taxable_minor'] = Variable<int>(taxableMinor);
    map['cgst_minor'] = Variable<int>(cgstMinor);
    map['sgst_minor'] = Variable<int>(sgstMinor);
    map['igst_minor'] = Variable<int>(igstMinor);
    map['cess_minor'] = Variable<int>(cessMinor);
    map['total_minor'] = Variable<int>(totalMinor);
    return map;
  }

  InvoiceLinesCompanion toCompanion(bool nullToAbsent) {
    return InvoiceLinesCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      lineNumber: Value(lineNumber),
      description: Value(description),
      hsnSac: hsnSac == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnSac),
      taxRateBps: Value(taxRateBps),
      taxableMinor: Value(taxableMinor),
      cgstMinor: Value(cgstMinor),
      sgstMinor: Value(sgstMinor),
      igstMinor: Value(igstMinor),
      cessMinor: Value(cessMinor),
      totalMinor: Value(totalMinor),
    );
  }

  factory InvoiceLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceLine(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      lineNumber: serializer.fromJson<int>(json['lineNumber']),
      description: serializer.fromJson<String>(json['description']),
      hsnSac: serializer.fromJson<String?>(json['hsnSac']),
      taxRateBps: serializer.fromJson<int>(json['taxRateBps']),
      taxableMinor: serializer.fromJson<int>(json['taxableMinor']),
      cgstMinor: serializer.fromJson<int>(json['cgstMinor']),
      sgstMinor: serializer.fromJson<int>(json['sgstMinor']),
      igstMinor: serializer.fromJson<int>(json['igstMinor']),
      cessMinor: serializer.fromJson<int>(json['cessMinor']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'lineNumber': serializer.toJson<int>(lineNumber),
      'description': serializer.toJson<String>(description),
      'hsnSac': serializer.toJson<String?>(hsnSac),
      'taxRateBps': serializer.toJson<int>(taxRateBps),
      'taxableMinor': serializer.toJson<int>(taxableMinor),
      'cgstMinor': serializer.toJson<int>(cgstMinor),
      'sgstMinor': serializer.toJson<int>(sgstMinor),
      'igstMinor': serializer.toJson<int>(igstMinor),
      'cessMinor': serializer.toJson<int>(cessMinor),
      'totalMinor': serializer.toJson<int>(totalMinor),
    };
  }

  InvoiceLine copyWith({
    int? id,
    int? invoiceId,
    int? lineNumber,
    String? description,
    Value<String?> hsnSac = const Value.absent(),
    int? taxRateBps,
    int? taxableMinor,
    int? cgstMinor,
    int? sgstMinor,
    int? igstMinor,
    int? cessMinor,
    int? totalMinor,
  }) => InvoiceLine(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    lineNumber: lineNumber ?? this.lineNumber,
    description: description ?? this.description,
    hsnSac: hsnSac.present ? hsnSac.value : this.hsnSac,
    taxRateBps: taxRateBps ?? this.taxRateBps,
    taxableMinor: taxableMinor ?? this.taxableMinor,
    cgstMinor: cgstMinor ?? this.cgstMinor,
    sgstMinor: sgstMinor ?? this.sgstMinor,
    igstMinor: igstMinor ?? this.igstMinor,
    cessMinor: cessMinor ?? this.cessMinor,
    totalMinor: totalMinor ?? this.totalMinor,
  );
  InvoiceLine copyWithCompanion(InvoiceLinesCompanion data) {
    return InvoiceLine(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      lineNumber: data.lineNumber.present
          ? data.lineNumber.value
          : this.lineNumber,
      description: data.description.present
          ? data.description.value
          : this.description,
      hsnSac: data.hsnSac.present ? data.hsnSac.value : this.hsnSac,
      taxRateBps: data.taxRateBps.present
          ? data.taxRateBps.value
          : this.taxRateBps,
      taxableMinor: data.taxableMinor.present
          ? data.taxableMinor.value
          : this.taxableMinor,
      cgstMinor: data.cgstMinor.present ? data.cgstMinor.value : this.cgstMinor,
      sgstMinor: data.sgstMinor.present ? data.sgstMinor.value : this.sgstMinor,
      igstMinor: data.igstMinor.present ? data.igstMinor.value : this.igstMinor,
      cessMinor: data.cessMinor.present ? data.cessMinor.value : this.cessMinor,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLine(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('description: $description, ')
          ..write('hsnSac: $hsnSac, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('taxableMinor: $taxableMinor, ')
          ..write('cgstMinor: $cgstMinor, ')
          ..write('sgstMinor: $sgstMinor, ')
          ..write('igstMinor: $igstMinor, ')
          ..write('cessMinor: $cessMinor, ')
          ..write('totalMinor: $totalMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    lineNumber,
    description,
    hsnSac,
    taxRateBps,
    taxableMinor,
    cgstMinor,
    sgstMinor,
    igstMinor,
    cessMinor,
    totalMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceLine &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.lineNumber == this.lineNumber &&
          other.description == this.description &&
          other.hsnSac == this.hsnSac &&
          other.taxRateBps == this.taxRateBps &&
          other.taxableMinor == this.taxableMinor &&
          other.cgstMinor == this.cgstMinor &&
          other.sgstMinor == this.sgstMinor &&
          other.igstMinor == this.igstMinor &&
          other.cessMinor == this.cessMinor &&
          other.totalMinor == this.totalMinor);
}

class InvoiceLinesCompanion extends UpdateCompanion<InvoiceLine> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> lineNumber;
  final Value<String> description;
  final Value<String?> hsnSac;
  final Value<int> taxRateBps;
  final Value<int> taxableMinor;
  final Value<int> cgstMinor;
  final Value<int> sgstMinor;
  final Value<int> igstMinor;
  final Value<int> cessMinor;
  final Value<int> totalMinor;
  const InvoiceLinesCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.lineNumber = const Value.absent(),
    this.description = const Value.absent(),
    this.hsnSac = const Value.absent(),
    this.taxRateBps = const Value.absent(),
    this.taxableMinor = const Value.absent(),
    this.cgstMinor = const Value.absent(),
    this.sgstMinor = const Value.absent(),
    this.igstMinor = const Value.absent(),
    this.cessMinor = const Value.absent(),
    this.totalMinor = const Value.absent(),
  });
  InvoiceLinesCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required int lineNumber,
    required String description,
    this.hsnSac = const Value.absent(),
    required int taxRateBps,
    required int taxableMinor,
    this.cgstMinor = const Value.absent(),
    this.sgstMinor = const Value.absent(),
    this.igstMinor = const Value.absent(),
    this.cessMinor = const Value.absent(),
    required int totalMinor,
  }) : invoiceId = Value(invoiceId),
       lineNumber = Value(lineNumber),
       description = Value(description),
       taxRateBps = Value(taxRateBps),
       taxableMinor = Value(taxableMinor),
       totalMinor = Value(totalMinor);
  static Insertable<InvoiceLine> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? lineNumber,
    Expression<String>? description,
    Expression<String>? hsnSac,
    Expression<int>? taxRateBps,
    Expression<int>? taxableMinor,
    Expression<int>? cgstMinor,
    Expression<int>? sgstMinor,
    Expression<int>? igstMinor,
    Expression<int>? cessMinor,
    Expression<int>? totalMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (lineNumber != null) 'line_number': lineNumber,
      if (description != null) 'description': description,
      if (hsnSac != null) 'hsn_sac': hsnSac,
      if (taxRateBps != null) 'tax_rate_bps': taxRateBps,
      if (taxableMinor != null) 'taxable_minor': taxableMinor,
      if (cgstMinor != null) 'cgst_minor': cgstMinor,
      if (sgstMinor != null) 'sgst_minor': sgstMinor,
      if (igstMinor != null) 'igst_minor': igstMinor,
      if (cessMinor != null) 'cess_minor': cessMinor,
      if (totalMinor != null) 'total_minor': totalMinor,
    });
  }

  InvoiceLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<int>? lineNumber,
    Value<String>? description,
    Value<String?>? hsnSac,
    Value<int>? taxRateBps,
    Value<int>? taxableMinor,
    Value<int>? cgstMinor,
    Value<int>? sgstMinor,
    Value<int>? igstMinor,
    Value<int>? cessMinor,
    Value<int>? totalMinor,
  }) {
    return InvoiceLinesCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      lineNumber: lineNumber ?? this.lineNumber,
      description: description ?? this.description,
      hsnSac: hsnSac ?? this.hsnSac,
      taxRateBps: taxRateBps ?? this.taxRateBps,
      taxableMinor: taxableMinor ?? this.taxableMinor,
      cgstMinor: cgstMinor ?? this.cgstMinor,
      sgstMinor: sgstMinor ?? this.sgstMinor,
      igstMinor: igstMinor ?? this.igstMinor,
      cessMinor: cessMinor ?? this.cessMinor,
      totalMinor: totalMinor ?? this.totalMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (lineNumber.present) {
      map['line_number'] = Variable<int>(lineNumber.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (hsnSac.present) {
      map['hsn_sac'] = Variable<String>(hsnSac.value);
    }
    if (taxRateBps.present) {
      map['tax_rate_bps'] = Variable<int>(taxRateBps.value);
    }
    if (taxableMinor.present) {
      map['taxable_minor'] = Variable<int>(taxableMinor.value);
    }
    if (cgstMinor.present) {
      map['cgst_minor'] = Variable<int>(cgstMinor.value);
    }
    if (sgstMinor.present) {
      map['sgst_minor'] = Variable<int>(sgstMinor.value);
    }
    if (igstMinor.present) {
      map['igst_minor'] = Variable<int>(igstMinor.value);
    }
    if (cessMinor.present) {
      map['cess_minor'] = Variable<int>(cessMinor.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLinesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('description: $description, ')
          ..write('hsnSac: $hsnSac, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('taxableMinor: $taxableMinor, ')
          ..write('cgstMinor: $cgstMinor, ')
          ..write('sgstMinor: $sgstMinor, ')
          ..write('igstMinor: $igstMinor, ')
          ..write('cessMinor: $cessMinor, ')
          ..write('totalMinor: $totalMinor')
          ..write(')'))
        .toString();
  }
}

class $SourceEventsTable extends SourceEvents
    with TableInfo<$SourceEventsTable, SourceEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAccountIdMeta = const VerificationMeta(
    'sourceAccountId',
  );
  @override
  late final GeneratedColumn<int> sourceAccountId = GeneratedColumn<int>(
    'source_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importJobIdMeta = const VerificationMeta(
    'importJobId',
  );
  @override
  late final GeneratedColumn<int> importJobId = GeneratedColumn<int>(
    'import_job_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_jobs (id)',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _encryptedEvidenceRefMeta =
      const VerificationMeta('encryptedEvidenceRef');
  @override
  late final GeneratedColumn<String> encryptedEvidenceRef =
      GeneratedColumn<String>(
        'encrypted_evidence_ref',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    sourceAccountId,
    externalId,
    contentHash,
    receivedAt,
    importJobId,
    transactionId,
    encryptedEvidenceRef,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
        _sourceAccountIdMeta,
        sourceAccountId.isAcceptableOrUnknown(
          data['source_account_id']!,
          _sourceAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAccountIdMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('import_job_id')) {
      context.handle(
        _importJobIdMeta,
        importJobId.isAcceptableOrUnknown(
          data['import_job_id']!,
          _importJobIdMeta,
        ),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('encrypted_evidence_ref')) {
      context.handle(
        _encryptedEvidenceRefMeta,
        encryptedEvidenceRef.isAcceptableOrUnknown(
          data['encrypted_evidence_ref']!,
          _encryptedEvidenceRefMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {source, sourceAccountId, externalId},
  ];
  @override
  SourceEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_account_id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      importJobId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_job_id'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      encryptedEvidenceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_evidence_ref'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $SourceEventsTable createAlias(String alias) {
    return $SourceEventsTable(attachedDatabase, alias);
  }
}

class SourceEvent extends DataClass implements Insertable<SourceEvent> {
  final int id;
  final String source;
  final int sourceAccountId;
  final String externalId;
  final String contentHash;
  final DateTime receivedAt;
  final int? importJobId;
  final int? transactionId;
  final String? encryptedEvidenceRef;
  final String payloadJson;
  const SourceEvent({
    required this.id,
    required this.source,
    required this.sourceAccountId,
    required this.externalId,
    required this.contentHash,
    required this.receivedAt,
    this.importJobId,
    this.transactionId,
    this.encryptedEvidenceRef,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source'] = Variable<String>(source);
    map['source_account_id'] = Variable<int>(sourceAccountId);
    map['external_id'] = Variable<String>(externalId);
    map['content_hash'] = Variable<String>(contentHash);
    map['received_at'] = Variable<DateTime>(receivedAt);
    if (!nullToAbsent || importJobId != null) {
      map['import_job_id'] = Variable<int>(importJobId);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    if (!nullToAbsent || encryptedEvidenceRef != null) {
      map['encrypted_evidence_ref'] = Variable<String>(encryptedEvidenceRef);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  SourceEventsCompanion toCompanion(bool nullToAbsent) {
    return SourceEventsCompanion(
      id: Value(id),
      source: Value(source),
      sourceAccountId: Value(sourceAccountId),
      externalId: Value(externalId),
      contentHash: Value(contentHash),
      receivedAt: Value(receivedAt),
      importJobId: importJobId == null && nullToAbsent
          ? const Value.absent()
          : Value(importJobId),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      encryptedEvidenceRef: encryptedEvidenceRef == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedEvidenceRef),
      payloadJson: Value(payloadJson),
    );
  }

  factory SourceEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceEvent(
      id: serializer.fromJson<int>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      sourceAccountId: serializer.fromJson<int>(json['sourceAccountId']),
      externalId: serializer.fromJson<String>(json['externalId']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      importJobId: serializer.fromJson<int?>(json['importJobId']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      encryptedEvidenceRef: serializer.fromJson<String?>(
        json['encryptedEvidenceRef'],
      ),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<String>(source),
      'sourceAccountId': serializer.toJson<int>(sourceAccountId),
      'externalId': serializer.toJson<String>(externalId),
      'contentHash': serializer.toJson<String>(contentHash),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'importJobId': serializer.toJson<int?>(importJobId),
      'transactionId': serializer.toJson<int?>(transactionId),
      'encryptedEvidenceRef': serializer.toJson<String?>(encryptedEvidenceRef),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  SourceEvent copyWith({
    int? id,
    String? source,
    int? sourceAccountId,
    String? externalId,
    String? contentHash,
    DateTime? receivedAt,
    Value<int?> importJobId = const Value.absent(),
    Value<int?> transactionId = const Value.absent(),
    Value<String?> encryptedEvidenceRef = const Value.absent(),
    String? payloadJson,
  }) => SourceEvent(
    id: id ?? this.id,
    source: source ?? this.source,
    sourceAccountId: sourceAccountId ?? this.sourceAccountId,
    externalId: externalId ?? this.externalId,
    contentHash: contentHash ?? this.contentHash,
    receivedAt: receivedAt ?? this.receivedAt,
    importJobId: importJobId.present ? importJobId.value : this.importJobId,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    encryptedEvidenceRef: encryptedEvidenceRef.present
        ? encryptedEvidenceRef.value
        : this.encryptedEvidenceRef,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  SourceEvent copyWithCompanion(SourceEventsCompanion data) {
    return SourceEvent(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      importJobId: data.importJobId.present
          ? data.importJobId.value
          : this.importJobId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      encryptedEvidenceRef: data.encryptedEvidenceRef.present
          ? data.encryptedEvidenceRef.value
          : this.encryptedEvidenceRef,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceEvent(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('externalId: $externalId, ')
          ..write('contentHash: $contentHash, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('importJobId: $importJobId, ')
          ..write('transactionId: $transactionId, ')
          ..write('encryptedEvidenceRef: $encryptedEvidenceRef, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    sourceAccountId,
    externalId,
    contentHash,
    receivedAt,
    importJobId,
    transactionId,
    encryptedEvidenceRef,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceEvent &&
          other.id == this.id &&
          other.source == this.source &&
          other.sourceAccountId == this.sourceAccountId &&
          other.externalId == this.externalId &&
          other.contentHash == this.contentHash &&
          other.receivedAt == this.receivedAt &&
          other.importJobId == this.importJobId &&
          other.transactionId == this.transactionId &&
          other.encryptedEvidenceRef == this.encryptedEvidenceRef &&
          other.payloadJson == this.payloadJson);
}

class SourceEventsCompanion extends UpdateCompanion<SourceEvent> {
  final Value<int> id;
  final Value<String> source;
  final Value<int> sourceAccountId;
  final Value<String> externalId;
  final Value<String> contentHash;
  final Value<DateTime> receivedAt;
  final Value<int?> importJobId;
  final Value<int?> transactionId;
  final Value<String?> encryptedEvidenceRef;
  final Value<String> payloadJson;
  const SourceEventsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.importJobId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.encryptedEvidenceRef = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  SourceEventsCompanion.insert({
    this.id = const Value.absent(),
    required String source,
    required int sourceAccountId,
    required String externalId,
    required String contentHash,
    required DateTime receivedAt,
    this.importJobId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.encryptedEvidenceRef = const Value.absent(),
    required String payloadJson,
  }) : source = Value(source),
       sourceAccountId = Value(sourceAccountId),
       externalId = Value(externalId),
       contentHash = Value(contentHash),
       receivedAt = Value(receivedAt),
       payloadJson = Value(payloadJson);
  static Insertable<SourceEvent> custom({
    Expression<int>? id,
    Expression<String>? source,
    Expression<int>? sourceAccountId,
    Expression<String>? externalId,
    Expression<String>? contentHash,
    Expression<DateTime>? receivedAt,
    Expression<int>? importJobId,
    Expression<int>? transactionId,
    Expression<String>? encryptedEvidenceRef,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (externalId != null) 'external_id': externalId,
      if (contentHash != null) 'content_hash': contentHash,
      if (receivedAt != null) 'received_at': receivedAt,
      if (importJobId != null) 'import_job_id': importJobId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (encryptedEvidenceRef != null)
        'encrypted_evidence_ref': encryptedEvidenceRef,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  SourceEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? source,
    Value<int>? sourceAccountId,
    Value<String>? externalId,
    Value<String>? contentHash,
    Value<DateTime>? receivedAt,
    Value<int?>? importJobId,
    Value<int?>? transactionId,
    Value<String?>? encryptedEvidenceRef,
    Value<String>? payloadJson,
  }) {
    return SourceEventsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      externalId: externalId ?? this.externalId,
      contentHash: contentHash ?? this.contentHash,
      receivedAt: receivedAt ?? this.receivedAt,
      importJobId: importJobId ?? this.importJobId,
      transactionId: transactionId ?? this.transactionId,
      encryptedEvidenceRef: encryptedEvidenceRef ?? this.encryptedEvidenceRef,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<int>(sourceAccountId.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (importJobId.present) {
      map['import_job_id'] = Variable<int>(importJobId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (encryptedEvidenceRef.present) {
      map['encrypted_evidence_ref'] = Variable<String>(
        encryptedEvidenceRef.value,
      );
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceEventsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('externalId: $externalId, ')
          ..write('contentHash: $contentHash, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('importJobId: $importJobId, ')
          ..write('transactionId: $transactionId, ')
          ..write('encryptedEvidenceRef: $encryptedEvidenceRef, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $ClassificationsTable extends Classifications
    with TableInfo<$ClassificationsTable, Classification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES transactions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _suggestedCategoryIdMeta =
      const VerificationMeta('suggestedCategoryId');
  @override
  late final GeneratedColumn<int> suggestedCategoryId = GeneratedColumn<int>(
    'suggested_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _confirmedCategoryIdMeta =
      const VerificationMeta('confirmedCategoryId');
  @override
  late final GeneratedColumn<int> confirmedCategoryId = GeneratedColumn<int>(
    'confirmed_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _businessUseBpsMeta = const VerificationMeta(
    'businessUseBps',
  );
  @override
  late final GeneratedColumn<int> businessUseBps = GeneratedColumn<int>(
    'business_use_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessPurposeMeta = const VerificationMeta(
    'businessPurpose',
  );
  @override
  late final GeneratedColumn<String> businessPurpose = GeneratedColumn<String>(
    'business_purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstEligibilityStatusMeta =
      const VerificationMeta('gstEligibilityStatus');
  @override
  late final GeneratedColumn<String> gstEligibilityStatus =
      GeneratedColumn<String>(
        'gst_eligibility_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('not_assessed'),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    suggestedCategoryId,
    confirmedCategoryId,
    businessUseBps,
    businessPurpose,
    provenance,
    gstEligibilityStatus,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Classification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('suggested_category_id')) {
      context.handle(
        _suggestedCategoryIdMeta,
        suggestedCategoryId.isAcceptableOrUnknown(
          data['suggested_category_id']!,
          _suggestedCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('confirmed_category_id')) {
      context.handle(
        _confirmedCategoryIdMeta,
        confirmedCategoryId.isAcceptableOrUnknown(
          data['confirmed_category_id']!,
          _confirmedCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('business_use_bps')) {
      context.handle(
        _businessUseBpsMeta,
        businessUseBps.isAcceptableOrUnknown(
          data['business_use_bps']!,
          _businessUseBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessUseBpsMeta);
    }
    if (data.containsKey('business_purpose')) {
      context.handle(
        _businessPurposeMeta,
        businessPurpose.isAcceptableOrUnknown(
          data['business_purpose']!,
          _businessPurposeMeta,
        ),
      );
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    } else if (isInserting) {
      context.missing(_provenanceMeta);
    }
    if (data.containsKey('gst_eligibility_status')) {
      context.handle(
        _gstEligibilityStatusMeta,
        gstEligibilityStatus.isAcceptableOrUnknown(
          data['gst_eligibility_status']!,
          _gstEligibilityStatusMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Classification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Classification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      suggestedCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}suggested_category_id'],
      ),
      confirmedCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confirmed_category_id'],
      ),
      businessUseBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_use_bps'],
      )!,
      businessPurpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_purpose'],
      ),
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
      gstEligibilityStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_eligibility_status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClassificationsTable createAlias(String alias) {
    return $ClassificationsTable(attachedDatabase, alias);
  }
}

class Classification extends DataClass implements Insertable<Classification> {
  final int id;
  final int transactionId;
  final int? suggestedCategoryId;
  final int? confirmedCategoryId;
  final int businessUseBps;
  final String? businessPurpose;
  final String provenance;
  final String gstEligibilityStatus;
  final DateTime updatedAt;
  const Classification({
    required this.id,
    required this.transactionId,
    this.suggestedCategoryId,
    this.confirmedCategoryId,
    required this.businessUseBps,
    this.businessPurpose,
    required this.provenance,
    required this.gstEligibilityStatus,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    if (!nullToAbsent || suggestedCategoryId != null) {
      map['suggested_category_id'] = Variable<int>(suggestedCategoryId);
    }
    if (!nullToAbsent || confirmedCategoryId != null) {
      map['confirmed_category_id'] = Variable<int>(confirmedCategoryId);
    }
    map['business_use_bps'] = Variable<int>(businessUseBps);
    if (!nullToAbsent || businessPurpose != null) {
      map['business_purpose'] = Variable<String>(businessPurpose);
    }
    map['provenance'] = Variable<String>(provenance);
    map['gst_eligibility_status'] = Variable<String>(gstEligibilityStatus);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClassificationsCompanion toCompanion(bool nullToAbsent) {
    return ClassificationsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      suggestedCategoryId: suggestedCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedCategoryId),
      confirmedCategoryId: confirmedCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedCategoryId),
      businessUseBps: Value(businessUseBps),
      businessPurpose: businessPurpose == null && nullToAbsent
          ? const Value.absent()
          : Value(businessPurpose),
      provenance: Value(provenance),
      gstEligibilityStatus: Value(gstEligibilityStatus),
      updatedAt: Value(updatedAt),
    );
  }

  factory Classification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Classification(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      suggestedCategoryId: serializer.fromJson<int?>(
        json['suggestedCategoryId'],
      ),
      confirmedCategoryId: serializer.fromJson<int?>(
        json['confirmedCategoryId'],
      ),
      businessUseBps: serializer.fromJson<int>(json['businessUseBps']),
      businessPurpose: serializer.fromJson<String?>(json['businessPurpose']),
      provenance: serializer.fromJson<String>(json['provenance']),
      gstEligibilityStatus: serializer.fromJson<String>(
        json['gstEligibilityStatus'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'suggestedCategoryId': serializer.toJson<int?>(suggestedCategoryId),
      'confirmedCategoryId': serializer.toJson<int?>(confirmedCategoryId),
      'businessUseBps': serializer.toJson<int>(businessUseBps),
      'businessPurpose': serializer.toJson<String?>(businessPurpose),
      'provenance': serializer.toJson<String>(provenance),
      'gstEligibilityStatus': serializer.toJson<String>(gstEligibilityStatus),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Classification copyWith({
    int? id,
    int? transactionId,
    Value<int?> suggestedCategoryId = const Value.absent(),
    Value<int?> confirmedCategoryId = const Value.absent(),
    int? businessUseBps,
    Value<String?> businessPurpose = const Value.absent(),
    String? provenance,
    String? gstEligibilityStatus,
    DateTime? updatedAt,
  }) => Classification(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    suggestedCategoryId: suggestedCategoryId.present
        ? suggestedCategoryId.value
        : this.suggestedCategoryId,
    confirmedCategoryId: confirmedCategoryId.present
        ? confirmedCategoryId.value
        : this.confirmedCategoryId,
    businessUseBps: businessUseBps ?? this.businessUseBps,
    businessPurpose: businessPurpose.present
        ? businessPurpose.value
        : this.businessPurpose,
    provenance: provenance ?? this.provenance,
    gstEligibilityStatus: gstEligibilityStatus ?? this.gstEligibilityStatus,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Classification copyWithCompanion(ClassificationsCompanion data) {
    return Classification(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      suggestedCategoryId: data.suggestedCategoryId.present
          ? data.suggestedCategoryId.value
          : this.suggestedCategoryId,
      confirmedCategoryId: data.confirmedCategoryId.present
          ? data.confirmedCategoryId.value
          : this.confirmedCategoryId,
      businessUseBps: data.businessUseBps.present
          ? data.businessUseBps.value
          : this.businessUseBps,
      businessPurpose: data.businessPurpose.present
          ? data.businessPurpose.value
          : this.businessPurpose,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
      gstEligibilityStatus: data.gstEligibilityStatus.present
          ? data.gstEligibilityStatus.value
          : this.gstEligibilityStatus,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Classification(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('suggestedCategoryId: $suggestedCategoryId, ')
          ..write('confirmedCategoryId: $confirmedCategoryId, ')
          ..write('businessUseBps: $businessUseBps, ')
          ..write('businessPurpose: $businessPurpose, ')
          ..write('provenance: $provenance, ')
          ..write('gstEligibilityStatus: $gstEligibilityStatus, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    suggestedCategoryId,
    confirmedCategoryId,
    businessUseBps,
    businessPurpose,
    provenance,
    gstEligibilityStatus,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Classification &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.suggestedCategoryId == this.suggestedCategoryId &&
          other.confirmedCategoryId == this.confirmedCategoryId &&
          other.businessUseBps == this.businessUseBps &&
          other.businessPurpose == this.businessPurpose &&
          other.provenance == this.provenance &&
          other.gstEligibilityStatus == this.gstEligibilityStatus &&
          other.updatedAt == this.updatedAt);
}

class ClassificationsCompanion extends UpdateCompanion<Classification> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int?> suggestedCategoryId;
  final Value<int?> confirmedCategoryId;
  final Value<int> businessUseBps;
  final Value<String?> businessPurpose;
  final Value<String> provenance;
  final Value<String> gstEligibilityStatus;
  final Value<DateTime> updatedAt;
  const ClassificationsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.suggestedCategoryId = const Value.absent(),
    this.confirmedCategoryId = const Value.absent(),
    this.businessUseBps = const Value.absent(),
    this.businessPurpose = const Value.absent(),
    this.provenance = const Value.absent(),
    this.gstEligibilityStatus = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ClassificationsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    this.suggestedCategoryId = const Value.absent(),
    this.confirmedCategoryId = const Value.absent(),
    required int businessUseBps,
    this.businessPurpose = const Value.absent(),
    required String provenance,
    this.gstEligibilityStatus = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : transactionId = Value(transactionId),
       businessUseBps = Value(businessUseBps),
       provenance = Value(provenance);
  static Insertable<Classification> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? suggestedCategoryId,
    Expression<int>? confirmedCategoryId,
    Expression<int>? businessUseBps,
    Expression<String>? businessPurpose,
    Expression<String>? provenance,
    Expression<String>? gstEligibilityStatus,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (suggestedCategoryId != null)
        'suggested_category_id': suggestedCategoryId,
      if (confirmedCategoryId != null)
        'confirmed_category_id': confirmedCategoryId,
      if (businessUseBps != null) 'business_use_bps': businessUseBps,
      if (businessPurpose != null) 'business_purpose': businessPurpose,
      if (provenance != null) 'provenance': provenance,
      if (gstEligibilityStatus != null)
        'gst_eligibility_status': gstEligibilityStatus,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ClassificationsCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<int?>? suggestedCategoryId,
    Value<int?>? confirmedCategoryId,
    Value<int>? businessUseBps,
    Value<String?>? businessPurpose,
    Value<String>? provenance,
    Value<String>? gstEligibilityStatus,
    Value<DateTime>? updatedAt,
  }) {
    return ClassificationsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      suggestedCategoryId: suggestedCategoryId ?? this.suggestedCategoryId,
      confirmedCategoryId: confirmedCategoryId ?? this.confirmedCategoryId,
      businessUseBps: businessUseBps ?? this.businessUseBps,
      businessPurpose: businessPurpose ?? this.businessPurpose,
      provenance: provenance ?? this.provenance,
      gstEligibilityStatus: gstEligibilityStatus ?? this.gstEligibilityStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (suggestedCategoryId.present) {
      map['suggested_category_id'] = Variable<int>(suggestedCategoryId.value);
    }
    if (confirmedCategoryId.present) {
      map['confirmed_category_id'] = Variable<int>(confirmedCategoryId.value);
    }
    if (businessUseBps.present) {
      map['business_use_bps'] = Variable<int>(businessUseBps.value);
    }
    if (businessPurpose.present) {
      map['business_purpose'] = Variable<String>(businessPurpose.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (gstEligibilityStatus.present) {
      map['gst_eligibility_status'] = Variable<String>(
        gstEligibilityStatus.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('suggestedCategoryId: $suggestedCategoryId, ')
          ..write('confirmedCategoryId: $confirmedCategoryId, ')
          ..write('businessUseBps: $businessUseBps, ')
          ..write('businessPurpose: $businessPurpose, ')
          ..write('provenance: $provenance, ')
          ..write('gstEligibilityStatus: $gstEligibilityStatus, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BusinessRulesTable extends BusinessRules
    with TableInfo<$BusinessRulesTable, BusinessRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _merchantPatternMeta = const VerificationMeta(
    'merchantPattern',
  );
  @override
  late final GeneratedColumn<String> merchantPattern = GeneratedColumn<String>(
    'merchant_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _businessUseBpsMeta = const VerificationMeta(
    'businessUseBps',
  );
  @override
  late final GeneratedColumn<int> businessUseBps = GeneratedColumn<int>(
    'business_use_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    merchantPattern,
    businessUseBps,
    provenance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('merchant_pattern')) {
      context.handle(
        _merchantPatternMeta,
        merchantPattern.isAcceptableOrUnknown(
          data['merchant_pattern']!,
          _merchantPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantPatternMeta);
    }
    if (data.containsKey('business_use_bps')) {
      context.handle(
        _businessUseBpsMeta,
        businessUseBps.isAcceptableOrUnknown(
          data['business_use_bps']!,
          _businessUseBpsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessUseBpsMeta);
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      merchantPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_pattern'],
      )!,
      businessUseBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}business_use_bps'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BusinessRulesTable createAlias(String alias) {
    return $BusinessRulesTable(attachedDatabase, alias);
  }
}

class BusinessRule extends DataClass implements Insertable<BusinessRule> {
  final int id;
  final String merchantPattern;
  final int businessUseBps;
  final String provenance;
  final DateTime createdAt;
  const BusinessRule({
    required this.id,
    required this.merchantPattern,
    required this.businessUseBps,
    required this.provenance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['merchant_pattern'] = Variable<String>(merchantPattern);
    map['business_use_bps'] = Variable<int>(businessUseBps);
    map['provenance'] = Variable<String>(provenance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BusinessRulesCompanion toCompanion(bool nullToAbsent) {
    return BusinessRulesCompanion(
      id: Value(id),
      merchantPattern: Value(merchantPattern),
      businessUseBps: Value(businessUseBps),
      provenance: Value(provenance),
      createdAt: Value(createdAt),
    );
  }

  factory BusinessRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessRule(
      id: serializer.fromJson<int>(json['id']),
      merchantPattern: serializer.fromJson<String>(json['merchantPattern']),
      businessUseBps: serializer.fromJson<int>(json['businessUseBps']),
      provenance: serializer.fromJson<String>(json['provenance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'merchantPattern': serializer.toJson<String>(merchantPattern),
      'businessUseBps': serializer.toJson<int>(businessUseBps),
      'provenance': serializer.toJson<String>(provenance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BusinessRule copyWith({
    int? id,
    String? merchantPattern,
    int? businessUseBps,
    String? provenance,
    DateTime? createdAt,
  }) => BusinessRule(
    id: id ?? this.id,
    merchantPattern: merchantPattern ?? this.merchantPattern,
    businessUseBps: businessUseBps ?? this.businessUseBps,
    provenance: provenance ?? this.provenance,
    createdAt: createdAt ?? this.createdAt,
  );
  BusinessRule copyWithCompanion(BusinessRulesCompanion data) {
    return BusinessRule(
      id: data.id.present ? data.id.value : this.id,
      merchantPattern: data.merchantPattern.present
          ? data.merchantPattern.value
          : this.merchantPattern,
      businessUseBps: data.businessUseBps.present
          ? data.businessUseBps.value
          : this.businessUseBps,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessRule(')
          ..write('id: $id, ')
          ..write('merchantPattern: $merchantPattern, ')
          ..write('businessUseBps: $businessUseBps, ')
          ..write('provenance: $provenance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, merchantPattern, businessUseBps, provenance, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessRule &&
          other.id == this.id &&
          other.merchantPattern == this.merchantPattern &&
          other.businessUseBps == this.businessUseBps &&
          other.provenance == this.provenance &&
          other.createdAt == this.createdAt);
}

class BusinessRulesCompanion extends UpdateCompanion<BusinessRule> {
  final Value<int> id;
  final Value<String> merchantPattern;
  final Value<int> businessUseBps;
  final Value<String> provenance;
  final Value<DateTime> createdAt;
  const BusinessRulesCompanion({
    this.id = const Value.absent(),
    this.merchantPattern = const Value.absent(),
    this.businessUseBps = const Value.absent(),
    this.provenance = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BusinessRulesCompanion.insert({
    this.id = const Value.absent(),
    required String merchantPattern,
    required int businessUseBps,
    this.provenance = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : merchantPattern = Value(merchantPattern),
       businessUseBps = Value(businessUseBps);
  static Insertable<BusinessRule> custom({
    Expression<int>? id,
    Expression<String>? merchantPattern,
    Expression<int>? businessUseBps,
    Expression<String>? provenance,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (merchantPattern != null) 'merchant_pattern': merchantPattern,
      if (businessUseBps != null) 'business_use_bps': businessUseBps,
      if (provenance != null) 'provenance': provenance,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BusinessRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? merchantPattern,
    Value<int>? businessUseBps,
    Value<String>? provenance,
    Value<DateTime>? createdAt,
  }) {
    return BusinessRulesCompanion(
      id: id ?? this.id,
      merchantPattern: merchantPattern ?? this.merchantPattern,
      businessUseBps: businessUseBps ?? this.businessUseBps,
      provenance: provenance ?? this.provenance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (merchantPattern.present) {
      map['merchant_pattern'] = Variable<String>(merchantPattern.value);
    }
    if (businessUseBps.present) {
      map['business_use_bps'] = Variable<int>(businessUseBps.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessRulesCompanion(')
          ..write('id: $id, ')
          ..write('merchantPattern: $merchantPattern, ')
          ..write('businessUseBps: $businessUseBps, ')
          ..write('provenance: $provenance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentAllocationsTable extends PaymentAllocations
    with TableInfo<$PaymentAllocationsTable, PaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allocatedMinorMeta = const VerificationMeta(
    'allocatedMinor',
  );
  @override
  late final GeneratedColumn<int> allocatedMinor = GeneratedColumn<int>(
    'allocated_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    invoiceId,
    kind,
    allocatedMinor,
    currency,
    provenance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('allocated_minor')) {
      context.handle(
        _allocatedMinorMeta,
        allocatedMinor.isAcceptableOrUnknown(
          data['allocated_minor']!,
          _allocatedMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocatedMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {transactionId, invoiceId, kind},
  ];
  @override
  PaymentAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      allocatedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocated_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentAllocationsTable createAlias(String alias) {
    return $PaymentAllocationsTable(attachedDatabase, alias);
  }
}

class PaymentAllocation extends DataClass
    implements Insertable<PaymentAllocation> {
  final int id;
  final int transactionId;
  final int invoiceId;
  final String kind;
  final int allocatedMinor;
  final String currency;
  final String provenance;
  final DateTime createdAt;
  const PaymentAllocation({
    required this.id,
    required this.transactionId,
    required this.invoiceId,
    required this.kind,
    required this.allocatedMinor,
    required this.currency,
    required this.provenance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['kind'] = Variable<String>(kind);
    map['allocated_minor'] = Variable<int>(allocatedMinor);
    map['currency'] = Variable<String>(currency);
    map['provenance'] = Variable<String>(provenance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAllocationsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      invoiceId: Value(invoiceId),
      kind: Value(kind),
      allocatedMinor: Value(allocatedMinor),
      currency: Value(currency),
      provenance: Value(provenance),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAllocation(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      kind: serializer.fromJson<String>(json['kind']),
      allocatedMinor: serializer.fromJson<int>(json['allocatedMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      provenance: serializer.fromJson<String>(json['provenance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'kind': serializer.toJson<String>(kind),
      'allocatedMinor': serializer.toJson<int>(allocatedMinor),
      'currency': serializer.toJson<String>(currency),
      'provenance': serializer.toJson<String>(provenance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentAllocation copyWith({
    int? id,
    int? transactionId,
    int? invoiceId,
    String? kind,
    int? allocatedMinor,
    String? currency,
    String? provenance,
    DateTime? createdAt,
  }) => PaymentAllocation(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    invoiceId: invoiceId ?? this.invoiceId,
    kind: kind ?? this.kind,
    allocatedMinor: allocatedMinor ?? this.allocatedMinor,
    currency: currency ?? this.currency,
    provenance: provenance ?? this.provenance,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentAllocation copyWithCompanion(PaymentAllocationsCompanion data) {
    return PaymentAllocation(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      kind: data.kind.present ? data.kind.value : this.kind,
      allocatedMinor: data.allocatedMinor.present
          ? data.allocatedMinor.value
          : this.allocatedMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocation(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('kind: $kind, ')
          ..write('allocatedMinor: $allocatedMinor, ')
          ..write('currency: $currency, ')
          ..write('provenance: $provenance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    invoiceId,
    kind,
    allocatedMinor,
    currency,
    provenance,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAllocation &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.invoiceId == this.invoiceId &&
          other.kind == this.kind &&
          other.allocatedMinor == this.allocatedMinor &&
          other.currency == this.currency &&
          other.provenance == this.provenance &&
          other.createdAt == this.createdAt);
}

class PaymentAllocationsCompanion extends UpdateCompanion<PaymentAllocation> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> invoiceId;
  final Value<String> kind;
  final Value<int> allocatedMinor;
  final Value<String> currency;
  final Value<String> provenance;
  final Value<DateTime> createdAt;
  const PaymentAllocationsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.kind = const Value.absent(),
    this.allocatedMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.provenance = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int invoiceId,
    required String kind,
    required int allocatedMinor,
    this.currency = const Value.absent(),
    this.provenance = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : transactionId = Value(transactionId),
       invoiceId = Value(invoiceId),
       kind = Value(kind),
       allocatedMinor = Value(allocatedMinor);
  static Insertable<PaymentAllocation> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? invoiceId,
    Expression<String>? kind,
    Expression<int>? allocatedMinor,
    Expression<String>? currency,
    Expression<String>? provenance,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (kind != null) 'kind': kind,
      if (allocatedMinor != null) 'allocated_minor': allocatedMinor,
      if (currency != null) 'currency': currency,
      if (provenance != null) 'provenance': provenance,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentAllocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<int>? invoiceId,
    Value<String>? kind,
    Value<int>? allocatedMinor,
    Value<String>? currency,
    Value<String>? provenance,
    Value<DateTime>? createdAt,
  }) {
    return PaymentAllocationsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      invoiceId: invoiceId ?? this.invoiceId,
      kind: kind ?? this.kind,
      allocatedMinor: allocatedMinor ?? this.allocatedMinor,
      currency: currency ?? this.currency,
      provenance: provenance ?? this.provenance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (allocatedMinor.present) {
      map['allocated_minor'] = Variable<int>(allocatedMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('kind: $kind, ')
          ..write('allocatedMinor: $allocatedMinor, ')
          ..write('currency: $currency, ')
          ..write('provenance: $provenance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewEventsTable extends ReviewEvents
    with TableInfo<$ReviewEventsTable, ReviewEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beforeJsonMeta = const VerificationMeta(
    'beforeJson',
  );
  @override
  late final GeneratedColumn<String> beforeJson = GeneratedColumn<String>(
    'before_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _afterJsonMeta = const VerificationMeta(
    'afterJson',
  );
  @override
  late final GeneratedColumn<String> afterJson = GeneratedColumn<String>(
    'after_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    action,
    beforeJson,
    afterJson,
    provenance,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('before_json')) {
      context.handle(
        _beforeJsonMeta,
        beforeJson.isAcceptableOrUnknown(data['before_json']!, _beforeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_beforeJsonMeta);
    }
    if (data.containsKey('after_json')) {
      context.handle(
        _afterJsonMeta,
        afterJson.isAcceptableOrUnknown(data['after_json']!, _afterJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_afterJsonMeta);
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      beforeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}before_json'],
      )!,
      afterJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}after_json'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ReviewEventsTable createAlias(String alias) {
    return $ReviewEventsTable(attachedDatabase, alias);
  }
}

class ReviewEvent extends DataClass implements Insertable<ReviewEvent> {
  final int id;
  final String entityType;
  final int entityId;
  final String action;
  final String beforeJson;
  final String afterJson;
  final String provenance;
  final DateTime timestamp;
  const ReviewEvent({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.beforeJson,
    required this.afterJson,
    required this.provenance,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['action'] = Variable<String>(action);
    map['before_json'] = Variable<String>(beforeJson);
    map['after_json'] = Variable<String>(afterJson);
    map['provenance'] = Variable<String>(provenance);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ReviewEventsCompanion toCompanion(bool nullToAbsent) {
    return ReviewEventsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      beforeJson: Value(beforeJson),
      afterJson: Value(afterJson),
      provenance: Value(provenance),
      timestamp: Value(timestamp),
    );
  }

  factory ReviewEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewEvent(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      beforeJson: serializer.fromJson<String>(json['beforeJson']),
      afterJson: serializer.fromJson<String>(json['afterJson']),
      provenance: serializer.fromJson<String>(json['provenance']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'action': serializer.toJson<String>(action),
      'beforeJson': serializer.toJson<String>(beforeJson),
      'afterJson': serializer.toJson<String>(afterJson),
      'provenance': serializer.toJson<String>(provenance),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ReviewEvent copyWith({
    int? id,
    String? entityType,
    int? entityId,
    String? action,
    String? beforeJson,
    String? afterJson,
    String? provenance,
    DateTime? timestamp,
  }) => ReviewEvent(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    beforeJson: beforeJson ?? this.beforeJson,
    afterJson: afterJson ?? this.afterJson,
    provenance: provenance ?? this.provenance,
    timestamp: timestamp ?? this.timestamp,
  );
  ReviewEvent copyWithCompanion(ReviewEventsCompanion data) {
    return ReviewEvent(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      beforeJson: data.beforeJson.present
          ? data.beforeJson.value
          : this.beforeJson,
      afterJson: data.afterJson.present ? data.afterJson.value : this.afterJson,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEvent(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('provenance: $provenance, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    action,
    beforeJson,
    afterJson,
    provenance,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewEvent &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.beforeJson == this.beforeJson &&
          other.afterJson == this.afterJson &&
          other.provenance == this.provenance &&
          other.timestamp == this.timestamp);
}

class ReviewEventsCompanion extends UpdateCompanion<ReviewEvent> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> action;
  final Value<String> beforeJson;
  final Value<String> afterJson;
  final Value<String> provenance;
  final Value<DateTime> timestamp;
  const ReviewEventsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.beforeJson = const Value.absent(),
    this.afterJson = const Value.absent(),
    this.provenance = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ReviewEventsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int entityId,
    required String action,
    required String beforeJson,
    required String afterJson,
    this.provenance = const Value.absent(),
    this.timestamp = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       action = Value(action),
       beforeJson = Value(beforeJson),
       afterJson = Value(afterJson);
  static Insertable<ReviewEvent> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? action,
    Expression<String>? beforeJson,
    Expression<String>? afterJson,
    Expression<String>? provenance,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (beforeJson != null) 'before_json': beforeJson,
      if (afterJson != null) 'after_json': afterJson,
      if (provenance != null) 'provenance': provenance,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ReviewEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String>? action,
    Value<String>? beforeJson,
    Value<String>? afterJson,
    Value<String>? provenance,
    Value<DateTime>? timestamp,
  }) {
    return ReviewEventsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      beforeJson: beforeJson ?? this.beforeJson,
      afterJson: afterJson ?? this.afterJson,
      provenance: provenance ?? this.provenance,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (beforeJson.present) {
      map['before_json'] = Variable<String>(beforeJson.value);
    }
    if (afterJson.present) {
      map['after_json'] = Variable<String>(afterJson.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('provenance: $provenance, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $ExportRunsTable extends ExportRuns
    with TableInfo<$ExportRunsTable, ExportRun> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExportRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatVersionMeta = const VerificationMeta(
    'formatVersion',
  );
  @override
  late final GeneratedColumn<int> formatVersion = GeneratedColumn<int>(
    'format_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _includedCountMeta = const VerificationMeta(
    'includedCount',
  );
  @override
  late final GeneratedColumn<int> includedCount = GeneratedColumn<int>(
    'included_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manifestSha256Meta = const VerificationMeta(
    'manifestSha256',
  );
  @override
  late final GeneratedColumn<String> manifestSha256 = GeneratedColumn<String>(
    'manifest_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    periodStart,
    periodEnd,
    formatVersion,
    includedCount,
    manifestSha256,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'export_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExportRun> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('format_version')) {
      context.handle(
        _formatVersionMeta,
        formatVersion.isAcceptableOrUnknown(
          data['format_version']!,
          _formatVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_formatVersionMeta);
    }
    if (data.containsKey('included_count')) {
      context.handle(
        _includedCountMeta,
        includedCount.isAcceptableOrUnknown(
          data['included_count']!,
          _includedCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_includedCountMeta);
    }
    if (data.containsKey('manifest_sha256')) {
      context.handle(
        _manifestSha256Meta,
        manifestSha256.isAcceptableOrUnknown(
          data['manifest_sha256']!,
          _manifestSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manifestSha256Meta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExportRun map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExportRun(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start'],
      )!,
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end'],
      )!,
      formatVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}format_version'],
      )!,
      includedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}included_count'],
      )!,
      manifestSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manifest_sha256'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExportRunsTable createAlias(String alias) {
    return $ExportRunsTable(attachedDatabase, alias);
  }
}

class ExportRun extends DataClass implements Insertable<ExportRun> {
  final int id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int formatVersion;
  final int includedCount;
  final String manifestSha256;
  final DateTime createdAt;
  const ExportRun({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.formatVersion,
    required this.includedCount,
    required this.manifestSha256,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['format_version'] = Variable<int>(formatVersion);
    map['included_count'] = Variable<int>(includedCount);
    map['manifest_sha256'] = Variable<String>(manifestSha256);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExportRunsCompanion toCompanion(bool nullToAbsent) {
    return ExportRunsCompanion(
      id: Value(id),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      formatVersion: Value(formatVersion),
      includedCount: Value(includedCount),
      manifestSha256: Value(manifestSha256),
      createdAt: Value(createdAt),
    );
  }

  factory ExportRun.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExportRun(
      id: serializer.fromJson<int>(json['id']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      formatVersion: serializer.fromJson<int>(json['formatVersion']),
      includedCount: serializer.fromJson<int>(json['includedCount']),
      manifestSha256: serializer.fromJson<String>(json['manifestSha256']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'formatVersion': serializer.toJson<int>(formatVersion),
      'includedCount': serializer.toJson<int>(includedCount),
      'manifestSha256': serializer.toJson<String>(manifestSha256),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExportRun copyWith({
    int? id,
    DateTime? periodStart,
    DateTime? periodEnd,
    int? formatVersion,
    int? includedCount,
    String? manifestSha256,
    DateTime? createdAt,
  }) => ExportRun(
    id: id ?? this.id,
    periodStart: periodStart ?? this.periodStart,
    periodEnd: periodEnd ?? this.periodEnd,
    formatVersion: formatVersion ?? this.formatVersion,
    includedCount: includedCount ?? this.includedCount,
    manifestSha256: manifestSha256 ?? this.manifestSha256,
    createdAt: createdAt ?? this.createdAt,
  );
  ExportRun copyWithCompanion(ExportRunsCompanion data) {
    return ExportRun(
      id: data.id.present ? data.id.value : this.id,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      formatVersion: data.formatVersion.present
          ? data.formatVersion.value
          : this.formatVersion,
      includedCount: data.includedCount.present
          ? data.includedCount.value
          : this.includedCount,
      manifestSha256: data.manifestSha256.present
          ? data.manifestSha256.value
          : this.manifestSha256,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExportRun(')
          ..write('id: $id, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('formatVersion: $formatVersion, ')
          ..write('includedCount: $includedCount, ')
          ..write('manifestSha256: $manifestSha256, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    periodStart,
    periodEnd,
    formatVersion,
    includedCount,
    manifestSha256,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExportRun &&
          other.id == this.id &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.formatVersion == this.formatVersion &&
          other.includedCount == this.includedCount &&
          other.manifestSha256 == this.manifestSha256 &&
          other.createdAt == this.createdAt);
}

class ExportRunsCompanion extends UpdateCompanion<ExportRun> {
  final Value<int> id;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<int> formatVersion;
  final Value<int> includedCount;
  final Value<String> manifestSha256;
  final Value<DateTime> createdAt;
  const ExportRunsCompanion({
    this.id = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.formatVersion = const Value.absent(),
    this.includedCount = const Value.absent(),
    this.manifestSha256 = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExportRunsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime periodStart,
    required DateTime periodEnd,
    required int formatVersion,
    required int includedCount,
    required String manifestSha256,
    this.createdAt = const Value.absent(),
  }) : periodStart = Value(periodStart),
       periodEnd = Value(periodEnd),
       formatVersion = Value(formatVersion),
       includedCount = Value(includedCount),
       manifestSha256 = Value(manifestSha256);
  static Insertable<ExportRun> custom({
    Expression<int>? id,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<int>? formatVersion,
    Expression<int>? includedCount,
    Expression<String>? manifestSha256,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (formatVersion != null) 'format_version': formatVersion,
      if (includedCount != null) 'included_count': includedCount,
      if (manifestSha256 != null) 'manifest_sha256': manifestSha256,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExportRunsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? periodStart,
    Value<DateTime>? periodEnd,
    Value<int>? formatVersion,
    Value<int>? includedCount,
    Value<String>? manifestSha256,
    Value<DateTime>? createdAt,
  }) {
    return ExportRunsCompanion(
      id: id ?? this.id,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      formatVersion: formatVersion ?? this.formatVersion,
      includedCount: includedCount ?? this.includedCount,
      manifestSha256: manifestSha256 ?? this.manifestSha256,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (formatVersion.present) {
      map['format_version'] = Variable<int>(formatVersion.value);
    }
    if (includedCount.present) {
      map['included_count'] = Variable<int>(includedCount.value);
    }
    if (manifestSha256.present) {
      map['manifest_sha256'] = Variable<String>(manifestSha256.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExportRunsCompanion(')
          ..write('id: $id, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('formatVersion: $formatVersion, ')
          ..write('includedCount: $includedCount, ')
          ..write('manifestSha256: $manifestSha256, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExportItemsTable extends ExportItems
    with TableInfo<$ExportItemsTable, ExportItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExportItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exportRunIdMeta = const VerificationMeta(
    'exportRunId',
  );
  @override
  late final GeneratedColumn<int> exportRunId = GeneratedColumn<int>(
    'export_run_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES export_runs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotJsonMeta = const VerificationMeta(
    'snapshotJson',
  );
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
    'snapshot_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exportRunId,
    entityType,
    entityId,
    snapshotJson,
    contentHash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'export_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExportItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('export_run_id')) {
      context.handle(
        _exportRunIdMeta,
        exportRunId.isAcceptableOrUnknown(
          data['export_run_id']!,
          _exportRunIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exportRunIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
        _snapshotJsonMeta,
        snapshotJson.isAcceptableOrUnknown(
          data['snapshot_json']!,
          _snapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {exportRunId, entityType, entityId},
  ];
  @override
  ExportItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExportItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exportRunId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}export_run_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      snapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_json'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
    );
  }

  @override
  $ExportItemsTable createAlias(String alias) {
    return $ExportItemsTable(attachedDatabase, alias);
  }
}

class ExportItem extends DataClass implements Insertable<ExportItem> {
  final int id;
  final int exportRunId;
  final String entityType;
  final int entityId;
  final String snapshotJson;
  final String contentHash;
  const ExportItem({
    required this.id,
    required this.exportRunId,
    required this.entityType,
    required this.entityId,
    required this.snapshotJson,
    required this.contentHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['export_run_id'] = Variable<int>(exportRunId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    map['content_hash'] = Variable<String>(contentHash);
    return map;
  }

  ExportItemsCompanion toCompanion(bool nullToAbsent) {
    return ExportItemsCompanion(
      id: Value(id),
      exportRunId: Value(exportRunId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      snapshotJson: Value(snapshotJson),
      contentHash: Value(contentHash),
    );
  }

  factory ExportItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExportItem(
      id: serializer.fromJson<int>(json['id']),
      exportRunId: serializer.fromJson<int>(json['exportRunId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exportRunId': serializer.toJson<int>(exportRunId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'contentHash': serializer.toJson<String>(contentHash),
    };
  }

  ExportItem copyWith({
    int? id,
    int? exportRunId,
    String? entityType,
    int? entityId,
    String? snapshotJson,
    String? contentHash,
  }) => ExportItem(
    id: id ?? this.id,
    exportRunId: exportRunId ?? this.exportRunId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    snapshotJson: snapshotJson ?? this.snapshotJson,
    contentHash: contentHash ?? this.contentHash,
  );
  ExportItem copyWithCompanion(ExportItemsCompanion data) {
    return ExportItem(
      id: data.id.present ? data.id.value : this.id,
      exportRunId: data.exportRunId.present
          ? data.exportRunId.value
          : this.exportRunId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExportItem(')
          ..write('id: $id, ')
          ..write('exportRunId: $exportRunId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('contentHash: $contentHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exportRunId,
    entityType,
    entityId,
    snapshotJson,
    contentHash,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExportItem &&
          other.id == this.id &&
          other.exportRunId == this.exportRunId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.snapshotJson == this.snapshotJson &&
          other.contentHash == this.contentHash);
}

class ExportItemsCompanion extends UpdateCompanion<ExportItem> {
  final Value<int> id;
  final Value<int> exportRunId;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> snapshotJson;
  final Value<String> contentHash;
  const ExportItemsCompanion({
    this.id = const Value.absent(),
    this.exportRunId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.contentHash = const Value.absent(),
  });
  ExportItemsCompanion.insert({
    this.id = const Value.absent(),
    required int exportRunId,
    required String entityType,
    required int entityId,
    required String snapshotJson,
    required String contentHash,
  }) : exportRunId = Value(exportRunId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       snapshotJson = Value(snapshotJson),
       contentHash = Value(contentHash);
  static Insertable<ExportItem> custom({
    Expression<int>? id,
    Expression<int>? exportRunId,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? snapshotJson,
    Expression<String>? contentHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exportRunId != null) 'export_run_id': exportRunId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (contentHash != null) 'content_hash': contentHash,
    });
  }

  ExportItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? exportRunId,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String>? snapshotJson,
    Value<String>? contentHash,
  }) {
    return ExportItemsCompanion(
      id: id ?? this.id,
      exportRunId: exportRunId ?? this.exportRunId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      contentHash: contentHash ?? this.contentHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exportRunId.present) {
      map['export_run_id'] = Variable<int>(exportRunId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExportItemsCompanion(')
          ..write('id: $id, ')
          ..write('exportRunId: $exportRunId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('contentHash: $contentHash')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $RawMessagesTable rawMessages = $RawMessagesTable(this);
  late final $MerchantRulesTable merchantRules = $MerchantRulesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $ImportJobsTable importJobs = $ImportJobsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceLinesTable invoiceLines = $InvoiceLinesTable(this);
  late final $SourceEventsTable sourceEvents = $SourceEventsTable(this);
  late final $ClassificationsTable classifications = $ClassificationsTable(
    this,
  );
  late final $BusinessRulesTable businessRules = $BusinessRulesTable(this);
  late final $PaymentAllocationsTable paymentAllocations =
      $PaymentAllocationsTable(this);
  late final $ReviewEventsTable reviewEvents = $ReviewEventsTable(this);
  late final $ExportRunsTable exportRuns = $ExportRunsTable(this);
  late final $ExportItemsTable exportItems = $ExportItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    categories,
    transactions,
    rawMessages,
    merchantRules,
    budgets,
    importJobs,
    documents,
    invoices,
    invoiceLines,
    sourceEvents,
    classifications,
    businessRules,
    paymentAllocations,
    reviewEvents,
    exportRuns,
    exportItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('raw_messages', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('merchant_rules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budgets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('source_events', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('classifications', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'export_runs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('export_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  required AccountKind kind,
  Value<String?> institution,
  Value<String?> last4,
  required int color,
  Value<bool> archived,
  Value<String> currency,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<AccountKind> kind,
  Value<String?> institution,
  Value<String?> last4,
  Value<int> color,
  Value<bool> archived,
  Value<String> currency,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImportJobsTable, List<ImportJob>>
  _importJobsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.importJobs,
    aliasName: 'accounts__id__import_jobs__source_account_id',
  );

  $$ImportJobsTableProcessedTableManager get importJobsRefs {
    final manager = $$ImportJobsTableTableManager(
      $_db,
      $_db.importJobs,
    ).filter((f) => f.sourceAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_importJobsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceEventsTable, List<SourceEvent>>
  _sourceEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceEvents,
    aliasName: 'accounts__id__source_events__source_account_id',
  );

  $$SourceEventsTableProcessedTableManager get sourceEventsRefs {
    final manager = $$SourceEventsTableTableManager(
      $_db,
      $_db.sourceEvents,
    ).filter((f) => f.sourceAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<AccountKind, AccountKind, int> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> importJobsRefs(
    Expression<bool> Function($$ImportJobsTableFilterComposer f) f,
  ) {
    final $$ImportJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableFilterComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceEventsRefs(
    Expression<bool> Function($$SourceEventsTableFilterComposer f) f,
  ) {
    final $$SourceEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEvents,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEventsTableFilterComposer(
            $db: $db,
            $table: $db.sourceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<AccountKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> importJobsRefs<T extends Object>(
    Expression<T> Function($$ImportJobsTableAnnotationComposer a) f,
  ) {
    final $$ImportJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceEventsRefs<T extends Object>(
    Expression<T> Function($$SourceEventsTableAnnotationComposer a) f,
  ) {
    final $$SourceEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEvents,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool importJobsRefs,
            bool sourceEventsRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountKind> kind = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<String> currency = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                kind: kind,
                institution: institution,
                last4: last4,
                color: color,
                archived: archived,
                currency: currency,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required AccountKind kind,
                Value<String?> institution = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                required int color,
                Value<bool> archived = const Value.absent(),
                Value<String> currency = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                institution: institution,
                last4: last4,
                color: color,
                archived: archived,
                currency: currency,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, Account>(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                importJobsRefs = false,
                sourceEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (importJobsRefs) db.importJobs,
                    if (sourceEventsRefs) db.sourceEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (importJobsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          ImportJob
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._importJobsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).importJobsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceEventsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          SourceEvent
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._sourceEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool importJobsRefs,
        bool sourceEventsRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required String icon,
  required int color,
  Value<bool> isIncome,
  Value<int> sortOrder,
  Value<String?> seedName,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> icon,
  Value<int> color,
  Value<bool> isIncome,
  Value<int> sortOrder,
  Value<String?> seedName,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MerchantRulesTable, List<MerchantRule>>
  _merchantRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.merchantRules,
    aliasName: 'categories__id__merchant_rules__category_id',
  );

  $$MerchantRulesTableProcessedTableManager get merchantRulesRefs {
    final manager = $$MerchantRulesTableTableManager(
      $_db,
      $_db.merchantRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_merchantRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassificationsTable, List<Classification>>
  _suggestedClassificationsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.classifications,
        aliasName: 'categories__id__classifications__suggested_category_id',
      );

  $$ClassificationsTableProcessedTableManager get suggestedClassifications {
    final manager =
        $$ClassificationsTableTableManager($_db, $_db.classifications).filter(
          (f) => f.suggestedCategoryId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _suggestedClassificationsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassificationsTable, List<Classification>>
  _confirmedClassificationsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.classifications,
        aliasName: 'categories__id__classifications__confirmed_category_id',
      );

  $$ClassificationsTableProcessedTableManager get confirmedClassifications {
    final manager =
        $$ClassificationsTableTableManager($_db, $_db.classifications).filter(
          (f) => f.confirmedCategoryId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _confirmedClassificationsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedName => $composableBuilder(
    column: $table.seedName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> merchantRulesRefs(
    Expression<bool> Function($$MerchantRulesTableFilterComposer f) f,
  ) {
    final $$MerchantRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.merchantRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MerchantRulesTableFilterComposer(
            $db: $db,
            $table: $db.merchantRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> suggestedClassifications(
    Expression<bool> Function($$ClassificationsTableFilterComposer f) f,
  ) {
    final $$ClassificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classifications,
      getReferencedColumn: (t) => t.suggestedCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationsTableFilterComposer(
            $db: $db,
            $table: $db.classifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> confirmedClassifications(
    Expression<bool> Function($$ClassificationsTableFilterComposer f) f,
  ) {
    final $$ClassificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classifications,
      getReferencedColumn: (t) => t.confirmedCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationsTableFilterComposer(
            $db: $db,
            $table: $db.classifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedName => $composableBuilder(
    column: $table.seedName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get seedName =>
      $composableBuilder(column: $table.seedName, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> merchantRulesRefs<T extends Object>(
    Expression<T> Function($$MerchantRulesTableAnnotationComposer a) f,
  ) {
    final $$MerchantRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.merchantRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MerchantRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.merchantRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> suggestedClassifications<T extends Object>(
    Expression<T> Function($$ClassificationsTableAnnotationComposer a) f,
  ) {
    final $$ClassificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classifications,
      getReferencedColumn: (t) => t.suggestedCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.classifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> confirmedClassifications<T extends Object>(
    Expression<T> Function($$ClassificationsTableAnnotationComposer a) f,
  ) {
    final $$ClassificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classifications,
      getReferencedColumn: (t) => t.confirmedCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.classifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool merchantRulesRefs,
            bool budgetsRefs,
            bool suggestedClassifications,
            bool confirmedClassifications,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> seedName = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                isIncome: isIncome,
                sortOrder: sortOrder,
                seedName: seedName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                required int color,
                Value<bool> isIncome = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> seedName = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                isIncome: isIncome,
                sortOrder: sortOrder,
                seedName: seedName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                merchantRulesRefs = false,
                budgetsRefs = false,
                suggestedClassifications = false,
                confirmedClassifications = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (merchantRulesRefs) db.merchantRules,
                    if (budgetsRefs) db.budgets,
                    if (suggestedClassifications) db.classifications,
                    if (confirmedClassifications) db.classifications,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (merchantRulesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          MerchantRule
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._merchantRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).merchantRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Budget
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (suggestedClassifications)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Classification
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._suggestedClassificationsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).suggestedClassifications,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.suggestedCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (confirmedClassifications)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Classification
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._confirmedClassificationsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).confirmedClassifications,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.confirmedCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool merchantRulesRefs,
        bool budgetsRefs,
        bool suggestedClassifications,
        bool confirmedClassifications,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int amountMinor,
      Value<String> currency,
      Value<int?> convertedMinor,
      Value<String?> convertedCurrency,
      required TxnDirection direction,
      required DateTime occurredAt,
      Value<String?> merchant,
      Value<String?> counterparty,
      Value<String?> note,
      Value<int?> categoryId,
      Value<int?> accountId,
      Value<String?> accountHint,
      required PaymentMode mode,
      Value<String?> reference,
      required TxnStatus status,
      Value<bool> isTransfer,
      Value<bool> categoryLocked,
      Value<int> businessUseBps,
      Value<String> reviewStatus,
      Value<int?> duplicateOfId,
      Value<DateTime> createdAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> amountMinor,
      Value<String> currency,
      Value<int?> convertedMinor,
      Value<String?> convertedCurrency,
      Value<TxnDirection> direction,
      Value<DateTime> occurredAt,
      Value<String?> merchant,
      Value<String?> counterparty,
      Value<String?> note,
      Value<int?> categoryId,
      Value<int?> accountId,
      Value<String?> accountHint,
      Value<PaymentMode> mode,
      Value<String?> reference,
      Value<TxnStatus> status,
      Value<bool> isTransfer,
      Value<bool> categoryLocked,
      Value<int> businessUseBps,
      Value<String> reviewStatus,
      Value<int?> duplicateOfId,
      Value<DateTime> createdAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RawMessagesTable, List<RawMessage>>
  _rawMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rawMessages,
    aliasName: 'transactions__id__raw_messages__transaction_id',
  );

  $$RawMessagesTableProcessedTableManager get rawMessagesRefs {
    final manager = $$RawMessagesTableTableManager(
      $_db,
      $_db.rawMessages,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rawMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SourceEventsTable, List<SourceEvent>>
  _sourceEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceEvents,
    aliasName: 'transactions__id__source_events__transaction_id',
  );

  $$SourceEventsTableProcessedTableManager get sourceEventsRefs {
    final manager = $$SourceEventsTableTableManager(
      $_db,
      $_db.sourceEvents,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClassificationsTable, List<Classification>>
  _classificationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classifications,
    aliasName: 'transactions__id__classifications__transaction_id',
  );

  $$ClassificationsTableProcessedTableManager get classificationsRefs {
    final manager = $$ClassificationsTableTableManager(
      $_db,
      $_db.classifications,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _classificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
  _paymentAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentAllocations,
        aliasName: 'transactions__id__payment_allocations__transaction_id',
      );

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
      $_db,
      $_db.paymentAllocations,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get convertedMinor => $composableBuilder(
    column: $table.convertedMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get convertedCurrency => $composableBuilder(
    column: $table.convertedCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnDirection, TxnDirection, int>
  get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountHint => $composableBuilder(
    column: $table.accountHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, int> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnStatus, TxnStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isTransfer => $composableBuilder(
    column: $table.isTransfer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get categoryLocked => $composableBuilder(
    column: $table.categoryLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duplicateOfId => $composableBuilder(
    column: $table.duplicateOfId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> rawMessagesRefs(
    Expression<bool> Function($$RawMessagesTableFilterComposer f) f,
  ) {
    final $$RawMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rawMessages,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawMessagesTableFilterComposer(
            $db: $db,
            $table: $db.rawMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceEventsRefs(
    Expression<bool> Function($$SourceEventsTableFilterComposer f) f,
  ) {
    final $$SourceEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEvents,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEventsTableFilterComposer(
            $db: $db,
            $table: $db.sourceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classificationsRefs(
    Expression<bool> Function($$ClassificationsTableFilterComposer f) f,
  ) {
    final $$ClassificationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classifications,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationsTableFilterComposer(
            $db: $db,
            $table: $db.classifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentAllocationsRefs(
    Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f,
  ) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAllocations,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get convertedMinor => $composableBuilder(
    column: $table.convertedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get convertedCurrency => $composableBuilder(
    column: $table.convertedCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountHint => $composableBuilder(
    column: $table.accountHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTransfer => $composableBuilder(
    column: $table.isTransfer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get categoryLocked => $composableBuilder(
    column: $table.categoryLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duplicateOfId => $composableBuilder(
    column: $table.duplicateOfId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get convertedMinor => $composableBuilder(
    column: $table.convertedMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get convertedCurrency => $composableBuilder(
    column: $table.convertedCurrency,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TxnDirection, int> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get accountHint => $composableBuilder(
    column: $table.accountHint,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMode, int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isTransfer => $composableBuilder(
    column: $table.isTransfer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get categoryLocked => $composableBuilder(
    column: $table.categoryLocked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duplicateOfId => $composableBuilder(
    column: $table.duplicateOfId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> rawMessagesRefs<T extends Object>(
    Expression<T> Function($$RawMessagesTableAnnotationComposer a) f,
  ) {
    final $$RawMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rawMessages,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RawMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.rawMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceEventsRefs<T extends Object>(
    Expression<T> Function($$SourceEventsTableAnnotationComposer a) f,
  ) {
    final $$SourceEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEvents,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> classificationsRefs<T extends Object>(
    Expression<T> Function($$ClassificationsTableAnnotationComposer a) f,
  ) {
    final $$ClassificationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classifications,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationsTableAnnotationComposer(
            $db: $db,
            $table: $db.classifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentAllocations,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool categoryId,
            bool accountId,
            bool rawMessagesRefs,
            bool sourceEventsRefs,
            bool classificationsRefs,
            bool paymentAllocationsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> convertedMinor = const Value.absent(),
                Value<String?> convertedCurrency = const Value.absent(),
                Value<TxnDirection> direction = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> counterparty = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<String?> accountHint = const Value.absent(),
                Value<PaymentMode> mode = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<TxnStatus> status = const Value.absent(),
                Value<bool> isTransfer = const Value.absent(),
                Value<bool> categoryLocked = const Value.absent(),
                Value<int> businessUseBps = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<int?> duplicateOfId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amountMinor: amountMinor,
                currency: currency,
                convertedMinor: convertedMinor,
                convertedCurrency: convertedCurrency,
                direction: direction,
                occurredAt: occurredAt,
                merchant: merchant,
                counterparty: counterparty,
                note: note,
                categoryId: categoryId,
                accountId: accountId,
                accountHint: accountHint,
                mode: mode,
                reference: reference,
                status: status,
                isTransfer: isTransfer,
                categoryLocked: categoryLocked,
                businessUseBps: businessUseBps,
                reviewStatus: reviewStatus,
                duplicateOfId: duplicateOfId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountMinor,
                Value<String> currency = const Value.absent(),
                Value<int?> convertedMinor = const Value.absent(),
                Value<String?> convertedCurrency = const Value.absent(),
                required TxnDirection direction,
                required DateTime occurredAt,
                Value<String?> merchant = const Value.absent(),
                Value<String?> counterparty = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<String?> accountHint = const Value.absent(),
                required PaymentMode mode,
                Value<String?> reference = const Value.absent(),
                required TxnStatus status,
                Value<bool> isTransfer = const Value.absent(),
                Value<bool> categoryLocked = const Value.absent(),
                Value<int> businessUseBps = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<int?> duplicateOfId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amountMinor: amountMinor,
                currency: currency,
                convertedMinor: convertedMinor,
                convertedCurrency: convertedCurrency,
                direction: direction,
                occurredAt: occurredAt,
                merchant: merchant,
                counterparty: counterparty,
                note: note,
                categoryId: categoryId,
                accountId: accountId,
                accountHint: accountHint,
                mode: mode,
                reference: reference,
                status: status,
                isTransfer: isTransfer,
                categoryLocked: categoryLocked,
                businessUseBps: businessUseBps,
                reviewStatus: reviewStatus,
                duplicateOfId: duplicateOfId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Transaction>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                accountId = false,
                rawMessagesRefs = false,
                sourceEventsRefs = false,
                classificationsRefs = false,
                paymentAllocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (rawMessagesRefs) db.rawMessages,
                    if (sourceEventsRefs) db.sourceEvents,
                    if (classificationsRefs) db.classifications,
                    if (paymentAllocationsRefs) db.paymentAllocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionsTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (rawMessagesRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          RawMessage
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._rawMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).rawMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceEventsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          SourceEvent
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._sourceEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (classificationsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          Classification
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._classificationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).classificationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentAllocationsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          PaymentAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._paymentAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool categoryId,
        bool accountId,
        bool rawMessagesRefs,
        bool sourceEventsRefs,
        bool classificationsRefs,
        bool paymentAllocationsRefs,
      })
    >;
typedef $$RawMessagesTableCreateCompanionBuilder =
    RawMessagesCompanion Function({
      Value<int> id,
      required SourceKind source,
      required String externalId,
      required String sender,
      required String body,
      required DateTime receivedAt,
      required ParseStatus parseStatus,
      Value<String?> ignoreReason,
      Value<int?> transactionId,
      Value<double?> mergeScore,
    });
typedef $$RawMessagesTableUpdateCompanionBuilder =
    RawMessagesCompanion Function({
      Value<int> id,
      Value<SourceKind> source,
      Value<String> externalId,
      Value<String> sender,
      Value<String> body,
      Value<DateTime> receivedAt,
      Value<ParseStatus> parseStatus,
      Value<String?> ignoreReason,
      Value<int?> transactionId,
      Value<double?> mergeScore,
    });

final class $$RawMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $RawMessagesTable, RawMessage> {
  $$RawMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('raw_messages__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RawMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $RawMessagesTable> {
  $$RawMessagesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<SourceKind, SourceKind, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ParseStatus, ParseStatus, int>
  get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get ignoreReason => $composableBuilder(
    column: $table.ignoreReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mergeScore => $composableBuilder(
    column: $table.mergeScore,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RawMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $RawMessagesTable> {
  $$RawMessagesTableOrderingComposer({
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

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ignoreReason => $composableBuilder(
    column: $table.ignoreReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mergeScore => $composableBuilder(
    column: $table.mergeScore,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RawMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawMessagesTable> {
  $$RawMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceKind, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ParseStatus, int> get parseStatus =>
      $composableBuilder(
        column: $table.parseStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get ignoreReason => $composableBuilder(
    column: $table.ignoreReason,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mergeScore => $composableBuilder(
    column: $table.mergeScore,
    builder: (column) => column,
  );

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RawMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RawMessagesTable,
          RawMessage,
          $$RawMessagesTableFilterComposer,
          $$RawMessagesTableOrderingComposer,
          $$RawMessagesTableAnnotationComposer,
          $$RawMessagesTableCreateCompanionBuilder,
          $$RawMessagesTableUpdateCompanionBuilder,
          (RawMessage, $$RawMessagesTableReferences),
          RawMessage,
          PrefetchHooks Function({bool transactionId})
        > {
  $$RawMessagesTableTableManager(_$AppDatabase db, $RawMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SourceKind> source = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<ParseStatus> parseStatus = const Value.absent(),
                Value<String?> ignoreReason = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<double?> mergeScore = const Value.absent(),
              }) => RawMessagesCompanion(
                id: id,
                source: source,
                externalId: externalId,
                sender: sender,
                body: body,
                receivedAt: receivedAt,
                parseStatus: parseStatus,
                ignoreReason: ignoreReason,
                transactionId: transactionId,
                mergeScore: mergeScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required SourceKind source,
                required String externalId,
                required String sender,
                required String body,
                required DateTime receivedAt,
                required ParseStatus parseStatus,
                Value<String?> ignoreReason = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<double?> mergeScore = const Value.absent(),
              }) => RawMessagesCompanion.insert(
                id: id,
                source: source,
                externalId: externalId,
                sender: sender,
                body: body,
                receivedAt: receivedAt,
                parseStatus: parseStatus,
                ignoreReason: ignoreReason,
                transactionId: transactionId,
                mergeScore: mergeScore,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RawMessagesTable, RawMessage>(table),
                  $$RawMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$RawMessagesTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$RawMessagesTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RawMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RawMessagesTable,
      RawMessage,
      $$RawMessagesTableFilterComposer,
      $$RawMessagesTableOrderingComposer,
      $$RawMessagesTableAnnotationComposer,
      $$RawMessagesTableCreateCompanionBuilder,
      $$RawMessagesTableUpdateCompanionBuilder,
      (RawMessage, $$RawMessagesTableReferences),
      RawMessage,
      PrefetchHooks Function({bool transactionId})
    >;
typedef $$MerchantRulesTableCreateCompanionBuilder =
    MerchantRulesCompanion Function({
      Value<int> id,
      required String pattern,
      required int categoryId,
    });
typedef $$MerchantRulesTableUpdateCompanionBuilder =
    MerchantRulesCompanion Function({
      Value<int> id,
      Value<String> pattern,
      Value<int> categoryId,
    });

final class $$MerchantRulesTableReferences
    extends BaseReferences<_$AppDatabase, $MerchantRulesTable, MerchantRule> {
  $$MerchantRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('merchant_rules__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MerchantRulesTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantRulesTable> {
  $$MerchantRulesTableFilterComposer({
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

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantRulesTable> {
  $$MerchantRulesTableOrderingComposer({
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

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantRulesTable> {
  $$MerchantRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantRulesTable,
          MerchantRule,
          $$MerchantRulesTableFilterComposer,
          $$MerchantRulesTableOrderingComposer,
          $$MerchantRulesTableAnnotationComposer,
          $$MerchantRulesTableCreateCompanionBuilder,
          $$MerchantRulesTableUpdateCompanionBuilder,
          (MerchantRule, $$MerchantRulesTableReferences),
          MerchantRule,
          PrefetchHooks Function({bool categoryId})
        > {
  $$MerchantRulesTableTableManager(_$AppDatabase db, $MerchantRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
              }) => MerchantRulesCompanion(
                id: id,
                pattern: pattern,
                categoryId: categoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pattern,
                required int categoryId,
              }) => MerchantRulesCompanion.insert(
                id: id,
                pattern: pattern,
                categoryId: categoryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MerchantRulesTable, MerchantRule>(table),
                  $$MerchantRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$MerchantRulesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$MerchantRulesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MerchantRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantRulesTable,
      MerchantRule,
      $$MerchantRulesTableFilterComposer,
      $$MerchantRulesTableOrderingComposer,
      $$MerchantRulesTableAnnotationComposer,
      $$MerchantRulesTableCreateCompanionBuilder,
      $$MerchantRulesTableUpdateCompanionBuilder,
      (MerchantRule, $$MerchantRulesTableReferences),
      MerchantRule,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  Value<int?> categoryId,
  required int amountMinor,
  Value<String> currency,
  Value<bool> active,
  Value<DateTime> createdAt,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  Value<int?> categoryId,
  Value<int> amountMinor,
  Value<String> currency,
  Value<bool> active,
  Value<DateTime> createdAt,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
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

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
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

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, $$BudgetsTableReferences),
          Budget,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currency: currency,
                active: active,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                required int amountMinor,
                Value<String> currency = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currency: currency,
                active: active,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, Budget>(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, $$BudgetsTableReferences),
      Budget,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$ImportJobsTableCreateCompanionBuilder = ImportJobsCompanion Function({
  Value<int> id,
  required int sourceAccountId,
  Value<String> source,
  required String fileHash,
  required String fileName,
  required int parserVersion,
  required String mappingJson,
  Value<String> status,
  Value<String> currency,
  required int openingMinor,
  required int closingMinor,
  required int debitMinor,
  required int creditMinor,
  required int rowCount,
  Value<int> addedCount,
  Value<int> matchedCount,
  Value<int> skippedCount,
  Value<String?> error,
  Value<DateTime> createdAt,
});
typedef $$ImportJobsTableUpdateCompanionBuilder = ImportJobsCompanion Function({
  Value<int> id,
  Value<int> sourceAccountId,
  Value<String> source,
  Value<String> fileHash,
  Value<String> fileName,
  Value<int> parserVersion,
  Value<String> mappingJson,
  Value<String> status,
  Value<String> currency,
  Value<int> openingMinor,
  Value<int> closingMinor,
  Value<int> debitMinor,
  Value<int> creditMinor,
  Value<int> rowCount,
  Value<int> addedCount,
  Value<int> matchedCount,
  Value<int> skippedCount,
  Value<String?> error,
  Value<DateTime> createdAt,
});

final class $$ImportJobsTableReferences
    extends BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJob> {
  $$ImportJobsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _sourceAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('import_jobs__source_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get sourceAccountId {
    final $_column = $_itemColumn<int>('source_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SourceEventsTable, List<SourceEvent>>
  _sourceEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sourceEvents,
    aliasName: 'import_jobs__id__source_events__import_job_id',
  );

  $$SourceEventsTableProcessedTableManager get sourceEventsRefs {
    final manager = $$SourceEventsTableTableManager(
      $_db,
      $_db.sourceEvents,
    ).filter((f) => f.importJobId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportJobsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableFilterComposer({
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

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mappingJson => $composableBuilder(
    column: $table.mappingJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingMinor => $composableBuilder(
    column: $table.openingMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closingMinor => $composableBuilder(
    column: $table.closingMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get debitMinor => $composableBuilder(
    column: $table.debitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditMinor => $composableBuilder(
    column: $table.creditMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rowCount => $composableBuilder(
    column: $table.rowCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedCount => $composableBuilder(
    column: $table.addedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchedCount => $composableBuilder(
    column: $table.matchedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get sourceAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sourceEventsRefs(
    Expression<bool> Function($$SourceEventsTableFilterComposer f) f,
  ) {
    final $$SourceEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEvents,
      getReferencedColumn: (t) => t.importJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEventsTableFilterComposer(
            $db: $db,
            $table: $db.sourceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableOrderingComposer({
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mappingJson => $composableBuilder(
    column: $table.mappingJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingMinor => $composableBuilder(
    column: $table.openingMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closingMinor => $composableBuilder(
    column: $table.closingMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get debitMinor => $composableBuilder(
    column: $table.debitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditMinor => $composableBuilder(
    column: $table.creditMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rowCount => $composableBuilder(
    column: $table.rowCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedCount => $composableBuilder(
    column: $table.addedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchedCount => $composableBuilder(
    column: $table.matchedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get sourceAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mappingJson => $composableBuilder(
    column: $table.mappingJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get openingMinor => $composableBuilder(
    column: $table.openingMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get closingMinor => $composableBuilder(
    column: $table.closingMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get debitMinor => $composableBuilder(
    column: $table.debitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditMinor => $composableBuilder(
    column: $table.creditMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rowCount =>
      $composableBuilder(column: $table.rowCount, builder: (column) => column);

  GeneratedColumn<int> get addedCount => $composableBuilder(
    column: $table.addedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get matchedCount => $composableBuilder(
    column: $table.matchedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get sourceAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sourceEventsRefs<T extends Object>(
    Expression<T> Function($$SourceEventsTableAnnotationComposer a) f,
  ) {
    final $$SourceEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceEvents,
      getReferencedColumn: (t) => t.importJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportJobsTable,
          ImportJob,
          $$ImportJobsTableFilterComposer,
          $$ImportJobsTableOrderingComposer,
          $$ImportJobsTableAnnotationComposer,
          $$ImportJobsTableCreateCompanionBuilder,
          $$ImportJobsTableUpdateCompanionBuilder,
          (ImportJob, $$ImportJobsTableReferences),
          ImportJob,
          PrefetchHooks Function({bool sourceAccountId, bool sourceEventsRefs})
        > {
  $$ImportJobsTableTableManager(_$AppDatabase db, $ImportJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sourceAccountId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> parserVersion = const Value.absent(),
                Value<String> mappingJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> openingMinor = const Value.absent(),
                Value<int> closingMinor = const Value.absent(),
                Value<int> debitMinor = const Value.absent(),
                Value<int> creditMinor = const Value.absent(),
                Value<int> rowCount = const Value.absent(),
                Value<int> addedCount = const Value.absent(),
                Value<int> matchedCount = const Value.absent(),
                Value<int> skippedCount = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ImportJobsCompanion(
                id: id,
                sourceAccountId: sourceAccountId,
                source: source,
                fileHash: fileHash,
                fileName: fileName,
                parserVersion: parserVersion,
                mappingJson: mappingJson,
                status: status,
                currency: currency,
                openingMinor: openingMinor,
                closingMinor: closingMinor,
                debitMinor: debitMinor,
                creditMinor: creditMinor,
                rowCount: rowCount,
                addedCount: addedCount,
                matchedCount: matchedCount,
                skippedCount: skippedCount,
                error: error,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sourceAccountId,
                Value<String> source = const Value.absent(),
                required String fileHash,
                required String fileName,
                required int parserVersion,
                required String mappingJson,
                Value<String> status = const Value.absent(),
                Value<String> currency = const Value.absent(),
                required int openingMinor,
                required int closingMinor,
                required int debitMinor,
                required int creditMinor,
                required int rowCount,
                Value<int> addedCount = const Value.absent(),
                Value<int> matchedCount = const Value.absent(),
                Value<int> skippedCount = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ImportJobsCompanion.insert(
                id: id,
                sourceAccountId: sourceAccountId,
                source: source,
                fileHash: fileHash,
                fileName: fileName,
                parserVersion: parserVersion,
                mappingJson: mappingJson,
                status: status,
                currency: currency,
                openingMinor: openingMinor,
                closingMinor: closingMinor,
                debitMinor: debitMinor,
                creditMinor: creditMinor,
                rowCount: rowCount,
                addedCount: addedCount,
                matchedCount: matchedCount,
                skippedCount: skippedCount,
                error: error,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportJobsTable, ImportJob>(table),
                  $$ImportJobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceAccountId = false, sourceEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceEventsRefs) db.sourceEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceAccountId,
                            referencedTable: $$ImportJobsTableReferences
                                ._sourceAccountIdTable(db),
                            referencedColumn: $$ImportJobsTableReferences
                                ._sourceAccountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceEventsRefs)
                        await $_getPrefetchedData<
                          ImportJob,
                          $ImportJobsTable,
                          SourceEvent
                        >(
                          currentTable: table,
                          referencedTable: $$ImportJobsTableReferences
                              ._sourceEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportJobsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.importJobId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ImportJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportJobsTable,
      ImportJob,
      $$ImportJobsTableFilterComposer,
      $$ImportJobsTableOrderingComposer,
      $$ImportJobsTableAnnotationComposer,
      $$ImportJobsTableCreateCompanionBuilder,
      $$ImportJobsTableUpdateCompanionBuilder,
      (ImportJob, $$ImportJobsTableReferences),
      ImportJob,
      PrefetchHooks Function({bool sourceAccountId, bool sourceEventsRefs})
    >;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  required String sha256,
  required String encryptedFilePath,
  required String originalName,
  Value<String> documentType,
  required int byteLength,
  Value<int> encryptionVersion,
  Value<int> extractionVersion,
  Value<String> extractionStatus,
  Value<DateTime> createdAt,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<String> sha256,
  Value<String> encryptedFilePath,
  Value<String> originalName,
  Value<String> documentType,
  Value<int> byteLength,
  Value<int> encryptionVersion,
  Value<int> extractionVersion,
  Value<String> extractionStatus,
  Value<DateTime> createdAt,
});

final class $$DocumentsTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentsTable, Document> {
  $$DocumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'documents__id__invoices__document_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
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

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedFilePath => $composableBuilder(
    column: $table.encryptedFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteLength => $composableBuilder(
    column: $table.byteLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get encryptionVersion => $composableBuilder(
    column: $table.encryptionVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get extractionVersion => $composableBuilder(
    column: $table.extractionVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionStatus => $composableBuilder(
    column: $table.extractionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
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

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedFilePath => $composableBuilder(
    column: $table.encryptedFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteLength => $composableBuilder(
    column: $table.byteLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get encryptionVersion => $composableBuilder(
    column: $table.encryptionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get extractionVersion => $composableBuilder(
    column: $table.extractionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionStatus => $composableBuilder(
    column: $table.extractionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get encryptedFilePath => $composableBuilder(
    column: $table.encryptedFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get byteLength => $composableBuilder(
    column: $table.byteLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get encryptionVersion => $composableBuilder(
    column: $table.encryptionVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get extractionVersion => $composableBuilder(
    column: $table.extractionVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionStatus => $composableBuilder(
    column: $table.extractionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, $$DocumentsTableReferences),
          Document,
          PrefetchHooks Function({bool invoicesRefs})
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<String> encryptedFilePath = const Value.absent(),
                Value<String> originalName = const Value.absent(),
                Value<String> documentType = const Value.absent(),
                Value<int> byteLength = const Value.absent(),
                Value<int> encryptionVersion = const Value.absent(),
                Value<int> extractionVersion = const Value.absent(),
                Value<String> extractionStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                sha256: sha256,
                encryptedFilePath: encryptedFilePath,
                originalName: originalName,
                documentType: documentType,
                byteLength: byteLength,
                encryptionVersion: encryptionVersion,
                extractionVersion: extractionVersion,
                extractionStatus: extractionStatus,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sha256,
                required String encryptedFilePath,
                required String originalName,
                Value<String> documentType = const Value.absent(),
                required int byteLength,
                Value<int> encryptionVersion = const Value.absent(),
                Value<int> extractionVersion = const Value.absent(),
                Value<String> extractionStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                sha256: sha256,
                encryptedFilePath: encryptedFilePath,
                originalName: originalName,
                documentType: documentType,
                byteLength: byteLength,
                encryptionVersion: encryptionVersion,
                extractionVersion: extractionVersion,
                extractionStatus: extractionStatus,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentsTable, Document>(table),
                  $$DocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (invoicesRefs) db.invoices],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoicesRefs)
                    await $_getPrefetchedData<
                      Document,
                      $DocumentsTable,
                      Invoice
                    >(
                      currentTable: table,
                      referencedTable: $$DocumentsTableReferences
                          ._invoicesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DocumentsTableReferences(
                            db,
                            table,
                            p0,
                          ).invoicesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.documentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, $$DocumentsTableReferences),
      Document,
      PrefetchHooks Function({bool invoicesRefs})
    >;
typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  required int documentId,
  Value<String> kind,
  Value<String?> supplierGstin,
  Value<String?> recipientGstin,
  required String vendorName,
  required String invoiceNumber,
  required DateTime invoiceDate,
  Value<String> currency,
  required int taxableMinor,
  Value<int> cgstMinor,
  Value<int> sgstMinor,
  Value<int> igstMinor,
  Value<int> cessMinor,
  Value<int> roundingMinor,
  required int totalMinor,
  Value<String> arithmeticStatus,
  Value<String> gstEligibilityStatus,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  Value<int> documentId,
  Value<String> kind,
  Value<String?> supplierGstin,
  Value<String?> recipientGstin,
  Value<String> vendorName,
  Value<String> invoiceNumber,
  Value<DateTime> invoiceDate,
  Value<String> currency,
  Value<int> taxableMinor,
  Value<int> cgstMinor,
  Value<int> sgstMinor,
  Value<int> igstMinor,
  Value<int> cessMinor,
  Value<int> roundingMinor,
  Value<int> totalMinor,
  Value<String> arithmeticStatus,
  Value<String> gstEligibilityStatus,
});

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias('invoices__document_id__documents__id');

  $$DocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<int>('document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceLinesTable, List<InvoiceLine>>
  _invoiceLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceLines,
    aliasName: 'invoices__id__invoice_lines__invoice_id',
  );

  $$InvoiceLinesTableProcessedTableManager get invoiceLinesRefs {
    final manager = $$InvoiceLinesTableTableManager(
      $_db,
      $_db.invoiceLines,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
  _paymentAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentAllocations,
        aliasName: 'invoices__id__payment_allocations__invoice_id',
      );

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
      $_db,
      $_db.paymentAllocations,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierGstin => $composableBuilder(
    column: $table.supplierGstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientGstin => $composableBuilder(
    column: $table.recipientGstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorName => $composableBuilder(
    column: $table.vendorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxableMinor => $composableBuilder(
    column: $table.taxableMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cgstMinor => $composableBuilder(
    column: $table.cgstMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sgstMinor => $composableBuilder(
    column: $table.sgstMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get igstMinor => $composableBuilder(
    column: $table.igstMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cessMinor => $composableBuilder(
    column: $table.cessMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundingMinor => $composableBuilder(
    column: $table.roundingMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arithmeticStatus => $composableBuilder(
    column: $table.arithmeticStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstEligibilityStatus => $composableBuilder(
    column: $table.gstEligibilityStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceLinesRefs(
    Expression<bool> Function($$InvoiceLinesTableFilterComposer f) f,
  ) {
    final $$InvoiceLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceLines,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceLinesTableFilterComposer(
            $db: $db,
            $table: $db.invoiceLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentAllocationsRefs(
    Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f,
  ) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAllocations,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierGstin => $composableBuilder(
    column: $table.supplierGstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientGstin => $composableBuilder(
    column: $table.recipientGstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorName => $composableBuilder(
    column: $table.vendorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxableMinor => $composableBuilder(
    column: $table.taxableMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cgstMinor => $composableBuilder(
    column: $table.cgstMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sgstMinor => $composableBuilder(
    column: $table.sgstMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get igstMinor => $composableBuilder(
    column: $table.igstMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cessMinor => $composableBuilder(
    column: $table.cessMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundingMinor => $composableBuilder(
    column: $table.roundingMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arithmeticStatus => $composableBuilder(
    column: $table.arithmeticStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstEligibilityStatus => $composableBuilder(
    column: $table.gstEligibilityStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get supplierGstin => $composableBuilder(
    column: $table.supplierGstin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipientGstin => $composableBuilder(
    column: $table.recipientGstin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vendorName => $composableBuilder(
    column: $table.vendorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get taxableMinor => $composableBuilder(
    column: $table.taxableMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cgstMinor =>
      $composableBuilder(column: $table.cgstMinor, builder: (column) => column);

  GeneratedColumn<int> get sgstMinor =>
      $composableBuilder(column: $table.sgstMinor, builder: (column) => column);

  GeneratedColumn<int> get igstMinor =>
      $composableBuilder(column: $table.igstMinor, builder: (column) => column);

  GeneratedColumn<int> get cessMinor =>
      $composableBuilder(column: $table.cessMinor, builder: (column) => column);

  GeneratedColumn<int> get roundingMinor => $composableBuilder(
    column: $table.roundingMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arithmeticStatus => $composableBuilder(
    column: $table.arithmeticStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstEligibilityStatus => $composableBuilder(
    column: $table.gstEligibilityStatus,
    builder: (column) => column,
  );

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceLinesRefs<T extends Object>(
    Expression<T> Function($$InvoiceLinesTableAnnotationComposer a) f,
  ) {
    final $$InvoiceLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceLines,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
    Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentAllocations,
          getReferencedColumn: (t) => t.invoiceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({
            bool documentId,
            bool invoiceLinesRefs,
            bool paymentAllocationsRefs,
          })
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> documentId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> supplierGstin = const Value.absent(),
                Value<String?> recipientGstin = const Value.absent(),
                Value<String> vendorName = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<DateTime> invoiceDate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> taxableMinor = const Value.absent(),
                Value<int> cgstMinor = const Value.absent(),
                Value<int> sgstMinor = const Value.absent(),
                Value<int> igstMinor = const Value.absent(),
                Value<int> cessMinor = const Value.absent(),
                Value<int> roundingMinor = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<String> arithmeticStatus = const Value.absent(),
                Value<String> gstEligibilityStatus = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                documentId: documentId,
                kind: kind,
                supplierGstin: supplierGstin,
                recipientGstin: recipientGstin,
                vendorName: vendorName,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                currency: currency,
                taxableMinor: taxableMinor,
                cgstMinor: cgstMinor,
                sgstMinor: sgstMinor,
                igstMinor: igstMinor,
                cessMinor: cessMinor,
                roundingMinor: roundingMinor,
                totalMinor: totalMinor,
                arithmeticStatus: arithmeticStatus,
                gstEligibilityStatus: gstEligibilityStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int documentId,
                Value<String> kind = const Value.absent(),
                Value<String?> supplierGstin = const Value.absent(),
                Value<String?> recipientGstin = const Value.absent(),
                required String vendorName,
                required String invoiceNumber,
                required DateTime invoiceDate,
                Value<String> currency = const Value.absent(),
                required int taxableMinor,
                Value<int> cgstMinor = const Value.absent(),
                Value<int> sgstMinor = const Value.absent(),
                Value<int> igstMinor = const Value.absent(),
                Value<int> cessMinor = const Value.absent(),
                Value<int> roundingMinor = const Value.absent(),
                required int totalMinor,
                Value<String> arithmeticStatus = const Value.absent(),
                Value<String> gstEligibilityStatus = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                documentId: documentId,
                kind: kind,
                supplierGstin: supplierGstin,
                recipientGstin: recipientGstin,
                vendorName: vendorName,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                currency: currency,
                taxableMinor: taxableMinor,
                cgstMinor: cgstMinor,
                sgstMinor: sgstMinor,
                igstMinor: igstMinor,
                cessMinor: cessMinor,
                roundingMinor: roundingMinor,
                totalMinor: totalMinor,
                arithmeticStatus: arithmeticStatus,
                gstEligibilityStatus: gstEligibilityStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoicesTable, Invoice>(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                documentId = false,
                invoiceLinesRefs = false,
                paymentAllocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceLinesRefs) db.invoiceLines,
                    if (paymentAllocationsRefs) db.paymentAllocations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (documentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.documentId,
                            referencedTable: $$InvoicesTableReferences
                                ._documentIdTable(db),
                            referencedColumn: $$InvoicesTableReferences
                                ._documentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceLinesRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceLine
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentAllocationsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          PaymentAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._paymentAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({
        bool documentId,
        bool invoiceLinesRefs,
        bool paymentAllocationsRefs,
      })
    >;
typedef $$InvoiceLinesTableCreateCompanionBuilder =
    InvoiceLinesCompanion Function({
      Value<int> id,
      required int invoiceId,
      required int lineNumber,
      required String description,
      Value<String?> hsnSac,
      required int taxRateBps,
      required int taxableMinor,
      Value<int> cgstMinor,
      Value<int> sgstMinor,
      Value<int> igstMinor,
      Value<int> cessMinor,
      required int totalMinor,
    });
typedef $$InvoiceLinesTableUpdateCompanionBuilder =
    InvoiceLinesCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<int> lineNumber,
      Value<String> description,
      Value<String?> hsnSac,
      Value<int> taxRateBps,
      Value<int> taxableMinor,
      Value<int> cgstMinor,
      Value<int> sgstMinor,
      Value<int> igstMinor,
      Value<int> cessMinor,
      Value<int> totalMinor,
    });

final class $$InvoiceLinesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceLinesTable, InvoiceLine> {
  $$InvoiceLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('invoice_lines__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceLinesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableFilterComposer({
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

  ColumnFilters<int> get lineNumber => $composableBuilder(
    column: $table.lineNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnSac => $composableBuilder(
    column: $table.hsnSac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxRateBps => $composableBuilder(
    column: $table.taxRateBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxableMinor => $composableBuilder(
    column: $table.taxableMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cgstMinor => $composableBuilder(
    column: $table.cgstMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sgstMinor => $composableBuilder(
    column: $table.sgstMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get igstMinor => $composableBuilder(
    column: $table.igstMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cessMinor => $composableBuilder(
    column: $table.cessMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableOrderingComposer({
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

  ColumnOrderings<int> get lineNumber => $composableBuilder(
    column: $table.lineNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnSac => $composableBuilder(
    column: $table.hsnSac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxRateBps => $composableBuilder(
    column: $table.taxRateBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxableMinor => $composableBuilder(
    column: $table.taxableMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cgstMinor => $composableBuilder(
    column: $table.cgstMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sgstMinor => $composableBuilder(
    column: $table.sgstMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get igstMinor => $composableBuilder(
    column: $table.igstMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cessMinor => $composableBuilder(
    column: $table.cessMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lineNumber => $composableBuilder(
    column: $table.lineNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnSac =>
      $composableBuilder(column: $table.hsnSac, builder: (column) => column);

  GeneratedColumn<int> get taxRateBps => $composableBuilder(
    column: $table.taxRateBps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxableMinor => $composableBuilder(
    column: $table.taxableMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cgstMinor =>
      $composableBuilder(column: $table.cgstMinor, builder: (column) => column);

  GeneratedColumn<int> get sgstMinor =>
      $composableBuilder(column: $table.sgstMinor, builder: (column) => column);

  GeneratedColumn<int> get igstMinor =>
      $composableBuilder(column: $table.igstMinor, builder: (column) => column);

  GeneratedColumn<int> get cessMinor =>
      $composableBuilder(column: $table.cessMinor, builder: (column) => column);

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceLinesTable,
          InvoiceLine,
          $$InvoiceLinesTableFilterComposer,
          $$InvoiceLinesTableOrderingComposer,
          $$InvoiceLinesTableAnnotationComposer,
          $$InvoiceLinesTableCreateCompanionBuilder,
          $$InvoiceLinesTableUpdateCompanionBuilder,
          (InvoiceLine, $$InvoiceLinesTableReferences),
          InvoiceLine,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoiceLinesTableTableManager(_$AppDatabase db, $InvoiceLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<int> lineNumber = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> hsnSac = const Value.absent(),
                Value<int> taxRateBps = const Value.absent(),
                Value<int> taxableMinor = const Value.absent(),
                Value<int> cgstMinor = const Value.absent(),
                Value<int> sgstMinor = const Value.absent(),
                Value<int> igstMinor = const Value.absent(),
                Value<int> cessMinor = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
              }) => InvoiceLinesCompanion(
                id: id,
                invoiceId: invoiceId,
                lineNumber: lineNumber,
                description: description,
                hsnSac: hsnSac,
                taxRateBps: taxRateBps,
                taxableMinor: taxableMinor,
                cgstMinor: cgstMinor,
                sgstMinor: sgstMinor,
                igstMinor: igstMinor,
                cessMinor: cessMinor,
                totalMinor: totalMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                required int lineNumber,
                required String description,
                Value<String?> hsnSac = const Value.absent(),
                required int taxRateBps,
                required int taxableMinor,
                Value<int> cgstMinor = const Value.absent(),
                Value<int> sgstMinor = const Value.absent(),
                Value<int> igstMinor = const Value.absent(),
                Value<int> cessMinor = const Value.absent(),
                required int totalMinor,
              }) => InvoiceLinesCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                lineNumber: lineNumber,
                description: description,
                hsnSac: hsnSac,
                taxRateBps: taxRateBps,
                taxableMinor: taxableMinor,
                cgstMinor: cgstMinor,
                sgstMinor: sgstMinor,
                igstMinor: igstMinor,
                cessMinor: cessMinor,
                totalMinor: totalMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoiceLinesTable, InvoiceLine>(table),
                  $$InvoiceLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.invoiceId,
                        referencedTable: $$InvoiceLinesTableReferences
                            ._invoiceIdTable(db),
                        referencedColumn: $$InvoiceLinesTableReferences
                            ._invoiceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceLinesTable,
      InvoiceLine,
      $$InvoiceLinesTableFilterComposer,
      $$InvoiceLinesTableOrderingComposer,
      $$InvoiceLinesTableAnnotationComposer,
      $$InvoiceLinesTableCreateCompanionBuilder,
      $$InvoiceLinesTableUpdateCompanionBuilder,
      (InvoiceLine, $$InvoiceLinesTableReferences),
      InvoiceLine,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$SourceEventsTableCreateCompanionBuilder =
    SourceEventsCompanion Function({
      Value<int> id,
      required String source,
      required int sourceAccountId,
      required String externalId,
      required String contentHash,
      required DateTime receivedAt,
      Value<int?> importJobId,
      Value<int?> transactionId,
      Value<String?> encryptedEvidenceRef,
      required String payloadJson,
    });
typedef $$SourceEventsTableUpdateCompanionBuilder =
    SourceEventsCompanion Function({
      Value<int> id,
      Value<String> source,
      Value<int> sourceAccountId,
      Value<String> externalId,
      Value<String> contentHash,
      Value<DateTime> receivedAt,
      Value<int?> importJobId,
      Value<int?> transactionId,
      Value<String?> encryptedEvidenceRef,
      Value<String> payloadJson,
    });

final class $$SourceEventsTableReferences
    extends BaseReferences<_$AppDatabase, $SourceEventsTable, SourceEvent> {
  $$SourceEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _sourceAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('source_events__source_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get sourceAccountId {
    final $_column = $_itemColumn<int>('source_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ImportJobsTable _importJobIdTable(_$AppDatabase db) => db.importJobs
      .createAlias('source_events__import_job_id__import_jobs__id');

  $$ImportJobsTableProcessedTableManager? get importJobId {
    final $_column = $_itemColumn<int>('import_job_id');
    if ($_column == null) return null;
    final manager = $$ImportJobsTableTableManager(
      $_db,
      $_db.importJobs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_importJobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('source_events__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SourceEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SourceEventsTable> {
  $$SourceEventsTableFilterComposer({
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

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedEvidenceRef => $composableBuilder(
    column: $table.encryptedEvidenceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get sourceAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportJobsTableFilterComposer get importJobId {
    final $$ImportJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importJobId,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableFilterComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceEventsTable> {
  $$SourceEventsTableOrderingComposer({
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedEvidenceRef => $composableBuilder(
    column: $table.encryptedEvidenceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get sourceAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportJobsTableOrderingComposer get importJobId {
    final $$ImportJobsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importJobId,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableOrderingComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceEventsTable> {
  $$SourceEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encryptedEvidenceRef => $composableBuilder(
    column: $table.encryptedEvidenceRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get sourceAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportJobsTableAnnotationComposer get importJobId {
    final $$ImportJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importJobId,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceEventsTable,
          SourceEvent,
          $$SourceEventsTableFilterComposer,
          $$SourceEventsTableOrderingComposer,
          $$SourceEventsTableAnnotationComposer,
          $$SourceEventsTableCreateCompanionBuilder,
          $$SourceEventsTableUpdateCompanionBuilder,
          (SourceEvent, $$SourceEventsTableReferences),
          SourceEvent,
          PrefetchHooks Function({
            bool sourceAccountId,
            bool importJobId,
            bool transactionId,
          })
        > {
  $$SourceEventsTableTableManager(_$AppDatabase db, $SourceEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> sourceAccountId = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<int?> importJobId = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<String?> encryptedEvidenceRef = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => SourceEventsCompanion(
                id: id,
                source: source,
                sourceAccountId: sourceAccountId,
                externalId: externalId,
                contentHash: contentHash,
                receivedAt: receivedAt,
                importJobId: importJobId,
                transactionId: transactionId,
                encryptedEvidenceRef: encryptedEvidenceRef,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String source,
                required int sourceAccountId,
                required String externalId,
                required String contentHash,
                required DateTime receivedAt,
                Value<int?> importJobId = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<String?> encryptedEvidenceRef = const Value.absent(),
                required String payloadJson,
              }) => SourceEventsCompanion.insert(
                id: id,
                source: source,
                sourceAccountId: sourceAccountId,
                externalId: externalId,
                contentHash: contentHash,
                receivedAt: receivedAt,
                importJobId: importJobId,
                transactionId: transactionId,
                encryptedEvidenceRef: encryptedEvidenceRef,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceEventsTable, SourceEvent>(table),
                  $$SourceEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sourceAccountId = false,
                importJobId = false,
                transactionId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceAccountId,
                            referencedTable: $$SourceEventsTableReferences
                                ._sourceAccountIdTable(db),
                            referencedColumn: $$SourceEventsTableReferences
                                ._sourceAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (importJobId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.importJobId,
                            referencedTable: $$SourceEventsTableReferences
                                ._importJobIdTable(db),
                            referencedColumn: $$SourceEventsTableReferences
                                ._importJobIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$SourceEventsTableReferences
                                ._transactionIdTable(db),
                            referencedColumn: $$SourceEventsTableReferences
                                ._transactionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SourceEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceEventsTable,
      SourceEvent,
      $$SourceEventsTableFilterComposer,
      $$SourceEventsTableOrderingComposer,
      $$SourceEventsTableAnnotationComposer,
      $$SourceEventsTableCreateCompanionBuilder,
      $$SourceEventsTableUpdateCompanionBuilder,
      (SourceEvent, $$SourceEventsTableReferences),
      SourceEvent,
      PrefetchHooks Function({
        bool sourceAccountId,
        bool importJobId,
        bool transactionId,
      })
    >;
typedef $$ClassificationsTableCreateCompanionBuilder =
    ClassificationsCompanion Function({
      Value<int> id,
      required int transactionId,
      Value<int?> suggestedCategoryId,
      Value<int?> confirmedCategoryId,
      required int businessUseBps,
      Value<String?> businessPurpose,
      required String provenance,
      Value<String> gstEligibilityStatus,
      Value<DateTime> updatedAt,
    });
typedef $$ClassificationsTableUpdateCompanionBuilder =
    ClassificationsCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<int?> suggestedCategoryId,
      Value<int?> confirmedCategoryId,
      Value<int> businessUseBps,
      Value<String?> businessPurpose,
      Value<String> provenance,
      Value<String> gstEligibilityStatus,
      Value<DateTime> updatedAt,
    });

final class $$ClassificationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ClassificationsTable, Classification> {
  $$ClassificationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('classifications__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _suggestedCategoryIdTable(_$AppDatabase db) => db
      .categories
      .createAlias('classifications__suggested_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get suggestedCategoryId {
    final $_column = $_itemColumn<int>('suggested_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_suggestedCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _confirmedCategoryIdTable(_$AppDatabase db) => db
      .categories
      .createAlias('classifications__confirmed_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get confirmedCategoryId {
    final $_column = $_itemColumn<int>('confirmed_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_confirmedCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClassificationsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassificationsTable> {
  $$ClassificationsTableFilterComposer({
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

  ColumnFilters<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessPurpose => $composableBuilder(
    column: $table.businessPurpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstEligibilityStatus => $composableBuilder(
    column: $table.gstEligibilityStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get suggestedCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.suggestedCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get confirmedCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.confirmedCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassificationsTable> {
  $$ClassificationsTableOrderingComposer({
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

  ColumnOrderings<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessPurpose => $composableBuilder(
    column: $table.businessPurpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstEligibilityStatus => $composableBuilder(
    column: $table.gstEligibilityStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get suggestedCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.suggestedCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get confirmedCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.confirmedCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassificationsTable> {
  $$ClassificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessPurpose => $composableBuilder(
    column: $table.businessPurpose,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gstEligibilityStatus => $composableBuilder(
    column: $table.gstEligibilityStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get suggestedCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.suggestedCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get confirmedCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.confirmedCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassificationsTable,
          Classification,
          $$ClassificationsTableFilterComposer,
          $$ClassificationsTableOrderingComposer,
          $$ClassificationsTableAnnotationComposer,
          $$ClassificationsTableCreateCompanionBuilder,
          $$ClassificationsTableUpdateCompanionBuilder,
          (Classification, $$ClassificationsTableReferences),
          Classification,
          PrefetchHooks Function({
            bool transactionId,
            bool suggestedCategoryId,
            bool confirmedCategoryId,
          })
        > {
  $$ClassificationsTableTableManager(
    _$AppDatabase db,
    $ClassificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int?> suggestedCategoryId = const Value.absent(),
                Value<int?> confirmedCategoryId = const Value.absent(),
                Value<int> businessUseBps = const Value.absent(),
                Value<String?> businessPurpose = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<String> gstEligibilityStatus = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClassificationsCompanion(
                id: id,
                transactionId: transactionId,
                suggestedCategoryId: suggestedCategoryId,
                confirmedCategoryId: confirmedCategoryId,
                businessUseBps: businessUseBps,
                businessPurpose: businessPurpose,
                provenance: provenance,
                gstEligibilityStatus: gstEligibilityStatus,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                Value<int?> suggestedCategoryId = const Value.absent(),
                Value<int?> confirmedCategoryId = const Value.absent(),
                required int businessUseBps,
                Value<String?> businessPurpose = const Value.absent(),
                required String provenance,
                Value<String> gstEligibilityStatus = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClassificationsCompanion.insert(
                id: id,
                transactionId: transactionId,
                suggestedCategoryId: suggestedCategoryId,
                confirmedCategoryId: confirmedCategoryId,
                businessUseBps: businessUseBps,
                businessPurpose: businessPurpose,
                provenance: provenance,
                gstEligibilityStatus: gstEligibilityStatus,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClassificationsTable, Classification>(table),
                  $$ClassificationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionId = false,
                suggestedCategoryId = false,
                confirmedCategoryId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$ClassificationsTableReferences
                                ._transactionIdTable(db),
                            referencedColumn: $$ClassificationsTableReferences
                                ._transactionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (suggestedCategoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.suggestedCategoryId,
                            referencedTable: $$ClassificationsTableReferences
                                ._suggestedCategoryIdTable(db),
                            referencedColumn: $$ClassificationsTableReferences
                                ._suggestedCategoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (confirmedCategoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.confirmedCategoryId,
                            referencedTable: $$ClassificationsTableReferences
                                ._confirmedCategoryIdTable(db),
                            referencedColumn: $$ClassificationsTableReferences
                                ._confirmedCategoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ClassificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassificationsTable,
      Classification,
      $$ClassificationsTableFilterComposer,
      $$ClassificationsTableOrderingComposer,
      $$ClassificationsTableAnnotationComposer,
      $$ClassificationsTableCreateCompanionBuilder,
      $$ClassificationsTableUpdateCompanionBuilder,
      (Classification, $$ClassificationsTableReferences),
      Classification,
      PrefetchHooks Function({
        bool transactionId,
        bool suggestedCategoryId,
        bool confirmedCategoryId,
      })
    >;
typedef $$BusinessRulesTableCreateCompanionBuilder =
    BusinessRulesCompanion Function({
      Value<int> id,
      required String merchantPattern,
      required int businessUseBps,
      Value<String> provenance,
      Value<DateTime> createdAt,
    });
typedef $$BusinessRulesTableUpdateCompanionBuilder =
    BusinessRulesCompanion Function({
      Value<int> id,
      Value<String> merchantPattern,
      Value<int> businessUseBps,
      Value<String> provenance,
      Value<DateTime> createdAt,
    });

class $$BusinessRulesTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessRulesTable> {
  $$BusinessRulesTableFilterComposer({
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

  ColumnFilters<String> get merchantPattern => $composableBuilder(
    column: $table.merchantPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessRulesTable> {
  $$BusinessRulesTableOrderingComposer({
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

  ColumnOrderings<String> get merchantPattern => $composableBuilder(
    column: $table.merchantPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessRulesTable> {
  $$BusinessRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get merchantPattern => $composableBuilder(
    column: $table.merchantPattern,
    builder: (column) => column,
  );

  GeneratedColumn<int> get businessUseBps => $composableBuilder(
    column: $table.businessUseBps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BusinessRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessRulesTable,
          BusinessRule,
          $$BusinessRulesTableFilterComposer,
          $$BusinessRulesTableOrderingComposer,
          $$BusinessRulesTableAnnotationComposer,
          $$BusinessRulesTableCreateCompanionBuilder,
          $$BusinessRulesTableUpdateCompanionBuilder,
          (
            BusinessRule,
            BaseReferences<_$AppDatabase, $BusinessRulesTable, BusinessRule>,
          ),
          BusinessRule,
          PrefetchHooks Function()
        > {
  $$BusinessRulesTableTableManager(_$AppDatabase db, $BusinessRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> merchantPattern = const Value.absent(),
                Value<int> businessUseBps = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BusinessRulesCompanion(
                id: id,
                merchantPattern: merchantPattern,
                businessUseBps: businessUseBps,
                provenance: provenance,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String merchantPattern,
                required int businessUseBps,
                Value<String> provenance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BusinessRulesCompanion.insert(
                id: id,
                merchantPattern: merchantPattern,
                businessUseBps: businessUseBps,
                provenance: provenance,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BusinessRulesTable, BusinessRule>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BusinessRulesTable,
                    BusinessRule
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessRulesTable,
      BusinessRule,
      $$BusinessRulesTableFilterComposer,
      $$BusinessRulesTableOrderingComposer,
      $$BusinessRulesTableAnnotationComposer,
      $$BusinessRulesTableCreateCompanionBuilder,
      $$BusinessRulesTableUpdateCompanionBuilder,
      (
        BusinessRule,
        BaseReferences<_$AppDatabase, $BusinessRulesTable, BusinessRule>,
      ),
      BusinessRule,
      PrefetchHooks Function()
    >;
typedef $$PaymentAllocationsTableCreateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      Value<int> id,
      required int transactionId,
      required int invoiceId,
      required String kind,
      required int allocatedMinor,
      Value<String> currency,
      Value<String> provenance,
      Value<DateTime> createdAt,
    });
typedef $$PaymentAllocationsTableUpdateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<int> invoiceId,
      Value<String> kind,
      Value<int> allocatedMinor,
      Value<String> currency,
      Value<String> provenance,
      Value<DateTime> createdAt,
    });

final class $$PaymentAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation
        > {
  $$PaymentAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('payment_allocations__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('payment_allocations__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allocatedMinor => $composableBuilder(
    column: $table.allocatedMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocatedMinor => $composableBuilder(
    column: $table.allocatedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get allocatedMinor => $composableBuilder(
    column: $table.allocatedMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation,
          $$PaymentAllocationsTableFilterComposer,
          $$PaymentAllocationsTableOrderingComposer,
          $$PaymentAllocationsTableAnnotationComposer,
          $$PaymentAllocationsTableCreateCompanionBuilder,
          $$PaymentAllocationsTableUpdateCompanionBuilder,
          (PaymentAllocation, $$PaymentAllocationsTableReferences),
          PaymentAllocation,
          PrefetchHooks Function({bool transactionId, bool invoiceId})
        > {
  $$PaymentAllocationsTableTableManager(
    _$AppDatabase db,
    $PaymentAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> allocatedMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentAllocationsCompanion(
                id: id,
                transactionId: transactionId,
                invoiceId: invoiceId,
                kind: kind,
                allocatedMinor: allocatedMinor,
                currency: currency,
                provenance: provenance,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                required int invoiceId,
                required String kind,
                required int allocatedMinor,
                Value<String> currency = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentAllocationsCompanion.insert(
                id: id,
                transactionId: transactionId,
                invoiceId: invoiceId,
                kind: kind,
                allocatedMinor: allocatedMinor,
                currency: currency,
                provenance: provenance,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentAllocationsTable, PaymentAllocation>(
                    table,
                  ),
                  $$PaymentAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false, invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$PaymentAllocationsTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$PaymentAllocationsTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (invoiceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.invoiceId,
                        referencedTable: $$PaymentAllocationsTableReferences
                            ._invoiceIdTable(db),
                        referencedColumn: $$PaymentAllocationsTableReferences
                            ._invoiceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentAllocationsTable,
      PaymentAllocation,
      $$PaymentAllocationsTableFilterComposer,
      $$PaymentAllocationsTableOrderingComposer,
      $$PaymentAllocationsTableAnnotationComposer,
      $$PaymentAllocationsTableCreateCompanionBuilder,
      $$PaymentAllocationsTableUpdateCompanionBuilder,
      (PaymentAllocation, $$PaymentAllocationsTableReferences),
      PaymentAllocation,
      PrefetchHooks Function({bool transactionId, bool invoiceId})
    >;
typedef $$ReviewEventsTableCreateCompanionBuilder =
    ReviewEventsCompanion Function({
      Value<int> id,
      required String entityType,
      required int entityId,
      required String action,
      required String beforeJson,
      required String afterJson,
      Value<String> provenance,
      Value<DateTime> timestamp,
    });
typedef $$ReviewEventsTableUpdateCompanionBuilder =
    ReviewEventsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int> entityId,
      Value<String> action,
      Value<String> beforeJson,
      Value<String> afterJson,
      Value<String> provenance,
      Value<DateTime> timestamp,
    });

class $$ReviewEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewEventsTable> {
  $$ReviewEventsTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewEventsTable> {
  $$ReviewEventsTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewEventsTable> {
  $$ReviewEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterJson =>
      $composableBuilder(column: $table.afterJson, builder: (column) => column);

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ReviewEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewEventsTable,
          ReviewEvent,
          $$ReviewEventsTableFilterComposer,
          $$ReviewEventsTableOrderingComposer,
          $$ReviewEventsTableAnnotationComposer,
          $$ReviewEventsTableCreateCompanionBuilder,
          $$ReviewEventsTableUpdateCompanionBuilder,
          (
            ReviewEvent,
            BaseReferences<_$AppDatabase, $ReviewEventsTable, ReviewEvent>,
          ),
          ReviewEvent,
          PrefetchHooks Function()
        > {
  $$ReviewEventsTableTableManager(_$AppDatabase db, $ReviewEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> beforeJson = const Value.absent(),
                Value<String> afterJson = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ReviewEventsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                action: action,
                beforeJson: beforeJson,
                afterJson: afterJson,
                provenance: provenance,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required int entityId,
                required String action,
                required String beforeJson,
                required String afterJson,
                Value<String> provenance = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ReviewEventsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                action: action,
                beforeJson: beforeJson,
                afterJson: afterJson,
                provenance: provenance,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewEventsTable, ReviewEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReviewEventsTable,
                    ReviewEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewEventsTable,
      ReviewEvent,
      $$ReviewEventsTableFilterComposer,
      $$ReviewEventsTableOrderingComposer,
      $$ReviewEventsTableAnnotationComposer,
      $$ReviewEventsTableCreateCompanionBuilder,
      $$ReviewEventsTableUpdateCompanionBuilder,
      (
        ReviewEvent,
        BaseReferences<_$AppDatabase, $ReviewEventsTable, ReviewEvent>,
      ),
      ReviewEvent,
      PrefetchHooks Function()
    >;
typedef $$ExportRunsTableCreateCompanionBuilder = ExportRunsCompanion Function({
  Value<int> id,
  required DateTime periodStart,
  required DateTime periodEnd,
  required int formatVersion,
  required int includedCount,
  required String manifestSha256,
  Value<DateTime> createdAt,
});
typedef $$ExportRunsTableUpdateCompanionBuilder = ExportRunsCompanion Function({
  Value<int> id,
  Value<DateTime> periodStart,
  Value<DateTime> periodEnd,
  Value<int> formatVersion,
  Value<int> includedCount,
  Value<String> manifestSha256,
  Value<DateTime> createdAt,
});

final class $$ExportRunsTableReferences
    extends BaseReferences<_$AppDatabase, $ExportRunsTable, ExportRun> {
  $$ExportRunsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExportItemsTable, List<ExportItem>>
  _exportItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exportItems,
    aliasName: 'export_runs__id__export_items__export_run_id',
  );

  $$ExportItemsTableProcessedTableManager get exportItemsRefs {
    final manager = $$ExportItemsTableTableManager(
      $_db,
      $_db.exportItems,
    ).filter((f) => f.exportRunId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exportItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExportRunsTableFilterComposer
    extends Composer<_$AppDatabase, $ExportRunsTable> {
  $$ExportRunsTableFilterComposer({
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

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get formatVersion => $composableBuilder(
    column: $table.formatVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get includedCount => $composableBuilder(
    column: $table.includedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manifestSha256 => $composableBuilder(
    column: $table.manifestSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exportItemsRefs(
    Expression<bool> Function($$ExportItemsTableFilterComposer f) f,
  ) {
    final $$ExportItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exportItems,
      getReferencedColumn: (t) => t.exportRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportItemsTableFilterComposer(
            $db: $db,
            $table: $db.exportItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExportRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExportRunsTable> {
  $$ExportRunsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get formatVersion => $composableBuilder(
    column: $table.formatVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get includedCount => $composableBuilder(
    column: $table.includedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manifestSha256 => $composableBuilder(
    column: $table.manifestSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExportRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExportRunsTable> {
  $$ExportRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<int> get formatVersion => $composableBuilder(
    column: $table.formatVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get includedCount => $composableBuilder(
    column: $table.includedCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manifestSha256 => $composableBuilder(
    column: $table.manifestSha256,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> exportItemsRefs<T extends Object>(
    Expression<T> Function($$ExportItemsTableAnnotationComposer a) f,
  ) {
    final $$ExportItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exportItems,
      getReferencedColumn: (t) => t.exportRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.exportItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExportRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExportRunsTable,
          ExportRun,
          $$ExportRunsTableFilterComposer,
          $$ExportRunsTableOrderingComposer,
          $$ExportRunsTableAnnotationComposer,
          $$ExportRunsTableCreateCompanionBuilder,
          $$ExportRunsTableUpdateCompanionBuilder,
          (ExportRun, $$ExportRunsTableReferences),
          ExportRun,
          PrefetchHooks Function({bool exportItemsRefs})
        > {
  $$ExportRunsTableTableManager(_$AppDatabase db, $ExportRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExportRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExportRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExportRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> periodStart = const Value.absent(),
                Value<DateTime> periodEnd = const Value.absent(),
                Value<int> formatVersion = const Value.absent(),
                Value<int> includedCount = const Value.absent(),
                Value<String> manifestSha256 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExportRunsCompanion(
                id: id,
                periodStart: periodStart,
                periodEnd: periodEnd,
                formatVersion: formatVersion,
                includedCount: includedCount,
                manifestSha256: manifestSha256,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime periodStart,
                required DateTime periodEnd,
                required int formatVersion,
                required int includedCount,
                required String manifestSha256,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExportRunsCompanion.insert(
                id: id,
                periodStart: periodStart,
                periodEnd: periodEnd,
                formatVersion: formatVersion,
                includedCount: includedCount,
                manifestSha256: manifestSha256,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExportRunsTable, ExportRun>(table),
                  $$ExportRunsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exportItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exportItemsRefs) db.exportItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exportItemsRefs)
                    await $_getPrefetchedData<
                      ExportRun,
                      $ExportRunsTable,
                      ExportItem
                    >(
                      currentTable: table,
                      referencedTable: $$ExportRunsTableReferences
                          ._exportItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExportRunsTableReferences(
                            db,
                            table,
                            p0,
                          ).exportItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.exportRunId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExportRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExportRunsTable,
      ExportRun,
      $$ExportRunsTableFilterComposer,
      $$ExportRunsTableOrderingComposer,
      $$ExportRunsTableAnnotationComposer,
      $$ExportRunsTableCreateCompanionBuilder,
      $$ExportRunsTableUpdateCompanionBuilder,
      (ExportRun, $$ExportRunsTableReferences),
      ExportRun,
      PrefetchHooks Function({bool exportItemsRefs})
    >;
typedef $$ExportItemsTableCreateCompanionBuilder =
    ExportItemsCompanion Function({
      Value<int> id,
      required int exportRunId,
      required String entityType,
      required int entityId,
      required String snapshotJson,
      required String contentHash,
    });
typedef $$ExportItemsTableUpdateCompanionBuilder =
    ExportItemsCompanion Function({
      Value<int> id,
      Value<int> exportRunId,
      Value<String> entityType,
      Value<int> entityId,
      Value<String> snapshotJson,
      Value<String> contentHash,
    });

final class $$ExportItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ExportItemsTable, ExportItem> {
  $$ExportItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExportRunsTable _exportRunIdTable(_$AppDatabase db) =>
      db.exportRuns.createAlias('export_items__export_run_id__export_runs__id');

  $$ExportRunsTableProcessedTableManager get exportRunId {
    final $_column = $_itemColumn<int>('export_run_id')!;

    final manager = $$ExportRunsTableTableManager(
      $_db,
      $_db.exportRuns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exportRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExportItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ExportItemsTable> {
  $$ExportItemsTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  $$ExportRunsTableFilterComposer get exportRunId {
    final $$ExportRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exportRunId,
      referencedTable: $db.exportRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportRunsTableFilterComposer(
            $db: $db,
            $table: $db.exportRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExportItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExportItemsTable> {
  $$ExportItemsTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExportRunsTableOrderingComposer get exportRunId {
    final $$ExportRunsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exportRunId,
      referencedTable: $db.exportRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportRunsTableOrderingComposer(
            $db: $db,
            $table: $db.exportRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExportItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExportItemsTable> {
  $$ExportItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  $$ExportRunsTableAnnotationComposer get exportRunId {
    final $$ExportRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exportRunId,
      referencedTable: $db.exportRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.exportRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExportItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExportItemsTable,
          ExportItem,
          $$ExportItemsTableFilterComposer,
          $$ExportItemsTableOrderingComposer,
          $$ExportItemsTableAnnotationComposer,
          $$ExportItemsTableCreateCompanionBuilder,
          $$ExportItemsTableUpdateCompanionBuilder,
          (ExportItem, $$ExportItemsTableReferences),
          ExportItem,
          PrefetchHooks Function({bool exportRunId})
        > {
  $$ExportItemsTableTableManager(_$AppDatabase db, $ExportItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExportItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExportItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExportItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exportRunId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> snapshotJson = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
              }) => ExportItemsCompanion(
                id: id,
                exportRunId: exportRunId,
                entityType: entityType,
                entityId: entityId,
                snapshotJson: snapshotJson,
                contentHash: contentHash,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exportRunId,
                required String entityType,
                required int entityId,
                required String snapshotJson,
                required String contentHash,
              }) => ExportItemsCompanion.insert(
                id: id,
                exportRunId: exportRunId,
                entityType: entityType,
                entityId: entityId,
                snapshotJson: snapshotJson,
                contentHash: contentHash,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExportItemsTable, ExportItem>(table),
                  $$ExportItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exportRunId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (exportRunId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exportRunId,
                        referencedTable: $$ExportItemsTableReferences
                            ._exportRunIdTable(db),
                        referencedColumn: $$ExportItemsTableReferences
                            ._exportRunIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExportItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExportItemsTable,
      ExportItem,
      $$ExportItemsTableFilterComposer,
      $$ExportItemsTableOrderingComposer,
      $$ExportItemsTableAnnotationComposer,
      $$ExportItemsTableCreateCompanionBuilder,
      $$ExportItemsTableUpdateCompanionBuilder,
      (ExportItem, $$ExportItemsTableReferences),
      ExportItem,
      PrefetchHooks Function({bool exportRunId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$RawMessagesTableTableManager get rawMessages =>
      $$RawMessagesTableTableManager(_db, _db.rawMessages);
  $$MerchantRulesTableTableManager get merchantRules =>
      $$MerchantRulesTableTableManager(_db, _db.merchantRules);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$ImportJobsTableTableManager get importJobs =>
      $$ImportJobsTableTableManager(_db, _db.importJobs);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceLinesTableTableManager get invoiceLines =>
      $$InvoiceLinesTableTableManager(_db, _db.invoiceLines);
  $$SourceEventsTableTableManager get sourceEvents =>
      $$SourceEventsTableTableManager(_db, _db.sourceEvents);
  $$ClassificationsTableTableManager get classifications =>
      $$ClassificationsTableTableManager(_db, _db.classifications);
  $$BusinessRulesTableTableManager get businessRules =>
      $$BusinessRulesTableTableManager(_db, _db.businessRules);
  $$PaymentAllocationsTableTableManager get paymentAllocations =>
      $$PaymentAllocationsTableTableManager(_db, _db.paymentAllocations);
  $$ReviewEventsTableTableManager get reviewEvents =>
      $$ReviewEventsTableTableManager(_db, _db.reviewEvents);
  $$ExportRunsTableTableManager get exportRuns =>
      $$ExportRunsTableTableManager(_db, _db.exportRuns);
  $$ExportItemsTableTableManager get exportItems =>
      $$ExportItemsTableTableManager(_db, _db.exportItems);
}
