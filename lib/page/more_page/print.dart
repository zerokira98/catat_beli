import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir/msc/db_moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

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
