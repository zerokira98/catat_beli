import 'dart:async';
// import 'dart:convert';
// import 'dart:html';

// import 'package:bloc/bloc.dart';
import 'package:catatbeli/model/itemcard_formz.dart';
import 'package:catatbeli/page/insert_stock/insert_stock.dart';
import 'package:equatable/equatable.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
// import 'package:formz/formz.dart';
// import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'insertstock_event.dart';
part 'insertstock_state.dart';

class InsertstockBloc extends HydratedBloc<InsertstockEvent, InsertstockState> {
  final MyDatabase db;
  InsertstockBloc(this.db)
      : super(InsertstockState(
          data: [],
          isLoaded: false,
          isLoading: true,
        )) {
    on<Initiate>(_initiate);
    on<DataChange>(_dataChange);
    on<SendtoDB>(_sendToDB);
    on<AddCard>(_addCard);
    on<RemoveCard>(_removeCard);
  }
  void _initiate(Initiate event, Emitter<InsertstockState> emit) async {
    // if (!event.refresh) {
    List<ItemCards> data = [];
    print('telo');
    emit(InsertstockState(
        data: data,
        isLoaded: false,
        isLoading: true,
        isSuccess: event.success));
    data.add(ItemCards(
        ditambahkan: DateTime.now(),
        created: false,
        pcs: Pcs.dirty(1.0),
        cardId: 1,
        open: false));
    await Future.delayed(Duration(milliseconds: 300));
    emit(InsertstockState(
        data: data,
        isLoaded: true,
        isLoading: false,
        isSuccess: event.success));
    // }
  }

  void _dataChange(DataChange event, Emitter<InsertstockState> emit) async {
    if (state.isLoaded) {
      emit(InsertstockState(
        data: (state)
            .data
            .map((e) => e.cardId == event.data.cardId ? event.data : e)
            .toList(),
        isLoading: false,
        isLoaded: true,
      ));
    }
  }

  FutureOr<void> _sendToDB(
    SendtoDB event,
    Emitter<InsertstockState> emit,
  ) async {
    List<ItemCards> data = (state)
        .data
        .map((e) => e.copywith(
              hargaBeli: e.modeHarga == ModeHarga.total
                  ? Hargabeli.dirty((e.hargaBeli.value / e.pcs.value).floor())
                  : e.hargaBeli,
              discount: e.discountMode == DiscountMode.total
                  ? Discount.dirty((e.discount.value / e.pcs.value).floor())
                  : e.discount,
              discountMode: DiscountMode.perPcs,
              modeHarga: ModeHarga.pcs,
              namaBarang: NamaBarang.dirty(e.namaBarang.value.trim()),
              tempatBeli: Tempatbeli.dirty(e.tempatBeli.value.trim()),
            ))
        .toList();
    emit(InsertstockState(data: data, isLoaded: true, isLoading: false));
    // var state =
    //             (BlocProvider.of<StockBloc>(context).state as StockLoaded);

    bool valids = data.isNotEmpty
        ? data
            .every((ItemCards element) => element.isValid) //true if always true
        : false;
    if (valids) {
      emit(InsertstockState(data: data, isLoaded: true, isLoading: true));
      try {
        await db.addItems(data);
        await Future.delayed(Duration(milliseconds: 500));
        // yield StockInitial();
        // add(StockInitialize(success: true));
        add(Initiate(success: true));
      } catch (e) {
        // print(e);
        emit(InsertstockState(
            data: data,
            isLoaded: true,
            isLoading: false,
            isSuccess: false,
            msg: e.toString()));
        await Future.delayed(Duration(seconds: 12), () {
          if (state.isLoaded) {
            emit((state).clearMsg());
          }
        });
      }
    } else {
      emit(InsertstockState(
          data: data,
          isLoaded: true,
          isLoading: false,
          isSuccess: false,
          msg: 'There is invalid data'));
      await Future.delayed(Duration(seconds: 10), () {
        if (state.isLoaded) {
          emit((state).clearMsg());
        }
      });
    }
  }

  FutureOr<void> _addCard(AddCard event, Emitter<InsertstockState> emit) {
    var prev = (state).data;
    var tambahDate =
        prev.isNotEmpty ? prev.last.ditambahkan : DateTime.now().toUtc();
    var tempatBeli = prev.isNotEmpty ? prev.last.tempatBeli.value : '';
    emit(InsertstockState(
        data: prev +
            [
              ItemCards(
                  cardId: prev.isNotEmpty ? prev.last.cardId! + 1 : 1,
                  ditambahkan: tambahDate,
                  created: false,
                  tempatBeli: Tempatbeli.dirty(tempatBeli),
                  pcs: Pcs.dirty(1),
                  open: false)
            ],
        isLoaded: true,
        isLoading: false));
  }

  FutureOr<void> _removeCard(
      RemoveCard event, Emitter<InsertstockState> emit) async {
    emit(InsertstockState(
      data: (state)
          .data
          .map((e) => e.cardId == event.cardId ? e.copywith(open: false) : e)
          .toList(),
      isLoaded: true,
      isLoading: false,
    ));
    await Future.delayed(Duration(milliseconds: 260));
    emit(InsertstockState(
      data: (state).data.where((e) => e.cardId != event.cardId).toList(),
      isLoaded: true,
      isLoading: false,
    ));

    if ((state).data.isEmpty) {
      // yield InsertstockInitial();
      // await Future.delayed(Duration(milliseconds: 100));

      /// initiate on listener
      // add(Initiate());
    }
  }

  @override
  InsertstockState? fromJson(Map<String, dynamic> json) {
    // print('you here?');
    // print('${json['state']['data']}');
    var prevData = (json['state']['data'] as List).map((e) {
      print('a');
      return ItemCards().fromJson(e);
    }).toList();
    // print(prevData);
    if (prevData.isEmpty) {
      //   List<ItemCards> data = [];
      // print('telo');
      return (InsertstockState(
          data: [], isLoaded: false, isLoading: true, isSuccess: false));
      // data.add();
      // add(Initiate());
    } else {
      if (prevData.length == 1 &&
          ItemCards()
              .fromJson(json['state']['data'][0])
              .namaBarang
              .value
              .trim()
              .isEmpty) {
        return InsertstockState(data: [
          ItemCards()
              .fromJson(json['state']['data'][0])
              .copywith(ditambahkan: DateTime.now())
        ], isLoaded: true, isLoading: false, isSuccess: false);
      }
      return InsertstockState(
          data: (json['state']['data'] as List)
              .map((e) => ItemCards().fromJson(e))
              .toList(),
          isLoaded: true,
          isLoading: false,
          isSuccess: false);
    }
    // return (json['state']);
  }

  @override
  Map<String, dynamic>? toJson(InsertstockState state) {
    print('tojson');
    print(state.data.map((ItemCards e) {
      return e.toJson();
    }).toList());
    return {
      'state': {
        'data': state.data.map((ItemCards e) {
          return e.toJson();
        }).toList(),
      }
    };
  }
}
