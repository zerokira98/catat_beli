import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasir/model/itemcard.dart';
import 'package:kasir/msc/db_moor.dart';

part 'insertstock_event.dart';
part 'insertstock_state.dart';

class InsertstockBloc extends Bloc<InsertstockEvent, InsertstockState> {
  final MyDatabase db;
  InsertstockBloc(this.db) : super(InsertstockInitial());

  @override
  Stream<InsertstockState> mapEventToState(
    InsertstockEvent event,
  ) async* {
    if (event is Initiate) {
      List<ItemCards> data = [];
      data.add(ItemCards(
          ditambahkan: DateTime.now(), pcs: 1.0, cardId: 1, open: false));
      yield Loaded(data, event.success);
      // await Future.delayed(Duration(milliseconds: 500));
      // yield Loaded(data.map((e) => e.copywith(open: true)).toList());
    }
    if (state is Loaded) {
      if (event is DataChange) {
        // (state as Loaded).data.firstWhere((e) => e.cardId == event.data.cardId);
        yield Loaded(
          (state as Loaded)
              .data
              .map((e) => e.cardId == event.data.cardId ? event.data : e)
              .toList(),
        );
      }
      if (event is SendtoDB) {
        print('not yet implemented');

        List<ItemCards> data = (state as Loaded)
            .data
            .map((e) => e.copywith(namaBarang: e.namaBarang?.trim()))
            .toList();
        yield Loaded(data);
        // var state =
        //             (BlocProvider.of<StockBloc>(context).state as StockLoaded);
        bool valids = data.isNotEmpty
            ? data.every((element) => element.formkey!.currentState!.validate())
            : false;
        if (valids) {
          yield (Loading());
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
      if (event is AddCard) {
        var prev = (state as Loaded).data;
        var tambahDate =
            prev.isNotEmpty ? prev.last.ditambahkan : DateTime.now().toUtc();
        yield Loaded(
          prev +
              [
                ItemCards(
                    cardId: prev.isNotEmpty ? prev.last.cardId! + 1 : 1,
                    ditambahkan: tambahDate,
                    pcs: 1,
                    open: false)
              ],
        );
      }
      if (event is RemoveCard) {
        yield Loaded(
          (state as Loaded)
              .data
              .map(
                  (e) => e.cardId == event.cardId ? e.copywith(open: false) : e)
              .toList(),
        );
        await Future.delayed(Duration(milliseconds: 500));
        yield Loaded((state as Loaded)
            .data
            .where((e) => e.cardId != event.cardId)
            .toList());

        if ((state as Loaded).data.isEmpty) {
          // yield InsertstockInitial();
          await Future.delayed(Duration(milliseconds: 100));

          add(Initiate());
        }
      }
    }
  }
}
