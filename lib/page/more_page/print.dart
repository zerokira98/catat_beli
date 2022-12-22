import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum Periodtime { monthly, yearly }

class PrintAlert extends StatefulWidget {
  @override
  _PrintAlertState createState() => _PrintAlertState();
}

class _PrintAlertState extends State<PrintAlert> {
  final numFormat = NumberFormat.currency(locale: "id_ID", symbol: 'Rp.');
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
  var period = Periodtime.monthly;
  var selectedDateYear = DateTime.now().year;

  @override
  void initState() {
    multivalue = DateTime.now().month - 1;
    super.initState();
  }

  convert(BuildContext context) async {
    Directory a = await getApplicationDocumentsDirectory();
    // var curdate = DateTime.now();
    // print(DateTime(curdate.year, multivalue + 2, 0));
    var data = await RepositoryProvider.of<MyDatabase>(context)
        .showStockwithDetails(
            startDate: DateTime(selectedDateYear, multivalue + 1, 1),
            endDate: DateTime(selectedDateYear, multivalue + 2, 0)
                .add(Duration(hours: 23, minutes: 59, seconds: 59)));

    ////////////////------------------
    ///
    var excel = Excel.createExcel();
    var sheet = excel['${dataBulan[multivalue]}' + ' ' + '${selectedDateYear}'];
    excel.delete('Sheet1');
    num total = 0;
    num totalHarian = 0;
    for (var i = 0; i < data.length; i++) {
      //Date Separator
      if (i == 0) {
        var y = DateFormat('EEEE, d/M/y').format(data[i].stock.dateAdd!);
        sheet.appendRow([y]);
        // print(sheet.maxRows - 1);
        sheet.merge(
            CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: sheet.maxRows - 1),
            CellIndex.indexByColumnRow(
                columnIndex: 5, rowIndex: sheet.maxRows - 1),
            customValue: y);
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: sheet.maxRows - 1))
            .cellStyle = CellStyle(backgroundColorHex: '#faf487');
      } else if (data[i].stock.dateAdd!.toString().substring(0, 10) !=
          data[i - 1].stock.dateAdd!.toString().substring(0, 10)) {
        var y = DateFormat('EEEE, d/M/y').format(data[i].stock.dateAdd!);
        sheet.appendRow(
            ['', '', '', 'total hari ini :', numFormat.format(totalHarian)]);
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 4, rowIndex: sheet.maxRows - 1))
            .cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right);
        totalHarian = 0;
        sheet.appendRow([y]);
        sheet.merge(
            CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: sheet.maxRows - 1),
            CellIndex.indexByColumnRow(
                columnIndex: 5, rowIndex: sheet.maxRows - 1),
            customValue: y);
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: sheet.maxRows - 1))
            .cellStyle = CellStyle(backgroundColorHex: '#faf487');
      }
      sheet.appendRow([
        data[i].stock.dateAdd!.toString().substring(0, 10),
        data[i].item.nama,
        numFormat.format((data[i].stock.price)),
        data[i].stock.qty,
        numFormat.format(data[i].stock.qty * data[i].stock.price),
        data[i].tempatBeli.nama,
      ]);
      total += (data[i].stock.qty * data[i].stock.price);
      totalHarian += (data[i].stock.qty * data[i].stock.price);
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 2, rowIndex: sheet.maxRows - 1))
          .cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right);
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: 4, rowIndex: sheet.maxRows - 1))
          .cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right);
      if (i == data.length - 1) {
        sheet.appendRow(
            ['', '', '', 'total hari ini :', numFormat.format(totalHarian)]);
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 4, rowIndex: sheet.maxRows - 1))
            .cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right);
      }
    }
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
      ..value = 'Total bulan ini'
      ..cellStyle = CellStyle(textWrapping: TextWrapping.Clip);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value =
        numFormat.format(total);
    // print('telo goreng');
    for (var element in sheet.rows) {
      print(element);
    }
    var filebytes = excel.save();
    // print(filebytes);
    File theFile = File(
        a.path + '/Backup_${dataBulan[multivalue]}${selectedDateYear}.xlsx');
    theFile.createSync(recursive: true);
    theFile.writeAsBytesSync(filebytes!, mode: FileMode.write);
    // print(theFile.readAsBytesSync());
    if (Platform.isAndroid) {
      final params = SaveFileDialogParams(sourceFilePath: theFile.path);
      final filePath = await FlutterFileDialog.saveFile(params: params);
      print(filePath);
    }

    ///
    ///
    ///-------------------------------
    // if (data.isNotEmpty) {
    //   File theFile = File(a.path + '/Backup_${dataBulan[multivalue]}.csv');
    //   double totalkeluar = 0.0;
    //   List<List> datalist = [
    //     // ['...']
    //   ];

    //   ///---- Create Separator for each day
    //   for (var i = 0; i < data.length; i++) {
    //     if (i == 0) {
    //       // var x = DateTime.parse(
    //       //     e[i]['ADD_DATE'].toString().substring(0, 10));
    //       var y = DateFormat('EEEE').format(data[i].stock.dateAdd!);
    //       print('y=$y');

    //       datalist.add([
    //         y + ', ' + data[i].stock.dateAdd!.toString().substring(0, 10),
    //       ]);
    //       print('here');
    //     } else if (data[i].stock.dateAdd!.toString().substring(0, 10) !=
    //         data[i - 1].stock.dateAdd!.toString().substring(0, 10)) {
    //       // var x = DateTime.parse(
    //       //     e[i]['ADD_DATE'].toString().substring(0, 10));
    //       var y = DateFormat('EEEE').format(data[i].stock.dateAdd!);
    //       datalist.add([
    //         y + ', ' + data[i].stock.dateAdd!.toString().substring(0, 10),
    //       ]);
    //     }
    //     totalkeluar += data[i].stock.qty * data[i].stock.price;
    //     datalist.addAll({
    //       [
    //         data[i].stock.dateAdd!.toString().substring(0, 10),
    //         data[i].item.nama,
    //         numFormat.format((data[i].stock.price)),
    //         data[i].stock.qty,
    //         numFormat.format(data[i].stock.qty * data[i].stock.price),
    //         data[i].tempatBeli.nama,
    //       ]
    //     });
    //   }

    //   ///-------Menghitung total pengeluaran bulan ini
    //   // for (var item in datalist) {
    //   //   if (item.length > 2) {
    //   //     totalkeluar += int.parse(item[2]) * int.parse(item[3]);
    //   //   }
    //   // }
    //   datalist[0]
    //     ..add('')
    //     ..add('')
    //     ..add('')
    //     ..add('')
    //     ..add('Total bulan ini : ')
    //     ..add(numFormat.format(totalkeluar));

    //   ///--------
    //   var b = ListToCsvConverter().convert(datalist);
    //   bool dialog = true; //true if u want to override or continue
    //   if (Platform.isWindows) {
    //     bool isExist = await theFile.exists();
    //     if (isExist) {
    //       dialog = await showDialog(
    //           context: context,
    //           builder: (context) {
    //             return AlertDialog(
    //               title: Text('Alert'),
    //               content: Text(
    //                   'File with the same name is already exist.Overwrite?'),
    //               actions: [
    //                 TextButton(
    //                     onPressed: () {
    //                       Navigator.pop(context, true);
    //                     },
    //                     child: Text('Yes')),
    //                 TextButton(
    //                     onPressed: () {
    //                       Navigator.pop(context, false);
    //                     },
    //                     child: Text('Cancel')),
    //               ],
    //             );
    //           });
    //     }
    //   }
    //   if (dialog) {
    //     try {
    //       var savedfile = await theFile.writeAsString(b, mode: FileMode.write);
    //       if (Platform.isAndroid) {
    //         final params = SaveFileDialogParams(sourceFilePath: savedfile.path);
    //         final filePath = await FlutterFileDialog.saveFile(params: params);
    //         print(filePath);
    //       }

    //       Navigator.pop(context);
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         content: Text('Successfully printed'),
    //       ));
    //     } catch (e) {
    //       print(e);
    //       showDialog(
    //           context: context,
    //           builder: (context) {
    //             return AlertDialog(
    //               title: Text('error'),
    //               content: Text(e.toString()),
    //             );
    //           });
    //     }
    //     print('end');
    //   }
    // } else {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           content: Text('No data on selected month'),
    //         );
    //       });
    // }
  }

  List get dataTahun {
    List a = [];
    var an = DateTime.now().year;
    for (var i = 0; i <= 4; i++) {
      a.add((an - 4) + i);
    }
    print(a);
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Print'),
          Expanded(
              child: DropdownButton(
            alignment: Alignment.centerRight,
            isExpanded: true,
            value: period,
            onChanged: (Periodtime? value) {
              if (value != null) {
                setState(() {
                  period = value;
                });
              }
            },
            items: [
              DropdownMenuItem(
                alignment: Alignment.centerRight,
                child: Text('Monthly'),
                value: Periodtime.monthly,
              ),
              DropdownMenuItem(
                alignment: Alignment.centerRight,
                child: Text('Yearly'),
                value: Periodtime.yearly,
              ),
            ],
          ))
        ],
      ),
      actionsPadding: EdgeInsets.all(8.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (period == Periodtime.yearly)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Starts from January'),
            ),
          if (period == Periodtime.monthly)
            Row(
              children: [
                Text('Month'),
                Padding(padding: EdgeInsets.all(12.0)),
                Expanded(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    onChanged: (val) {
                      setState(() {
                        multivalue = val!;
                      });
                    },
                    items: [
                      for (int i = 0; i < 12; i++)
                        DropdownMenuItem(
                            child: Text(dataBulan[i].toString()), value: i)
                    ],
                    value: multivalue,
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Text('Year'),
              Padding(padding: EdgeInsets.all(12.0)),
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  onChanged: (val) {
                    if (val != null)
                      setState(() {
                        selectedDateYear = val;
                      });
                  },
                  items: [
                    for (int i = 0; i < 5; i++)
                      DropdownMenuItem(
                          child: Text(dataTahun[i].toString()),
                          value: dataTahun[i])
                  ],
                  value: selectedDateYear,
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Container(
          //         height: 100,
          //         child: YearPicker(
          //           selectedDate: selectedDate,
          //           firstDate: DateTime.now().subtract(Duration(days: 750)),
          //           lastDate: DateTime.now(),
          //           onChanged: (val) {
          //             selectedDate = val;
          //           },
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          Platform.isWindows
              ? FutureBuilder<Directory>(
                  future: getApplicationDocumentsDirectory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () async {
                          Process.run('explorer.exe ', [
                            '/select,',
                            '${snapshot.data!.path}\\Backup_${dataBulan[multivalue]}${selectedDateYear}.xlsx',
                          ]);
                          // var a = await launchUrl(Uri.parse(
                          //     'file:///${snapshot.data!.path}\\Backup_${dataBulan[multivalue]}.csv'));
                          // print(a);
                        },
                        child: Text(
                          'file saved at:\n${snapshot.data!.path}\\Backup_${dataBulan[multivalue]}${selectedDateYear}.xlsx',
                          textScaleFactor: 0.79,
                          style: TextStyle(color: Colors.blue),
                        ),
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
                await Process.run("explorer", [uwu.path]);
                // print(a);
              },
              child: Text('Open Directory')),
        TextButton(
            onPressed: () async {
              switch (period) {
                case Periodtime.monthly:
                  convert(context);
                  break;
                case Periodtime.yearly:
                  throw UnimplementedError();
                // break;
                default:
              }
            },
            child: Text('Print'))
      ],
    );
  }
}
