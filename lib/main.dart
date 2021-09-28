import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir/bloc/stock/insertstock_bloc.dart';
import 'package:kasir/bloc/stockview/stockview_bloc.dart';
import 'package:kasir/page/insert_stock.dart';
import 'package:kasir/model/itemcard.dart';
import 'package:kasir/msc/bloc_observer.dart';
import 'package:kasir/msc/db_moor.dart';
import 'package:kasir/page/more_page/gridview.dart';
import 'package:kasir/page/stockview/stockview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart' as sql;
import 'package:sqlite3/open.dart';

main() {
  open.overrideFor(OperatingSystem.linux, _openOnWindows);

  final db = sql.sqlite3.openInMemory();
  db.dispose();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = NewBlocObserver();

  runApp(App());
}

DynamicLibrary _openOnWindows() {
  final script = File(Platform.script.toFilePath(windows: true));
  print(script.path);
  final libraryNextToScript = File('${script.path}/sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript.path);
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final pageC = PageController();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MyDatabase(),
      child: MultiBlocProvider(
        providers: [
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
        child: MaterialApp(
          home: Scaffold(
            bottomNavigationBar: Builder(builder: (c) => Bottoms(pc: pageC)),
            body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                controller: pageC,
                itemBuilder: (context, i) {
                  if (i == 0) return InsertProductPage();
                  if (i == 1) return MorePage();
                  return CircularProgressIndicator();
                }),
          ),
        ),
      ),
    );
  }
}

class Bottoms extends StatefulWidget {
  final PageController pc;
  const Bottoms({Key? key, required this.pc}) : super(key: key);

  @override
  _BottomsState createState() => _BottomsState();
}

class _BottomsState extends State<Bottoms> {
  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            navIndex = i;
          });
          widget.pc.animateToPage(i,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        currentIndex: navIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add New'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'More'),
        ]);
  }
}
