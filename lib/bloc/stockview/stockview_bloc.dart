import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catatbeli/model/itemcard_formz.dart';
import 'package:equatable/equatable.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';

part 'stockview_event.dart';
part 'stockview_state.dart';

class StockviewBloc extends Bloc<StockviewEvent, StockviewState> {
  final MyDatabase db;
  StockviewBloc(this.db) : super(StockviewInitial()) {
    on<FilterChange>(_filterChange);
    on<PageChange>(_pageChange);
    on<InitiateView>(_initiateView);
    on<DeleteEntry>(_deleteEntry);
  }

  FutureOr<void> _pageChange(
    PageChange event,
    Emitter<StockviewState> emit,
  ) async {
    emit(StockviewLoading());
    var all = await db.showStockwithDetails(
      barcode: event.filter.barcode,
      name: event.filter.nama,
      page: event.filter.currentPage,
      startDate: (event.filter.startDate),
      endDate: (event.filter.endDate).add(Duration(
        hours: 23,
        minutes: 59,
        seconds: 59,
      )),
      boughtPlace: event.filter.tempatBeli,
    );
    // var test = await db.maxdataStock(
    //     startDate: (event.filter.startDate),
    //     endDate: (event.filter.endDate).add(Duration(
    //       hours: 23,
    //       minutes: 59,
    //       seconds: 59,
    //     )));
    // print('test$test');
    int maxQ = all.length;
    // print('maxq = ' + maxQ.toString());
    var data = await db.showStockwithDetails(
      barcode: event.filter.barcode,
      name: event.filter.nama,
      limit: 20,
      page: event.filter.currentPage,
      startDate: (event.filter.startDate),
      endDate: (event.filter.endDate),
      boughtPlace: event.filter.tempatBeli,
    );
    print(maxQ);
    // print((maxQ / 20).floor());
    // print(data);
    emit(StockviewLoaded(
        filter: event.filter.copyWith(currentPage: event.filter.currentPage
            // maxRow: maxQ,
            ),
        datas: data.map((e) {
          // print('e${e.stock.note}');
          return ItemCards(
            note: e.stock.note,
            ditambahkan: e.stock.dateAdd,
            namaBarang: NamaBarang.dirty(e.item.nama),
            cardId: e.stock.id,
            pcs: Pcs.dirty(e.stock.qty),
            productId: e.item.id,
            tempatBeli: Tempatbeli.dirty(e.tempatBeli.nama),
            hargaBeli: Hargabeli.dirty(e.stock.price),
          );
        }).toList()));
  }

  FutureOr<void> _filterChange(
      FilterChange event, Emitter<StockviewState> emit) async {
    emit(StockviewLoading());
    //null limit
    var all = await db.showStockwithDetails(
      barcode: event.filter.barcode,
      name: event.filter.nama,
      page: event.filter.currentPage,
      startDate: (event.filter.startDate),
      endDate: (event.filter.endDate).add(Duration(
        hours: 23,
        minutes: 59,
        seconds: 59,
      )),
      boughtPlace: event.filter.tempatBeli,
    );
    int maxQ = all.length;
    int pagefinal = ((maxQ / 20) % 1 == 0)
        ? ((maxQ / 20) - 1).toInt()
        : ((maxQ / 20).floor());
    // print('maxq = ' + maxQ.toString());
    var data = await db.showStockwithDetails(
      barcode: event.filter.barcode,
      name: event.filter.nama,
      limit: 20,
      page: pagefinal,
      startDate: (event.filter.startDate),
      endDate: (event.filter.endDate),
      boughtPlace: event.filter.tempatBeli,
    );
    // print(maxQ);
    // print((maxQ / 20).floor());
    // print(data);
    emit(StockviewLoaded(
        filter: event.filter
            .copyWith(maxPage: (maxQ / 20).floor(), currentPage: pagefinal),
        datas: data.map((e) {
          // print('e${e.stock.note}');
          return ItemCards(
            note: e.stock.note,
            ditambahkan: e.stock.dateAdd,
            namaBarang: NamaBarang.dirty(e.item.nama),
            cardId: e.stock.id,
            pcs: Pcs.dirty(e.stock.qty),
            productId: e.item.id,
            tempatBeli: Tempatbeli.dirty(e.tempatBeli.nama),
            hargaBeli: Hargabeli.dirty(e.stock.price),
          );
        }).toList()));
  }

