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
  Loaded(this.data);
  @override
  List<Object> get props => [data];
}
