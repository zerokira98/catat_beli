part of 'stockview_bloc.dart';

abstract class StockviewState extends Equatable {
  const StockviewState();

  @override
  List<Object> get props => [];
}

class StockviewInitial extends StockviewState {}

class StockviewLoading extends StockviewState {}

class StockviewLoaded extends StockviewState {
  final List<ItemTr> data;
  final Filter filter;
  final int currentPage;
  StockviewLoaded(this.data, this.filter, {required this.currentPage});
  @override
  List<Object> get props => [data];
}

class Filter extends Equatable {
  final String? nama;
  final String? tempatBeli;
  final int maxPage;
  final String startDate;
  final String endDate;
  Filter(
      {this.nama,
      this.tempatBeli,
      required this.maxPage,
      required this.startDate,
      required this.endDate});

  @override
  List<Object?> get props => [nama];
}