  FutureOr<void> _initiateView(
      InitiateView event, Emitter<StockviewState> emit) async {
    emit(StockviewLoading());

    var curdate = DateTime.now();
    var startDate = DateTime(curdate.year, curdate.month, 1);
    if (event.search) {
      startDate = startDate.subtract(Duration(days: 365));
    }
    var endDate = DateTime(curdate.year, curdate.month + 1, 0)
        .add(Duration(hours: 23, minutes: 59));

    // int maxQ = await db.maxdataStock(startDate: startDate, endDate: endDate);
    var maxQ =
        (await db.showStockwithDetails(startDate: startDate, endDate: endDate))
            .length;
    // print('maxq = ' + maxQ.toString());
    var a = await db.showStockwithDetails(
        limit: 20,
        page: (maxQ / 20).floor(),
        startDate: startDate,
        endDate: endDate);
    // print(a);
    emit(StockviewLoaded(
      message: event.message,
      filter: Filter(
          currentPage: (maxQ / 20).floor(),
          maxPage: (maxQ / 20).floor(),
          startDate: startDate,
          endDate: endDate),
      datas: a
          .map((e) => ItemCards(
                note: e.stock.note,
                ditambahkan: e.stock.dateAdd,
                namaBarang: NamaBarang.dirty(e.item.nama),
                cardId: e.stock.id,
                pcs: Pcs.dirty(e.stock.qty),
                productId: e.item.id,
                tempatBeli: Tempatbeli.dirty(e.tempatBeli.nama),
                hargaBeli: Hargabeli.dirty(e.stock.price),
              ))
          .toList(),
    ));
  }

  FutureOr<void> _deleteEntry(
      DeleteEntry event, Emitter<StockviewState> emit) async {
    emit(StockviewLoading());
    var a = await db.deleteStock(event.data.cardId!);
    await Future.delayed(Duration(seconds: 1));
    if (a != 0) {
      print(a);
      // yield StockviewInitial();
      add(InitiateView(
          message: '[${event.data.namaBarang}] Deleted Sucsessfully'));
    }
  }

  // @override
  // Stream<StockviewState> mapEventToState(
  //   StockviewEvent event,
  // ) async* {
  //   if (event is FilterChange) {
  //     yield StockviewLoading();
  //     int maxQ = await db.maxdataStock(
  //       startDate: DateTime.parse(event.filter.startDate),
  //       endDate: DateTime.parse(event.filter.endDate),
  //     );
  //     // print('maxq = ' + maxQ.toString());
  //     var data = await db.showStockwithDetails(
  //       name: event.filter.nama,
  //       limit: 20,
  //       page: event.filter.currentPage,
  //       startDate: DateTime.parse(event.filter.startDate),
  //       endDate: DateTime.parse(event.filter.endDate),
  //       boughtPlace: event.filter.tempatBeli,
  //     );
  //     // print(data);
  //     yield StockviewLoaded(
  //         filter: event.filter.copyWith(maxRow: maxQ),
  //         datas: data
  //             .map((e) => ItemCards(
  //                   ditambahkan: e.stock.dateAdd,
  //                   namaBarang: e.item.nama,
  //                   cardId: e.stock.id,
  //                   pcs: e.stock.qty,
  //                   productId: e.item.id,
  //                   tempatBeli: e.tempatBeli.nama,
  //                   hargaBeli: e.stock.price,
  //                 ))
  //             .toList());
  //   }
  //   if (event is InitiateView) {
  //     yield StockviewLoading();
  //     var curdate = DateTime.now();
  //     var startDate = DateTime(curdate.year, curdate.month, 1);
  //     // var startDate = curdate.subtract(Duration(days: curdate.day + 1));
  //     // var endDate = curdate.add(Duration(days: 30));
  //     var endDate = DateTime(curdate.year, curdate.month + 1, 0);
  //     int maxQ = await db.maxdataStock(startDate: startDate, endDate: endDate);

  //     // print('maxq = ' + maxQ.toString());
  //     var a = await db.showStockwithDetails(limit: 20, page: 0);
  //     // print('passed here');
  //     yield StockviewLoaded(
  //       message: event.message,
  //       filter: Filter(
  //           currentPage: 0,
  //           maxRow: maxQ,
  //           startDate: startDate.toString(),
  //           endDate: endDate.toString()),
  //       datas: a
  //           .map((e) => ItemCards(
  //                 ditambahkan: e.stock.dateAdd,
  //                 namaBarang: e.item.nama,
  //                 cardId: e.stock.id,
  //                 pcs: e.stock.qty,
  //                 productId: e.item.id,
  //                 tempatBeli: e.tempatBeli.nama,
  //                 hargaBeli: e.stock.price,
  //               ))
  //           .toList(),
  //     );
  //   }
  //   if (event is DeleteEntry) {
  //     yield StockviewLoading();
  //     // var a = await db.deleteStock(event.data.cardId!);
  //     // if (a != 0) {
  //     //   print(a);
  //     //   yield StockviewInitial();
  //     //   add(InitiateView(message: 'Deleted Sucsessfully'));
  //     // }
  //   }
  // }
}
