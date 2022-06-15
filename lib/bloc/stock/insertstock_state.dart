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
  final String? msg;
  Loaded({required this.data, this.msg, this.success});
  Loaded clearMsg() {
    return Loaded(data: this.data, msg: null, success: null);
  }

  @override
  List<Object> get props => [data];
}
