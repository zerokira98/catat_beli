// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_moor.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Stock extends DataClass implements Insertable<Stock> {
  final int id;
  final int price;
  final double qty;
  final DateTime? dateAdd;
  final String? note;
  final int? idItem;
  final int? idSupplier;
  const Stock(
      {required this.id,
      required this.price,
      required this.qty,
      this.dateAdd,
      this.note,
      this.idItem,
      this.idSupplier});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['price'] = Variable<int>(price);
    map['qty'] = Variable<double>(qty);
    if (!nullToAbsent || dateAdd != null) {
      map['date_add'] = Variable<DateTime>(dateAdd);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || idItem != null) {
      map['id_item'] = Variable<int>(idItem);
    }
    if (!nullToAbsent || idSupplier != null) {
      map['id_supplier'] = Variable<int>(idSupplier);
    }
    return map;
  }

  StocksCompanion toCompanion(bool nullToAbsent) {
    return StocksCompanion(
      id: Value(id),
      price: Value(price),
      qty: Value(qty),
      dateAdd: dateAdd == null && nullToAbsent
          ? const Value.absent()
          : Value(dateAdd),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      idItem:
          idItem == null && nullToAbsent ? const Value.absent() : Value(idItem),
      idSupplier: idSupplier == null && nullToAbsent
          ? const Value.absent()
          : Value(idSupplier),
    );
  }

  factory Stock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stock(
      id: serializer.fromJson<int>(json['id']),
      price: serializer.fromJson<int>(json['price']),
      qty: serializer.fromJson<double>(json['qty']),
      dateAdd: serializer.fromJson<DateTime?>(json['dateAdd']),
      note: serializer.fromJson<String?>(json['note']),
      idItem: serializer.fromJson<int?>(json['idItem']),
      idSupplier: serializer.fromJson<int?>(json['idSupplier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'price': serializer.toJson<int>(price),
      'qty': serializer.toJson<double>(qty),
      'dateAdd': serializer.toJson<DateTime?>(dateAdd),
      'note': serializer.toJson<String?>(note),
      'idItem': serializer.toJson<int?>(idItem),
      'idSupplier': serializer.toJson<int?>(idSupplier),
    };
  }

  Stock copyWith(
          {int? id,
          int? price,
          double? qty,
          Value<DateTime?> dateAdd = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<int?> idItem = const Value.absent(),
          Value<int?> idSupplier = const Value.absent()}) =>
      Stock(
        id: id ?? this.id,
        price: price ?? this.price,
        qty: qty ?? this.qty,
        dateAdd: dateAdd.present ? dateAdd.value : this.dateAdd,
        note: note.present ? note.value : this.note,
        idItem: idItem.present ? idItem.value : this.idItem,
        idSupplier: idSupplier.present ? idSupplier.value : this.idSupplier,
      );
  @override
  String toString() {
    return (StringBuffer('Stock(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('dateAdd: $dateAdd, ')
          ..write('note: $note, ')
          ..write('idItem: $idItem, ')
          ..write('idSupplier: $idSupplier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, price, qty, dateAdd, note, idItem, idSupplier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stock &&
          other.id == this.id &&
          other.price == this.price &&
          other.qty == this.qty &&
          other.dateAdd == this.dateAdd &&
          other.note == this.note &&
          other.idItem == this.idItem &&
          other.idSupplier == this.idSupplier);
}

class StocksCompanion extends UpdateCompanion<Stock> {
  final Value<int> id;
  final Value<int> price;
  final Value<double> qty;
  final Value<DateTime?> dateAdd;
  final Value<String?> note;
  final Value<int?> idItem;
  final Value<int?> idSupplier;
  const StocksCompanion({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.dateAdd = const Value.absent(),
    this.note = const Value.absent(),
    this.idItem = const Value.absent(),
    this.idSupplier = const Value.absent(),
  });
  StocksCompanion.insert({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.dateAdd = const Value.absent(),
    this.note = const Value.absent(),
    this.idItem = const Value.absent(),
    this.idSupplier = const Value.absent(),
  });
  static Insertable<Stock> custom({
    Expression<int>? id,
    Expression<int>? price,
    Expression<double>? qty,
    Expression<DateTime>? dateAdd,
    Expression<String>? note,
    Expression<int>? idItem,
    Expression<int>? idSupplier,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (price != null) 'price': price,
      if (qty != null) 'qty': qty,
      if (dateAdd != null) 'date_add': dateAdd,
      if (note != null) 'note': note,
      if (idItem != null) 'id_item': idItem,
      if (idSupplier != null) 'id_supplier': idSupplier,
    });
  }

  StocksCompanion copyWith(
      {Value<int>? id,
      Value<int>? price,
      Value<double>? qty,
      Value<DateTime?>? dateAdd,
      Value<String?>? note,
      Value<int?>? idItem,
      Value<int?>? idSupplier}) {
    return StocksCompanion(
      id: id ?? this.id,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      dateAdd: dateAdd ?? this.dateAdd,
      note: note ?? this.note,
      idItem: idItem ?? this.idItem,
      idSupplier: idSupplier ?? this.idSupplier,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (dateAdd.present) {
      map['date_add'] = Variable<DateTime>(dateAdd.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (idItem.present) {
      map['id_item'] = Variable<int>(idItem.value);
    }
    if (idSupplier.present) {
      map['id_supplier'] = Variable<int>(idSupplier.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocksCompanion(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('dateAdd: $dateAdd, ')
          ..write('note: $note, ')
          ..write('idItem: $idItem, ')
          ..write('idSupplier: $idSupplier')
          ..write(')'))
        .toString();
  }
}

class $StocksTable extends Stocks with TableInfo<$StocksTable, Stock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocksTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
      'price', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
      'qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: Constant(1.0));
  final VerificationMeta _dateAddMeta = const VerificationMeta('dateAdd');
  @override
  late final GeneratedColumn<DateTime> dateAdd = GeneratedColumn<DateTime>(
      'date_add', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _idItemMeta = const VerificationMeta('idItem');
  @override
  late final GeneratedColumn<int> idItem = GeneratedColumn<int>(
      'id_item', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES stockitems(id)');
  final VerificationMeta _idSupplierMeta = const VerificationMeta('idSupplier');
  @override
  late final GeneratedColumn<int> idSupplier = GeneratedColumn<int>(
      'id_supplier', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES tempatbelis(id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, price, qty, dateAdd, note, idItem, idSupplier];
  @override
  String get aliasedName => _alias ?? 'stocks';
  @override
  String get actualTableName => 'stocks';
  @override
  VerificationContext validateIntegrity(Insertable<Stock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    }
    if (data.containsKey('date_add')) {
      context.handle(_dateAddMeta,
          dateAdd.isAcceptableOrUnknown(data['date_add']!, _dateAddMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('id_item')) {
      context.handle(_idItemMeta,
          idItem.isAcceptableOrUnknown(data['id_item']!, _idItemMeta));
    }
    if (data.containsKey('id_supplier')) {
      context.handle(
          _idSupplierMeta,
          idSupplier.isAcceptableOrUnknown(
              data['id_supplier']!, _idSupplierMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stock(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      price: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}price'])!,
      qty: attachedDatabase.options.types
          .read(DriftSqlType.double, data['${effectivePrefix}qty'])!,
      dateAdd: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_add']),
      note: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      idItem: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_item']),
      idSupplier: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_supplier']),
    );
  }

  @override
  $StocksTable createAlias(String alias) {
    return $StocksTable(attachedDatabase, alias);
  }
}

class StockItem extends DataClass implements Insertable<StockItem> {
  final int id;
  final int? barcode;
  final String nama;
  const StockItem({required this.id, this.barcode, required this.nama});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<int>(barcode);
    }
    map['nama'] = Variable<String>(nama);
    return map;
  }

  StockItemsCompanion toCompanion(bool nullToAbsent) {
    return StockItemsCompanion(
      id: Value(id),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      nama: Value(nama),
    );
  }

  factory StockItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockItem(
      id: serializer.fromJson<int>(json['id']),
      barcode: serializer.fromJson<int?>(json['barcode']),
      nama: serializer.fromJson<String>(json['nama']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<int?>(barcode),
      'nama': serializer.toJson<String>(nama),
    };
  }

  StockItem copyWith(
          {int? id,
          Value<int?> barcode = const Value.absent(),
          String? nama}) =>
      StockItem(
        id: id ?? this.id,
        barcode: barcode.present ? barcode.value : this.barcode,
        nama: nama ?? this.nama,
      );
  @override
  String toString() {
    return (StringBuffer('StockItem(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, barcode, nama);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockItem &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.nama == this.nama);
}

class StockItemsCompanion extends UpdateCompanion<StockItem> {
  final Value<int> id;
  final Value<int?> barcode;
  final Value<String> nama;
  const StockItemsCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.nama = const Value.absent(),
  });
  StockItemsCompanion.insert({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    required String nama,
  }) : nama = Value(nama);
  static Insertable<StockItem> custom({
    Expression<int>? id,
    Expression<int>? barcode,
    Expression<String>? nama,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (nama != null) 'nama': nama,
    });
  }

  StockItemsCompanion copyWith(
      {Value<int>? id, Value<int?>? barcode, Value<String>? nama}) {
    return StockItemsCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      nama: nama ?? this.nama,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<int>(barcode.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockItemsCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }
}

class $StockItemsTable extends StockItems
    with TableInfo<$StockItemsTable, StockItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockItemsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _barcodeMeta = const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<int> barcode = GeneratedColumn<int>(
      'barcode', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama =
      GeneratedColumn<String>('nama', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 3,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, barcode, nama];
  @override
  String get aliasedName => _alias ?? 'stock_items';
  @override
  String get actualTableName => 'stock_items';
  @override
  VerificationContext validateIntegrity(Insertable<StockItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
          _namaMeta, nama.isAcceptableOrUnknown(data['nama']!, _namaMeta));
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockItem(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      barcode: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}barcode']),
      nama: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}nama'])!,
    );
  }

  @override
  $StockItemsTable createAlias(String alias) {
    return $StockItemsTable(attachedDatabase, alias);
  }
}

class TempatBeli extends DataClass implements Insertable<TempatBeli> {
  final int id;
  final String nama;
  const TempatBeli({required this.id, required this.nama});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    return map;
  }

  TempatBelisCompanion toCompanion(bool nullToAbsent) {
    return TempatBelisCompanion(
      id: Value(id),
      nama: Value(nama),
    );
  }

  factory TempatBeli.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TempatBeli(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
    };
  }

  TempatBeli copyWith({int? id, String? nama}) => TempatBeli(
        id: id ?? this.id,
        nama: nama ?? this.nama,
      );
  @override
  String toString() {
    return (StringBuffer('TempatBeli(')
          ..write('id: $id, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TempatBeli && other.id == this.id && other.nama == this.nama);
}

class TempatBelisCompanion extends UpdateCompanion<TempatBeli> {
  final Value<int> id;
  final Value<String> nama;
  const TempatBelisCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
  });
  TempatBelisCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
  }) : nama = Value(nama);
  static Insertable<TempatBeli> custom({
    Expression<int>? id,
    Expression<String>? nama,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
    });
  }

  TempatBelisCompanion copyWith({Value<int>? id, Value<String>? nama}) {
    return TempatBelisCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TempatBelisCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }
}

class $TempatBelisTable extends TempatBelis
    with TableInfo<$TempatBelisTable, TempatBeli> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TempatBelisTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
      'nama', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nama];
  @override
  String get aliasedName => _alias ?? 'tempat_belis';
  @override
  String get actualTableName => 'tempat_belis';
  @override
  VerificationContext validateIntegrity(Insertable<TempatBeli> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
          _namaMeta, nama.isAcceptableOrUnknown(data['nama']!, _namaMeta));
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TempatBeli map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TempatBeli(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nama: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}nama'])!,
    );
  }

  @override
  $TempatBelisTable createAlias(String alias) {
    return $TempatBelisTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $StocksTable stocks = $StocksTable(this);
  late final $StockItemsTable stockItems = $StockItemsTable(this);
  late final $TempatBelisTable tempatBelis = $TempatBelisTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [stocks, stockItems, tempatBelis];
}
