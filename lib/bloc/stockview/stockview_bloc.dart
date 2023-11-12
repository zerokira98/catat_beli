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
    on<Refresh>(_refresh);
  }
  FutureOr<void> _refresh(
    Refresh event,
    Emitter<StockviewState> emit,
  ) async {
    if (state is StockviewLoaded) {
      var statea = (state as StockviewLoaded);
      var all = await db.showStockwithDetails(filter: statea.filter, limit: 20);
      emit(StockviewLoaded(
          filter: statea.filter,
          datas: all.map((e) {
            // print('e${e.stock.note}');
            return ItemCards(
              note: e.stock.note,
              ditambahkan: e.stock.dateAdd,
              namaBarang: NamaBarang.dirty(e.item.nama),
              discount: Discount.dirty(e.stock.discount),
              cardId: e.stock.id,
              pcs: Pcs.dirty(e.stock.qty),
              productId: e.item.id,
              tempatBeli: Tempatbeli.dirty(e.tempatBeli.nama),
              hargaBeli: Hargabeli.dirty(e.stock.price),
            );
          }).toList()));
    }
  }

  FutureOr<void> _pageChange(
    PageChange event,
    Emitter<StockviewState> emit,
  ) async {
    var maxpage = (state as StockviewLoaded).filter.maxPage;
    emit(StockviewLoading());
    var all = await db.showStockwithDetails(
      filter: Filter(
        nama: event.filter.nama,
        currentPage: event.filter.currentPage,
        maxPage: maxpage,
        startDate: event.filter.startDate,
        tempatBeli: event.filter.tempatBeli,
        endDate: event.filter.endDate.add(Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        )),
      ),
    );
    int maxQ = all.length;
    // print('maxq = ' + maxQ.toString());
    var data = await db.showStockwithDetails(
      filter: event.filter,
      limit: 20,
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
            discount: Discount.dirty(e.stock.discount),
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
    print('object');
    emit(StockviewLoading());
    //null limit
    var all = await db.showStockwithDetails(
      filter: event.filter.copyWith(
        endDate: event.filter.endDate.add(Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        )),
      ),
    );
    int maxQ = all.length;
    int pagefinal = ((maxQ / 20) % 1 == 0)
        ? ((maxQ / 20) - 1).toInt()
        : ((maxQ / 20).floor());
    // print('maxq = ' + maxQ.toString());
    var data = await db.showStockwithDetails(
      filter: event.filter.copyWith(currentPage: pagefinal),
      limit: 20,
    );
    // print(maxQ);
    // print((maxQ / 20).floor());
    print(data);
    emit(StockviewLoaded(
        filter: event.filter
            .copyWith(maxPage: (maxQ / 20).floor(), currentPage: pagefinal),
        datas: data.map((e) {
          // print('e${e.stock.note}');
          return ItemCards(
            note: e.stock.note,
            ditambahkan: e.stock.dateAdd,
            namaBarang: NamaBarang.dirty(e.item.nama),
            discount: Discount.dirty(e.stock.discount),
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
    var maxQ = (await db.showStockwithDetails(
      filter: Filter(
          currentPage: 0, maxPage: 0, startDate: startDate, endDate: endDate),
    ))
        .length;
    // print('maxq = ' + maxQ.toString());
    var a = await db.showStockwithDetails(
      limit: 20,
      filter: Filter(
          currentPage: (maxQ / 20).floor(),
          maxPage: 0,
          startDate: startDate,
          endDate: endDate),
      // page: (maxQ / 20).floor(),
      // startDate: startDate,
      // endDate: endDate
    );
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
                discount: Discount.dirty(e.stock.discount),
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
}
