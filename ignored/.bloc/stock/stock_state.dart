part of 'stock_bloc.dart';

@immutable
abstract class StockState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<ItemTr> data;
  final Map? error;
  final bool? success;
  StockLoaded(this.data, {this.error, this.success});
  StockLoaded clearMsg({data}) {
    return StockLoaded(data ?? this.data);
  }

  @override
  List<Object?> get props => [data, error, success];
  @override
  String toString() {
    return 'length : $data';
  }
}

class StockError extends StockState {}
