part of 'insertstock_bloc.dart';

class InsertstockState extends Equatable {
  final bool? isSuccess;
  final bool isLoaded;
  final bool isLoading;
  final List<ItemCards> data;
  final String? msg;
  final InsertstockState? beforeState;
  InsertstockState({
    required this.data,
    required this.isLoaded,
    required this.isLoading,
    this.msg,
    this.beforeState,
    this.isSuccess,
  });

  copywith({
    List<ItemCards>? data,
    bool? isLoaded,
    bool? isLoading,
    bool? isSuccess,
    String? msg,
  }) {
    return InsertstockState(
      isSuccess: isSuccess ?? this.isSuccess,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      msg: msg ?? this.msg,
    );
  }

  clearMsg() {
    return InsertstockState(
      data: this.data,
      msg: null,
      isSuccess: this.isSuccess,
      isLoaded: this.isLoaded,
      isLoading: this.isLoading,
    );
  }

  @override
  List<Object?> get props => [msg, isLoaded, isLoading, isSuccess] + data;
}

// class InsertstockInitial extends InsertstockState {
//   InsertstockInitial() : super();
//   // @override
//   // InsertstockState? fromJson(Map<String, dynamic> json) {
//   //   return json['state'] as InsertstockInitial;
//   // }

//   @override
//   Map<String, dynamic>? toJson() {
//     return {'state': InsertstockInitial().toString()};
//   }
// }

// class Loading extends InsertstockState {
//   @override
//   InsertstockState? fromJson(Map<String, dynamic> json) {
//     return (json['state'] as Loading);
//   }

//   @override
//   Map<String, dynamic>? toJson() {
//     {}
//   }
//   // @override
//   // Map<String, dynamic>? toJson(InsertstockState state) {
//   //   return {'state': state};
//   // }
// }

// class Loaded extends InsertstockState {
//   final List<ItemCards> data;
//   final bool? success;
//   final String? msg;
//   Loaded({required this.data, this.msg, this.success});
//   Loaded clearMsg() {
//     return Loaded(data: this.data, msg: null, success: null);
//   }

//   @override
//   InsertstockState? fromJson(Map<String, dynamic> json) {
//     return Loaded(
//       data: (json['state']['data'] as List<Map>)
//           .map((Map e) => ItemCards.fromMap(e))
//           .toList(),
//       msg: json['state']['msg'],
//       success: json['state']['success'],
//     );
//   }

//   @override
//   Map<String, dynamic>? toJson() {
//     return {'state': (Loaded(data: data))};
//   }
//   // @override
//   // Map<String, dynamic>? toJson(InsertstockState state) {
//   //   return {'state': state};
//   // }

//   @override
//   List<Object?> get props => [data, success, msg];
// }
