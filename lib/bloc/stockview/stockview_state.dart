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
  final String nama;
  final String tempatBeli;
  final int? barcode;

  ///curent page starts from 0
  final int currentPage;

  ///maxpage starts from 0
  final int maxPage;

  ///
  final DateTime startDate;
  final DateTime endDate;
  Filter(
      {String? nama,
      String? tempatBeli,
      this.barcode,
      int? currentPage,
      int? maxPage,
      required this.startDate,
      DateTime? endDate})
      : nama = nama ?? '',
        tempatBeli = tempatBeli ?? '',
        currentPage = currentPage ?? -1,
        maxPage = maxPage ?? -1,
        endDate = endDate ??
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  Filter copyWith({
    String? nama,
    String? tempatBeli,
    int? currentPage,
    int? maxPage,
    DateTime? startDate,
    DateTime? endDate,
    int? barcode,
  }) {
    return Filter(
      nama: nama ?? this.nama,
      tempatBeli: tempatBeli ?? this.tempatBeli,
      barcode: barcode ?? this.barcode,
      currentPage: currentPage ?? this.currentPage,
      maxPage: maxPage ?? this.maxPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props =>
      [nama, tempatBeli, currentPage, maxPage, startDate, endDate, barcode];
}
