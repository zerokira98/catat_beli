import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasir/model/itemcard.dart';
import 'package:kasir/msc/db_moor.dart';

part 'stockview_event.dart';
part 'stockview_state.dart';

class StockviewBloc extends Bloc<StockviewEvent, StockviewState> {
  final MyDatabase db;
  StockviewBloc(this.db) : super(StockviewInitial());
  @override
  Stream<StockviewState> mapEventToState(
    StockviewEvent event,
  ) async* {
    if (event is FilterChange) {
      yield StockviewLoading();
      int maxQ = await db.maxdataStock(
        startDate: DateTime.parse(event.filter.startDate),
        endDate: DateTime.parse(event.filter.endDate),
      );
      // print('maxq = ' + maxQ.toString());
      var data = await db.showStockwithDetails(
        name: event.filter.nama,
        limit: 20,
        page: event.filter.currentPage,
        startDate: DateTime.parse(event.filter.startDate),
        endDate: DateTime.parse(event.filter.endDate),
        boughtPlace: event.filter.tempatBeli,
      );
      // print(data);
      yield StockviewLoaded(
          filter: event.filter.copyWith(maxRow: maxQ),
          datas: data
              .map((e) => ItemCards(
                    ditambahkan: e.stock.dateAdd,
                    namaBarang: e.item.nama,
                    cardId: e.stock.id,
                    pcs: e.stock.qty,
                    productId: e.item.id,
                    tempatBeli: e.tempatBeli.nama,
                    hargaBeli: e.stock.price,
                  ))
              .toList());
    }
    if (event is InitiateView) {
      yield StockviewLoading();
      var curdate = DateTime.now();
      var startDate = DateTime(curdate.year, curdate.month, 1);
      // var startDate = curdate.subtract(Duration(days: curdate.day + 1));
      // var endDate = curdate.add(Duration(days: 30));
      var endDate = DateTime(curdate.year, curdate.month + 1, 0);
      int maxQ = await db.maxdataStock(startDate: startDate, endDate: endDate);

      // print('maxq = ' + maxQ.toString());
      var a = await db.showStockwithDetails(limit: 20, page: 0);
      // print('passed here');
      yield StockviewLoaded(
        message: event.message,
        filter: Filter(
            currentPage: 0,
            maxRow: maxQ,
            startDate: startDate.toString(),
            endDate: endDate.toString()),
        datas: a
            .map((e) => ItemCards(
                  ditambahkan: e.stock.dateAdd,
                  namaBarang: e.item.nama,
                  cardId: e.stock.id,
                  pcs: e.stock.qty,
                  productId: e.item.id,
                  tempatBeli: e.tempatBeli.nama,
                  hargaBeli: e.stock.price,
                ))
            .toList(),
      );
    }
    if (event is DeleteEntry) {
      yield StockviewLoading();
      // var a = await db.deleteStock(event.data.cardId!);
      // if (a != 0) {
      //   print(a);
      //   yield StockviewInitial();
      //   add(InitiateView(message: 'Deleted Sucsessfully'));
      // }
    }
  }
}
