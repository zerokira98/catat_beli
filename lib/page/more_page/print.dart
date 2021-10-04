import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:kasir/msc/db_moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Platform.isWindows
              ? FutureBuilder(
                  future: getApplicationDocumentsDirectory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'file saved at: ${snapshot.data}',
                        textScaleFactor: 0.7,
                      );
                    }
                    return Container();
                  })
              : Container(),
          // CupertinoDatePicker(onDateTimeChanged: (val){},,)
        ],
      ),
      actions: [
        if (Platform.isWindows)
          TextButton(
              onPressed: () async {
                var uwu = await getApplicationDocumentsDirectory();
                Process.run("explorer", [uwu.path]);
              },
              child: Text('Open Directory')),
        TextButton(
            onPressed: () async {
              Directory a = await getApplicationDocumentsDirectory();
              var curdate = DateTime.now();
              var data = await RepositoryProvider.of<MyDatabase>(context)
                  .showStockwithDetails(
                      startDate: DateTime(curdate.year, multivalue + 1, 1),
                      endDate: DateTime(curdate.year, multivalue + 2, 1)
                          .subtract(Duration(days: 1)));
              if (data.isNotEmpty) {
                File theFile =
                    File(a.path + '/backup_${dataBulan[multivalue]}.csv');
                // bool isExist = await theFile.exists();
                double totalkeluar = 0.0;
                List<List> datalist = [
                  // ['...']
                ];

                ///---- Create Separator for each day
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

                ///-------Menghitung total pengeluaran bulan ini
                for (var item in datalist) {
                  if (item.length > 2) {
                    totalkeluar += item[2] * item[3];
                  }
                }
                datalist[0]
                  ..add('')
                  ..add('')
                  ..add('')
                  ..add('')
                  ..add('Total bulan ini : ')
                  ..add(totalkeluar);

                ///--------
                var b = ListToCsvConverter().convert(datalist);
                // bool dialog = true; //true if u want to override or continue
                // if (isExist) {
                //   dialog = await showDialog(
                //       context: context,
                //       builder: (context) {
                //         return AlertDialog(
                //           title: Text('Alert'),
                //           content: Text(
                //               'File with the same name is already exist.Overwrite?'),
                //           actions: [
                //             TextButton(
                //                 onPressed: () {
                //                   Navigator.pop(context, true);
                //                 },
                //                 child: Text('Yes')),
                //             TextButton(
                //                 onPressed: () {
                //                   Navigator.pop(context, false);
                //                 },
                //                 child: Text('Cancel')),
                //           ],
                //         );
                //       });
                // }
                // if (dialog) {
                try {
                  var savedfile =
                      await theFile.writeAsString(b, mode: FileMode.write);
                  if (Platform.isAndroid) {
                    final params =
                        SaveFileDialogParams(sourceFilePath: savedfile.path);
                    final filePath =
                        await FlutterFileDialog.saveFile(params: params);
                    print(filePath);
                  }

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
              }
              // }
              else {
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
