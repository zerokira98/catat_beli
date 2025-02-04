part of 'insertstock_bloc.dart';

abstract class InsertstockEvent extends Equatable {
  const InsertstockEvent();

  @override
  List<Object> get props => [];
}

class Initiate extends InsertstockEvent {
  final bool? success;
  final InsertstockState? fromstate;
  Initiate({this.success, refresh, this.fromstate});
}

class ClearAll extends InsertstockEvent {
  final InsertstockState beforeState;
  ClearAll({required this.beforeState});
}

class SendtoDB extends InsertstockEvent {
  final List<ItemCards> data;
  SendtoDB(this.data);
}

class AddCard extends InsertstockEvent {
  final Map? item;
  // final int cardId;
  AddCard([this.item]);
}

class RemoveCard extends InsertstockEvent {
  final int cardId;
  RemoveCard(this.cardId);
}

class DataChange extends InsertstockEvent {
  final ItemCards data;
  DataChange(this.data);
}
