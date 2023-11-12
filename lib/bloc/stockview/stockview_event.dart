part of 'stockview_bloc.dart';

abstract class StockviewEvent extends Equatable {
  const StockviewEvent();

  @override
  List<Object> get props => [];
}

class InitiateView extends StockviewEvent {
  final String? message;
  final bool search;
  InitiateView({this.message, bool? search}) : this.search = search ?? false;
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

class PageChange extends StockviewEvent {
  final Filter filter;
  PageChange(this.filter);
}

class Refresh extends StockviewEvent {
  // final Filter filter;
  // PageChange(this.filter);
}
