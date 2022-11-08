import 'package:catatbeli/bloc/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catatbeli/bloc/stock/insertstock_bloc.dart';
import 'package:catatbeli/bloc/stockview/stockview_bloc.dart';
import 'package:catatbeli/page/insert_stock/insert_stock.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:sqlite3/sqlite3.dart' as sql;
import 'package:sqlite3/open.dart';
// import 'package:intl/intl.dart';
part 'windows_window.dart';

main() async {
  if (Platform.isWindows) {
    open.overrideFor(OperatingSystem.linux, _openOnWindows);
    final db = sql.sqlite3.openInMemory();
    db.dispose();
  }
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc = NewBlocObserver();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(App()));
  // BlocOverrides.runZoned(
  //   () => runApp(App()),
  //   blocObserver: NewBlocObserver(),
  // );
  // runApp(App());
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow.size = Size(480, 720);
      appWindow.minSize = Size(480, 720);
      appWindow.maximize();
      appWindow.show();
    });
  }
}

ffi.DynamicLibrary _openOnWindows() {
  final script = File(Platform.script.toFilePath(windows: true));
  print(script.path);
  final libraryNextToScript = File('${script.path}/sqlite3.dll');
  return ffi.DynamicLibrary.open(libraryNextToScript.path);
}

class App extends StatelessWidget {
  App({
    Key? key,
  }) : super(key: key);

  final pageC = PageController();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MyDatabase(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit()..getThemeData(),
          ),
          BlocProvider(
            create: (context) =>
                InsertstockBloc(RepositoryProvider.of<MyDatabase>(context))
                  ..add(Initiate()),
          ),
          BlocProvider(
              create: (context) =>
                  StockviewBloc(RepositoryProvider.of<MyDatabase>(context))
                    ..add(InitiateView())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            print(state);
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: state,
                darkTheme: ThemeData.dark(
                  useMaterial3: true,
                ),
                theme: ThemeData(
                    useMaterial3: true,
                    fontFamily: 'OpenSans',
                    primaryColor: Colors.amber[800]),
                home: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: FutureBuilder<SharedPreferences>(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          if (snapshot.data!.getBool('firstStart') == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Text(
                                            'It\'s my first published app. Lots of bugs is expected. :)\n' +
                                                'No tutorial, use your instinct.'),
                                      ),
                                    );
                                  });
                              snapshot.data!.setBool('firstStart', false);
                            });
                          }
                        }
                        return Container(
                          child: (Platform.isWindows)
                              ? CustomWindow(child: InsertProductPage())
                              : InsertProductPage(),
                        );
                      }),
                ));
          },
        ),
      ),
    );
  }
}
