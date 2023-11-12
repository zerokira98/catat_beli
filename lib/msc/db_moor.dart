import 'dart:io';

import 'package:catatbeli/bloc/stockview/stockview_bloc.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

part 'db_moor.g.dart';

class Stocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get price => integer().withDefault(Constant(0))();
  IntColumn get discount => integer().withDefault(Constant(0))();
  RealColumn get qty => real().withDefault(Constant(1.0))();
  DateTimeColumn get dateAdd => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get idItem => integer().nullable().references(StockItems, #id)();
  IntColumn get idSupplier =>
      integer().nullable().references(TempatBelis, #id)();
}

class StockItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get barcode => integer().nullable()();
  TextColumn get nama => text().withLength(min: 3)();
}

class TempatBelis extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nama => text()();
  TextColumn get alamat => text().nullable()();
}

class HiddenItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemsId => integer().unique().references(StockItems, #id)();
}

class StockWithDetails {
  StockWithDetails(this.stock, this.item, this.tempatBeli);

  final Stock stock;
  final StockItem item;
  final TempatBeli tempatBeli;
  @override
  String toString() {
    return stock.toString() + item.nama + ' ' + tempatBeli.nama;
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [Stocks, StockItems, TempatBelis, HiddenItems],
//  queries: {
//   'showItemswithHide':
//       'SELECT * FROM stock_items WHERE stock_items.nama=:id stock_items.id NOT IN (SELECT items_id FROM hidden_items);',
//   'showItemsHiddenOnly':
//       'SELECT * FROM stock_items WHERE stock_items.id IN (SELECT items_id FROM hidden_items);'
// },
)
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 5;
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(stocks, stocks.note);
          }
          if (from < 3) {
            await m.addColumn(tempatBelis, tempatBelis.alamat);
          }
          if (from < 4) {
            await m.createTable(hiddenItems);
          }
          if (from < 5) {
            await m.addColumn(stocks, stocks.discount);
          }
        },
        beforeOpen: (d) async {
          //aa
          if (d.wasCreated) {
            await into(tempatBelis)
                .insert(TempatBelisCompanion(nama: Value('')));
          }
        },
      );

  Future<List<StockItem>> get dataItem => select(stockItems).get();
  Future<List<Stock>> get dataStock => select(stocks).get();

  ///==============
  Future test() async {
    var a = select(stockItems);
    var b = select(hiddenItems);
    var resB = await b.get();
    var mapB = resB.map((e) => e.itemsId);
    a..where((tbl) => tbl.id.isIn(mapB));
    // a..where((tbl) => tbl.nama.equals('1pres Surya 12'));
    return a.get();
  }

  ///==============
  Future addToHidden(int itemId) async {
    return into(hiddenItems)
        .insert(HiddenItemsCompanion.insert(itemsId: itemId));
  }

  ///==============
  Future<List> viewHidden([int? idBarang]) async {
    var a = select(hiddenItems);
    if (idBarang != null) {
      a..where((tbl) => tbl.itemsId.equals(idBarang));
    }
    return a.get();
  }

  ///==============
  Future removeFromHidden(int itemId) async {
    return (delete(hiddenItems)..where((tbl) => tbl.itemsId.equals(itemId)))
        .go();
  }

  ///================
  Future deleteStock(int cardId) async {
    return (delete(stocks)..where((tbl) => tbl.id.equals(cardId))).go();
  }

  // ///============
  // Future<int> maxdataStock(
  //     {required DateTime startDate, required DateTime endDate}) async {
  //   // var timenow = DateTime.now();
  //   // startDate = startDate ?? DateTime(timenow.year, timenow.month, 1);
  //   // endDate = endDate ??
  //   //     DateTime(timenow.year, timenow.month + 1, 1)
  //   //         .subtract(Duration(days: 1));
  //   var counts = stocks.id.count();
  //   var a = selectOnly(stocks);
  //   var c = select(stocks);
  //   c.addColumns([counts]);
  //   c.where(((tbl) =>
  //       tbl.dateAdd.isBiggerOrEqualValue(startDate) &
  //       tbl.dateAdd.isSmallerOrEqualValue(endDate)));

  //   c.orderBy([
  //     (tbl) => OrderingTerm(expression: tbl.dateAdd, mode: OrderingMode.asc)
  //   ]);
  //   c.join([
  //     leftOuterJoin(stockItems, stocks.idItem.equalsExp(stockItems.id)),
  //     leftOuterJoin(tempatBelis, stocks.idSupplier.equalsExp(tempatBelis.id)),
  //   ])
  //     ..where(stockItems.nama.contains(''))
  //     ..where(tempatBelis.nama.contains(''));

  //   a.addColumns([counts]);
  //   a.where(stocks.dateAdd.isBiggerOrEqualValue(startDate) &
  //       stocks.dateAdd.isSmallerOrEqualValue(endDate));
  //   var b = await c.get();
  //   var d = await showStockwithDetails(startDate: startDate, endDate: endDate);
  //   List bl = b.map((e) => e.id).toList();
  //   List dl = d.map((e) => e.stock.id).toList();
  //   var telo = bl.toSet().difference(dl.toSet()).toList();
  //   var ea = (b.where((element) => telo.contains(element.id)).toList());
  //   print('b:${b.length}');
  //   print('d:${d.length}');
  //   // (await a.get()).forEach(
  //   //   (element) {
  //   //     print(element.rawData.data);
  //   //   },
  //   // );
  //   for (var eas in ea) {
  //     print(eas);
  //     var eaeo = await itemwithid(eas.idItem! - 1000);
  //     print('ea$eaeo');
  //   }
  //   print('telo$telo');
  //   return a.map<int>((e) => e.read(counts)!).getSingle();
  // }

  ///=========
  Future<List<TempatBeli>> tempatwithid(int id) =>
      (select(tempatBelis)..where((tbl) => tbl.id.equals(id))).get();

  ///=========
  Future<List<StockItem>> itemwithid(int id) =>
      (select(stockItems)..where((tbl) => tbl.id.equals(id))).get();

  ///==== startDate(inclusion),endDate(exclution?)
  Future<List<StockWithDetails>> showStockwithDetails({
    int? idBarang,
    // int? barcode,
    int? limit,

    // //page starts with 0
    // int? page,

    // ///
    // DateTime? startDate,
    // DateTime? endDate,
    // String? name,
    // String? boughtPlace,
    required Filter filter,
  }) async {
    ///----------Declare default variables
    // boughtPlace = boughtPlace ?? '';
    // name = name ?? '';
    // var timenow = DateTime.now();
    // startDate = startDate ?? DateTime(timenow.year, 1, 1);
    // endDate = endDate ?? DateTime(timenow.year, timenow.month + 1, 0);

    /// Return variable
    ///
    List<TypedResult> a;

    // int max = await ;
    JoinedSelectStatement query;
    if (idBarang == null) {
      query = (select(stocks)
            ..orderBy([
              (tbl) =>
                  OrderingTerm(expression: tbl.dateAdd, mode: OrderingMode.asc)
            ])
            ..where((tbl) =>
                tbl.dateAdd.isBiggerOrEqualValue(filter.startDate) &
                stocks.dateAdd.isSmallerOrEqualValue(filter.endDate)))
          .join([
        leftOuterJoin(stockItems, stocks.idItem.equalsExp(stockItems.id)),
        leftOuterJoin(tempatBelis, stocks.idSupplier.equalsExp(tempatBelis.id)),
      ]);
      if (limit != null) {
        query.limit(
          limit,
          offset: filter.currentPage* limit,
        );
      }
    } else {
      query = (select(stocks)
            ..where((tbl) =>
                tbl.dateAdd.isBiggerOrEqualValue(filter.startDate) &
                stocks.dateAdd.isSmallerOrEqualValue(filter.endDate)))
          .join([
        leftOuterJoin(stockItems, stocks.idItem.equalsExp(stockItems.id)),
        leftOuterJoin(tempatBelis, stocks.idSupplier.equalsExp(tempatBelis.id)),
      ]);

      query.where(stocks.idItem.equals(idBarang));
      if (limit != null) {
        query.limit(
          limit,
          offset: filter.currentPage* limit,
        );
      }
      // a = await b.get();

      //  a= (select(stocks)..where((tbl) => tbl.idItem.equals(idBarang))).get();
    }

    if (filter.nama.split(' ').length > 1) {
      var namaArr = filter.nama.split(' ');
      for (var val in namaArr) {
        query..where(stockItems.nama.contains(val));
      }
    } else {
      query..where(stockItems.nama.contains(filter.nama));
    }
    // query.where(stockItems.nama.contains(name));
    query.where(tempatBelis.nama.contains(filter.tempatBeli));
    // query.orderBy([
    //   ($StocksTable tbl) => OrderingTerm.asc(tbl.dateAdd),
    //   ($StockItemsTable tbl) => OrderingTerm.asc(tbl.nama),
    //   ($TempatBelisTable tbl) => OrderingTerm.asc(tbl.nama)
    // ]);
    if (filter.barcode != null)
      query.where(stockItems.barcode.equals(filter.barcode!));
    a = await query.get();
    return a
        .map((e) => StockWithDetails(
              e.readTable(stocks),
              e.readTable(stockItems),
              e.readTable(tempatBelis),
            ))
        .toList();
  }

  Future<List<AvailData>> availMonthwithCount(DateTime year) async {
    ///----------Declare default variables
    var time = year;
    DateTime startDate = DateTime(time.year, 1, 1);
    DateTime endDate = DateTime(time.year, 12, 31);

    /// Return variable
    ///
    List<TypedResult> a;

    // int max = await ;
    // var sumOfprice = CustomExpression<double>("");
    Expression<int> sumOfprice = stocks.id.count();
    var query;
    query = (select(stocks)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.dateAdd, mode: OrderingMode.asc)
          ])
          ..where((tbl) =>
              tbl.dateAdd.isBiggerOrEqualValue(startDate) &
              stocks.dateAdd.isSmallerOrEqualValue(endDate)))
        .join([
      leftOuterJoin(stockItems, stocks.idItem.equalsExp(stockItems.id)),
      leftOuterJoin(tempatBelis, stocks.idSupplier.equalsExp(tempatBelis.id)),
    ])
      ..addColumns([sumOfprice])
      ..groupBy([stocks.dateAdd.month]);

    a = await query.get();
    return a
        .map<AvailData>(
            (e) => AvailData(e.readTable(stocks).dateAdd!, e.read(sumOfprice)!))
        .toList();
  }

  ///====
  Future<List<Stock>> showInsideStock({int? idBarang}) => idBarang == null
      ? select(stocks).get()
      : (select(stocks)..where((tbl) => tbl.idItem.equals(idBarang))).get();

  ///========
  Future<List<TempatBeli>> datatempat([String? query]) => query == null
      ? (select(tempatBelis)..orderBy([(tbl) => OrderingTerm.asc(tbl.nama)]))
          .get()
      : (select(tempatBelis)
            ..where((tbl) => tbl.nama.contains(query))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.nama)]))
          .get();

  ///========
  Future<List<StockItem>> showInsideItems(
      [String? nama, int? sort, bool? showHidden]) async {
    showHidden = showHidden ?? false;
    var a = select(stockItems);
    var b = select(hiddenItems);
    var resB = await b.get();
    var mapB = resB.map((e) => e.itemsId);
    // .join([leftOuterJoin(hiddenItems, hiddenItems.itemsId.in(stockItems.id))]);
    if (showHidden) {
      a..where((tbl) => tbl.id.isIn(mapB));
    } else {
      a..where((tbl) => tbl.id.isNotIn(mapB));
    }
    sort = sort ?? 0;
    List sortIndex = [
      (u) => OrderingTerm.asc(u.id),
      (u) => OrderingTerm.desc(u.id),
      (u) => OrderingTerm.asc(u.nama),
      (u) => OrderingTerm.desc(u.nama),
    ];
    a.orderBy([sortIndex[sort]]);
    if (nama == null) {
      return a.get();
    } else {
      if (nama.split(' ').length > 1) {
        var namaArr = nama.split(' ');
        for (var val in namaArr) {
          a..where((tbl) => tbl.nama.contains(val));
        }
      } else {
        a..where((tbl) => tbl.nama.contains(nama));
      }
      return (a).get();
    }
  }

  ///========
  Future addItems(List<ItemCards> datas) async {
    return await transaction(() async {
      for (var data in datas) {
        int tempatId = 0;
        int? itemId = data.productId;

        if (data.productId == null) {
          List<StockItem> a = await (select(stockItems)
                ..where((tbl) => tbl.nama.equals(data.namaBarang.value)))
              .get();
          if (a.isEmpty) {
            itemId = await into(stockItems).insert(StockItemsCompanion(
              nama: Value(data.namaBarang.value),
              barcode: data.barcode.value != 0
                  ? Value(data.barcode.value)
                  : Value.absent(),
            ));
          } else {
            itemId = a.single.id;
          }
        }
        //---------get tempat id
        var aa = await (select(tempatBelis)
              ..where((tbl) => tbl.nama.equals(data.tempatBeli.value)))
            .get();
        if (aa.isEmpty) {
          tempatId = await into(tempatBelis)
              .insert(TempatBelisCompanion(nama: Value(data.tempatBeli.value)));
        } else {
          tempatId = aa.single.id;
        }
        await into(stocks).insert(StocksCompanion(
          idItem: Value(itemId),
          discount: Value(data.discount.value),
          note: Value(data.note),
          idSupplier: Value(tempatId),
          price: Value(data.hargaBeli.value),
          qty: Value(data.pcs.value),
          dateAdd: Value(data.ditambahkan),
        ));
      }
    });
  }

  // Future tempatinsert() async {
  //   return into(tempatBelis).insert(TempatBelisCompanion(nama: Value('TOP')));
  // }

  Future updateNamaTempat(int id, String nama, String? alamat) async {
    return (update(tempatBelis)..where((tbl) => tbl.id.equals(id))).write(
        TempatBelisCompanion(
            nama: Value(nama),
            alamat: alamat != null ? Value(alamat) : Value.absent()));
  }

  Future updateItemProp(
      productId, String nama, int? harga, int? barcode) async {
    print(barcode);
    return await (update(stockItems)..where((tbl) => tbl.id.equals(productId)))
        .write(
      StockItemsCompanion(nama: Value(nama), barcode: Value(barcode)),
    );
  }

  Future updateStock(ItemCards a) async {
    return await (update(stocks)..where((tbl) => tbl.id.equals(a.cardId!)))
        .write(StocksCompanion(
            dateAdd: Value(a.ditambahkan),
            price: Value(a.hargaBeli.value),
            qty: Value(a.pcs.value)));
  }
}

class AvailData {
  DateTime date;
  int rowCount;
  AvailData(this.date, this.rowCount);
  @override
  String toString() {
    return [date.toString(), rowCount.toString()].toString();
  }
}
