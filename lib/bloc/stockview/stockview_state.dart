part of 'stockview_bloc.dart';

abstract class StockviewState extends Equatable {
  const StockviewState();

  @override
  List<Object> get props => [];
}

class StockviewInitial extends StockviewState {}

class StockviewLoading extends StockviewState {}

class StockviewLoaded extends StockviewState {
  final Filter filter;
  final List<ItemCards> datas;
  final String? message;
  StockviewLoaded({required this.filter, required this.datas, this.message}) {
    // this.message = message??'';
  }
  @override
  List<Object> get props => [filter, datas];
}

class Filter extends Equatable {
  final String? nama;
  final String? tempatBeli;
  final int currentPage;
  final int maxRow;
  final String startDate;
  final String endDate;
  Filter(
      {this.nama,
      this.tempatBeli,
      required this.currentPage,
      required this.maxRow,
      required this.startDate,
      required this.endDate});
  Filter copyWith({
    String? nama,
    String? tempatBeli,
    int? currentPage,
    int? maxRow,
    String? startDate,
    String? endDate,
  }) {
    return Filter(
      nama: nama ?? this.nama,
      tempatBeli: tempatBeli ?? this.tempatBeli,
      currentPage: currentPage ?? this.currentPage,
      maxRow: maxRow ?? this.maxRow,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props =>
      [nama, tempatBeli, currentPage, maxRow, startDate, endDate];
}
