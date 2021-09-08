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
                  if (i == 1) return Home();
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

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Misc'),
      ),
      body: Center(
        child: GridView.count(
          padding: EdgeInsets.all(12),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          crossAxisCount: 5,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  RepositoryProvider.of<MyDatabase>(context).addItems([
                    ItemCards(
                      namaBarang: 'Rokok Surya 12',
                      hargaBeli: 17500,
                      pcs: 1,
                      tempatBeli: 'TOP',
                    )
                  ]);
                },
                child: Text('test')),
            ElevatedButton(
                onPressed: () async {
                  print(await RepositoryProvider.of<MyDatabase>(context)
                      .showStockwithDetails(
                          startDate:
                              DateTime.now().subtract(Duration(days: 30))));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => InsertProductPage()));
                },
                child: Text('Terminal ==>>')),
            ElevatedButton(
                onPressed: () async {
                  var a = await RepositoryProvider.of<MyDatabase>(context)
                      .dataStock;
                  print(a);
                },
                child: Text('data stock')),
            ElevatedButton(
              child: Center(
                // padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Print Monthly Stock',
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return PrintAlert();
                    });
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  BlocProvider.of<StockviewBloc>(context).add(InitiateView());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListOfStockItems()));

                  // Navigator.push()
                  // var a = await RepositoryProvider.of<MyDatabase>(context)
                  //     .showStockwithDetails();
                  // for (var i in a) {
                  //   print(i);
                  // }
                },
                child: Text('List Item Page')),
          ],
        ),
      ),
    );
  }
}

class PrintAlert extends StatefulWidget {
  @override
  _PrintAlertState createState() => _PrintAlertState();
}

class _PrintAlertState extends State<PrintAlert> {
  List dataBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  var multivalue = 0;
  @override
  void initState() {
    multivalue = DateTime.now().month - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Print'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Month'),
              Padding(padding: EdgeInsets.all(16.0)),
              Expanded(
                child: DropdownButton<int>(
                  onChanged: (val) {
                    setState(() {
                      multivalue = val!;
                    });
                  },
                  items: [
                    for (int i = 0; i < 12; i++)
                      DropdownMenuItem(
                        child: Text(dataBulan[i].toString()),
                        value: i,
                        // onTap: () {},
                      ),
                  ],
                  value: multivalue,
                ),
              ),
            ],
          ),
          FutureBuilder(
              future: getApplicationDocumentsDirectory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'file saved at: ${snapshot.data}',
                    textScaleFactor: 0.7,
                  );
                }
                return Container();
              }),
          // CupertinoDatePicker(onDateTimeChanged: (val){},,)
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Directory a = await getApplicationDocumentsDirectory();
              var curdate = DateTime.now();
              // String month = multivalue.toString().length == 1
              //     ? '0' + (multivalue + 1).toString()
              //     : (multivalue + 1).toString();
              var data = await RepositoryProvider.of<MyDatabase>(context)
                  .showStockwithDetails(
                      startDate: DateTime(curdate.year, multivalue + 1, 1),
                      endDate: DateTime(curdate.year, multivalue + 2, 1)
                          .subtract(Duration(days: 1)));
              print(a.path);
              print(data);
              if (data.isNotEmpty) {
                File theFile =
                    File(a.path + '/backup_${dataBulan[multivalue]}.csv');
                double totalkeluar = 0.0;
                List<List> datalist = [
                  // ['...']
                ];
                //  (data['res'] as List)
                //     .map<List>((e) => [
                //           e['ADD_DATE'].toString().substring(0, 10),
                //           e['NAMA'],
                //           e['PRICE'],
                //           e['QTY'],
                //           e['SUPPLIER']
                //         ])
                //     .toList();
                // var e = data['res'];
                for (var i = 0; i < data.length; i++) {
                  if (i == 0) {
                    // var x = DateTime.parse(
                    //     e[i]['ADD_DATE'].toString().substring(0, 10));
                    var y = DateFormat('EEEE').format(data[i].stock.dateAdd!);
                    print('y=$y');

                    datalist.add([
                      y +
                          ', ' +
                          data[i].stock.dateAdd!.toString().substring(0, 10),
                    ]);
                    print('here');
                  } else if (data[i]
                          .stock
                          .dateAdd!
                          .toString()
                          .substring(0, 10) !=
                      data[i - 1].stock.dateAdd!.toString().substring(0, 10)) {
                    // var x = DateTime.parse(
                    //     e[i]['ADD_DATE'].toString().substring(0, 10));
                    var y = DateFormat('EEEE').format(data[i].stock.dateAdd!);
                    datalist.add([
                      y +
                          ', ' +
                          data[i].stock.dateAdd!.toString().substring(0, 10),
                    ]);
                  }
                  datalist.addAll({
                    [
                      data[i].stock.dateAdd!.toString().substring(0, 10),
                      data[i].item.nama,
                      data[i].stock.price,
                      data[i].stock.qty,
                      data[i].tempatBeli.nama,
                    ]
                  });
                }
                // datalist.insert(0, [
                //   data['res'][0]['ADD_DATE'].toString().substring(0, 10),
                // ]);
                for (var item in datalist) {
                  if (item.length > 2) {
                    totalkeluar += item[2] * item[3];
                  }
                }
                datalist[0]
                  ..add('')
                  ..add('')
                  ..add('')
                  ..add('Total bulan ini : ')
                  ..add(totalkeluar);
                var b = ListToCsvConverter().convert(datalist);
                try {
                  await theFile.writeAsString(b, mode: FileMode.write);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Successfully printed'),
                  ));
                } catch (e) {
                  print(e);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('error'),
                          content: Text(e.toString()),
                        );
                      });
                }
                print('end');
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('No data on selected month'),
                      );
                    });
              }
            },
            child: Text('Print'))
      ],
    );
  }
}
