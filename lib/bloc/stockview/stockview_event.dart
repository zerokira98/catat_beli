part of 'stockview_bloc.dart';

abstract class StockviewEvent extends Equatable {
  const StockviewEvent();

  @override
  List<Object> get props => [];
}

class InitiateView extends StockviewEvent {
  final String? message;
  InitiateView({this.message});
}

class DeleteEntry extends StockviewEvent {
  final ItemCards data;
  // final int stockId;
  DeleteEntry(
    this.data,
  );
}

class FilterChange extends StockviewEvent {
  final Filter filter;
  FilterChange(this.filter);
}
