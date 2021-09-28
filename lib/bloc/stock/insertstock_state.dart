part of 'insertstock_bloc.dart';

abstract class InsertstockState extends Equatable {
  const InsertstockState();

  @override
  List<Object> get props => [];
}

class InsertstockInitial extends InsertstockState {}

class Loading extends InsertstockState {}

class Loaded extends InsertstockState {
  final List<ItemCards> data;
  final bool? success;
  Loaded(this.data, [this.success]);
  @override
  List<Object> get props => [data];
}
