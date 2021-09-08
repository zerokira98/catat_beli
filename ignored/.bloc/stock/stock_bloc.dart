import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kasir/model/itemcard.dart';
import 'package:kasir/msc/db_moor.dart';
// import 'package:kasir_remake/msc/db.dart';
// import 'package:kasir_remake/model/item_tr.dart';
import 'package:meta/meta.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  MyDatabase _dbHelper;
  StockBloc(MyDatabase dbHelper)
      : _dbHelper = dbHelper,
        super(StockInitial()) {
    ///do smg
    add(StockInitialize(success: false));
  }

  bool verify(List<ItemCards> data) {
    return data.any((e) => e.namaBarang != null);
  }

  @override
  Stream<StockState> mapEventToState(
    StockEvent event,
  ) async* {
    if (state is StockInitial) {
      if (event is StockInitialize) {
        yield StockLoaded([
          ItemCards(
              cardId: Random().nextInt(510),
              // formkey: GlobalKey<FormState>(),
              ditambahkan: DateTime.now().toUtc(),
              open: false)
        ], success: event.success);
        await Future.delayed(Duration(milliseconds: 400), () async* {
          yield (state as StockLoaded).clearMsg();
        });
      }
    }
    if (state is StockLoaded) {
      if (event is OnDataChanged) {
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => (e.cardId == event.item.cardId) ? event.item : e)
            .toList());
      }
      if (event is UploadtoDB) {
        var data = (state as StockLoaded).data;
        // var state =
        //             (BlocProvider.of<StockBloc>(context).state as StockLoaded);
        bool valids = data.isNotEmpty
            ? data.every((element) => element.formkey!.currentState!.validate())
            : false;
        // verify(data);
        // if (data.any((e) => e.formkey.currentState.validate())) {
        //   yield StockLoaded(data, error: {'msg': 'data tidak valid'});
        //   await Future.delayed(Duration(seconds: 4));
        //   yield StockLoaded(data, error: null);
        // } else {
        if (valids) {
          yield (StockLoading());
          await Future.delayed(Duration(seconds: 1));
          try {
            await _dbHelper.addItem(data);
            yield StockInitial();
            add(StockInitialize(success: true));
          } catch (e) {
            yield StockLoaded(data, error: {'msg': e.toString()});
            await Future.delayed(Duration(seconds: 1));
            yield (state as StockLoaded).clearMsg();
          }
        } else if (data.isEmpty) {
          print('error no data');
          // yield (StockLoading());
          // await Future.delayed(Duration(seconds: 2));
          yield StockInitial();
          add(StockInitialize(success: false));
        }
        // }
      }
      if (event is NewStockEntry) {
        List<ItemTr> prevData = (state as StockLoaded).data;
        DateTime? ditambahkan = prevData.isNotEmpty
            ? prevData.last.ditambahkan
            : DateTime.now().toUtc();
        yield StockLoaded((state as StockLoaded).data +
            [
              ItemCards(
                  cardId: Random().nextInt(510),
                  ditambahkan: ditambahkan,
                  open: false)
            ]);

        await Future.delayed(Duration(milliseconds: 100));
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) => e.open == false ? e.copywith(open: true) : e)
            .toList());
      }
      if (event is DeleteEntry) {
        yield StockLoaded((state as StockLoaded)
            .data
            .map((e) =>
                e.cardId == event.item.cardId ? e.copywith(open: false) : e)
            .toList());

        await Future.delayed(Duration(milliseconds: 550));
        yield StockLoaded(
          (state as StockLoaded)
              .data
              .where((element) => (element.cardId != event.item.cardId))
              .toList(),
        );
        if ((state as StockLoaded).data.isEmpty) {
          yield StockInitial();
          add(StockInitialize(success: false));
        }
      }
    }
  }
}
