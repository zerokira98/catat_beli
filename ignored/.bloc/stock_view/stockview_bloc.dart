import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasir_remake/model/item_tr.dart';
import 'package:kasir_remake/msc/db.dart';

part 'stockview_event.dart';
part 'stockview_state.dart';

class StockviewBloc extends Bloc<StockviewEvent, StockviewState> {
  DatabaseRepository _dbHelper;
  StockviewBloc(DatabaseRepository dbHelper)
      : _dbHelper = dbHelper,
        super(StockviewInitial()) {
    add(Initializeview());
  }

  @override
  Stream<StockviewState> mapEventToState(
    StockviewEvent event,
  ) async* {
    if (event is Initializeview) {
      Map<dynamic, dynamic> dbres =
          await (_dbHelper.showInsideStock(showName: true, page: 0));
      print(dbres);
      List<ItemTr> convert = dbres['res'].map<ItemTr>((e) {
        var dateDb = e['ADD_DATE'].toString();
        bool isUtc = dateDb.contains('Z');

        return ItemTr(
          namaBarang: e['NAMA'],
          // barcode: null,
          ditambahkan: isUtc
              ? DateTime.parse(dateDb).toLocal()
              : DateTime.parse(dateDb + 'Z').toLocal(),
          expdate: DateTime.parse(e['EXP_DATE']),
          pcs: e['QTY'],
          hargaBeli: e['PRICE'],
          hargaJual: e['HARGA_JUAL'],
          tempatBeli: e['SUPPLIER'],
          cardId: e['STOCK_ID'],
        );
      }).toList();
      yield StockviewLoaded(
          convert,
          Filter(
            maxPage: dbres['maxEntry'],
            startDate:
                DateTime.now().subtract(Duration(days: 30 * 12)).toString(),
            endDate: DateTime.now().add(Duration(days: 1)).toString(),
          ),
          currentPage: 0);
    }
    if (event is DeleteEntry) {
      try {
        yield StockviewLoading();
        await _dbHelper.deleteStock(event.data.cardId.toString());
        add(Initializeview());
      } catch (e) {}
    }
    if (event is FilterChange) {
      // var filter = (state as StockviewLoaded).filter.nama;
      yield StockviewLoading();
      Map dbres = await (_dbHelper.showInsideStock(
          showName: true,
          name: event.name,
          tempatBeli: event.tempatBeli,
          startDate: event.dateStart,
          endDate: event.dateEnd,
          page: event.page));
      List<ItemTr> convert = dbres['res'].map<ItemTr>((e) {
        var dateDb = e['ADD_DATE'].toString();
        bool isUtc = dateDb.contains('Z');
        var ditambahkan = isUtc
            ? DateTime.parse(dateDb).toLocal()
            : DateTime.parse(dateDb + 'Z').toLocal();
        return ItemTr(
          namaBarang: e['NAMA'],
          // barcode: null,
          ditambahkan: ditambahkan,
          pcs: e['QTY'],
          expdate: DateTime.parse(e['EXP_DATE']),
          hargaBeli: e['PRICE'],
          hargaJual: e['HARGA_JUAL'],
          tempatBeli: e['SUPPLIER'],
          // id: ,
        );
      }).toList();
      yield StockviewLoaded(
          convert,
          Filter(
            nama: event.name,
            maxPage: dbres['maxEntry'],
            tempatBeli: event.tempatBeli,
            startDate: event.dateStart,
            endDate: event.dateEnd,
          ),
          currentPage: event.page);
    }
  }
}
