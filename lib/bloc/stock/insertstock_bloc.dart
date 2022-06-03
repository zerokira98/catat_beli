import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';

part 'insertstock_event.dart';
part 'insertstock_state.dart';

class InsertstockBloc extends Bloc<InsertstockEvent, InsertstockState> {
  final MyDatabase db;
  InsertstockBloc(this.db) : super(InsertstockInitial()) {
    on<Initiate>(_initiate);
    on<DataChange>(_dataChange);
    on<SendtoDB>(_sendToDB);
    on<AddCard>(_addCard);
    on<RemoveCard>(_removeCard);
  }
  void _initiate(Initiate event, Emitter<InsertstockState> emit) async {
    List<ItemCards> data = [];
    data.add(ItemCards(
        ditambahkan: DateTime.now(), pcs: 1.0, cardId: 1, open: false));
    emit(Loaded(data, event.success));
  }

  void _dataChange(DataChange event, Emitter<InsertstockState> emit) async {
    if (state is Loaded) {
      emit(Loaded(
        (state as Loaded)
            .data
            .map((e) => e.cardId == event.data.cardId ? event.data : e)
            .toList(),
      ));
    }
  }

  FutureOr<void> _sendToDB(
      SendtoDB event, Emitter<InsertstockState> emit) async {
    List<ItemCards> data = (state as Loaded)
        .data
        .map((e) => e.copywith(
              namaBarang: e.namaBarang?.trim(),
              tempatBeli: e.tempatBeli?.trim(),
            ))
        .toList();
    emit(Loaded(data));
    // var state =
    //             (BlocProvider.of<StockBloc>(context).state as StockLoaded);
    bool valids = data.isNotEmpty
        ? data.every((element) => element.formkey!.currentState!.validate())
        : false;
    if (valids) {
      emit(Loading());
      await Future.delayed(Duration(seconds: 1));
      try {
        await db.addItems(data);
        // yield StockInitial();
        // add(StockInitialize(success: true));
        add(Initiate(success: true));
      } catch (e) {
        print(e);
        // yield StockLoaded(data, error: {'msg': e.toString()});
        // await Future.delayed(Duration(seconds: 1));
        // yield (state as StockLoaded).clearMsg();
      }
    }
  }

  FutureOr<void> _addCard(AddCard event, Emitter<InsertstockState> emit) {
    var prev = (state as Loaded).data;
    var tambahDate =
        prev.isNotEmpty ? prev.last.ditambahkan : DateTime.now().toUtc();
    emit(Loaded(
      prev +
          [
            ItemCards(
                cardId: prev.isNotEmpty ? prev.last.cardId! + 1 : 1,
                ditambahkan: tambahDate,
                pcs: 1,
                open: false)
          ],
    ));
  }

  FutureOr<void> _removeCard(
      RemoveCard event, Emitter<InsertstockState> emit) async {
    emit(Loaded(
      (state as Loaded)
          .data
          .map((e) => e.cardId == event.cardId ? e.copywith(open: false) : e)
          .toList(),
    ));
    await Future.delayed(Duration(milliseconds: 500));
    emit(Loaded((state as Loaded)
        .data
        .where((e) => e.cardId != event.cardId)
        .toList()));

    if ((state as Loaded).data.isEmpty) {
      // yield InsertstockInitial();
      await Future.delayed(Duration(milliseconds: 100));

      add(Initiate());
    }
  }
}
