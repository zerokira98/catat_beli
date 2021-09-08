part of 'stock_bloc.dart';

@immutable
abstract class StockEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InsertNewStock extends StockEvent {
  final ItemTr data;
  InsertNewStock(this.data);
  @override
  List<Object> get props => [data];
}

class UploadtoDB extends StockEvent {
  final List<ItemTr> data;
  UploadtoDB(this.data);

  @override
  List<Object> get props => [data];
}

class NewStockEntry extends StockEvent {}

class ShowStock extends StockEvent {}

class OnDataChanged extends StockEvent {
  final ItemTr item;
  OnDataChanged(this.item);
  @override
  List<Object> get props => [item];
}

class DeleteEntry extends StockEvent {
  final ItemTr item;
  DeleteEntry(this.item);

  @override
  List<Object> get props => [item];
}

class StockInitialize extends StockEvent {
  final bool success;
  StockInitialize({required this.success});

  // @override
  // List<Object> get props => [success];

}
