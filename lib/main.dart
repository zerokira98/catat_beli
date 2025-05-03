import 'package:catatbeli/bloc/cubit/theme_cubit.dart';
import 'package:catatbeli/msc/backupfile_uploader.dart';
import 'package:catatbeli/msc/themedatas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catatbeli/bloc/stock/insertstock_bloc.dart';
import 'package:catatbeli/bloc/stockview/stockview_bloc.dart';
import 'package:catatbeli/page/insert_stock/insert_stock.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:sqlite3/sqlite3.dart' as sql;
import 'package:sqlite3/open.dart';
// import 'package:intl/intl.dart';
part 'windows_window.dart';

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     print("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   print('[BackgroundFetch] Headless event received.');
//   // Do your work here...
//   BackgroundFetch.finish(taskId);
// }

main() async {
  // var str = await rootBundle.loadString('.env');
  await dotenv.load();
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
          (await getApplicationDocumentsDirectory()).path));
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(App()));

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  if (Platform.isWindows) {
    open.overrideFor(OperatingSystem.linux, _openOnWindows);
    final db = sql.sqlite3.openInMemory();
    db.dispose();
    doWhenWindowReady(() {
      appWindow.size = Size(480, 720);
      appWindow.minSize = Size(420, 720);
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
  final pageC = PageController();
  // bool _enabled = true;
  // int _status = 0;
  // List<DateTime> _events = [];

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(
  //     Durations.extralong4,
  //     () {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         // BackupfileUploader().backup().onError(
  //         //   (error, stackTrace) {
  //         //     print(error);
  //         //   },
  //         // );
  //         var env = dotenv.load().then(
  //           (value) {
  //             if (dotenv.env['GEMINI_API_KEY'] == null) {
  //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                   content:
  //                       Text('api variable not found, unable to use gemini.')));
  //               print(dotenv.env['GEMINI_API_KEY'] ??
  //                   'api variable not found, unable to use gemini.');
  //             }
  //           },
  //         );
  //       });
  //     },
  //   );
  //   // initPlatformState();
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   int status = await BackgroundFetch.configure(
  //       BackgroundFetchConfig(
  //           minimumFetchInterval: 15,
  //           stopOnTerminate: false,
  //           enableHeadless: true,
  //           requiresBatteryNotLow: false,
  //           requiresCharging: false,
  //           requiresStorageNotLow: false,
  //           requiresDeviceIdle: false,
  //           requiredNetworkType: NetworkType.NONE), (String taskId) async {
  //     // <-- Event handler
  //     // This is the fetch-event callback.
  //     print("[BackgroundFetch] Event received $taskId");
  //     setState(() {
  //       _events.insert(0, new DateTime.now());
  //     });
  //     // IMPORTANT:  You must signal completion of your task or the OS can punish your app
  //     // for taking too long in the background.
  //     BackgroundFetch.finish(taskId);
  //   }, (String taskId) async {
  //     // <-- Task timeout handler.
  //     // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
  //     print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
  //     BackgroundFetch.finish(taskId);
  //   });
  //   print('[BackgroundFetch] configure success: $status');
  //   setState(() {
  //     _status = status;
  //   });

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }

  // void _onClickEnable(enabled) {
  //   setState(() {
  //     _enabled = enabled;
  //   });
  //   if (enabled) {
  //     BackgroundFetch.start().then((int status) {
  //       print('[BackgroundFetch] start success: $status');
  //     }).catchError((e) {
  //       print('[BackgroundFetch] start FAILURE: $e');
  //     });
  //   } else {
  //     BackgroundFetch.stop().then((int status) {
  //       print('[BackgroundFetch] stop success: $status');
  //     });
  //   }
  // }

  // void _onClickStatus() async {
  //   int status = await BackgroundFetch.status;
  //   print(_events);
  //   print('[BackgroundFetch] status: $status');
  //   setState(() {
  //     _status = status;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MyDatabase(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ThemeCubit(themeDatas: ThemeDatas())..getThemeData(),
          ),
          BlocProvider(
            create: (context) =>
                InsertstockBloc(RepositoryProvider.of<MyDatabase>(context)),
            // ..add(Initiate(refresh: false)),
          ),
          BlocProvider(
              create: (context) =>
                  StockviewBloc(RepositoryProvider.of<MyDatabase>(context))
                    ..add(InitiateView())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
                title: 'Catat Beli',
                debugShowCheckedModeBanner: false,
                theme: state.themeData,
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
                              BlocProvider.of<InsertstockBloc>(context)
                                  .add(Initiate());
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

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType}');
  }
}
