import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);
  void getThemeData() async {
    var a = await SharedPreferences.getInstance();
    var b = a.getString('themeMode');
    if (b == null) {
      a.setString('themeMode', 'light');
      emit(ThemeMode.light);
    } else if (b == 'dark') {
      emit(ThemeMode.dark);
    }
  }

  void changeThemeData() async {
    var a = await SharedPreferences.getInstance();
    var b = a.getString('themeMode');
    print(b);
    if (b == null) {
      a.setString('themeMode', 'light');
      emit(ThemeMode.light);
    } else if (b == 'dark') {
      a.setString('themeMode', 'light');
      emit(ThemeMode.light);
    } else if (b == 'light') {
      a.setString('themeMode', 'dark');
      emit(ThemeMode.dark);
    }
  }
}
