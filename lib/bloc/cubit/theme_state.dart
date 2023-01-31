part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  // final ThemeMode mode;
  final ThemeData themeData;

  ThemeState(
      {
      // required this.mode,
      required this.themeData});
  @override
  List<Object> get props => [
        // this.mode,
        this.themeData
      ];
}
