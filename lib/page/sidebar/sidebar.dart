import 'dart:io';

import 'package:catatbeli/bloc/cubit/theme_cubit.dart';
import 'package:catatbeli/msc/backupfile_uploader.dart';
import 'package:flutter/foundation.dart';
// import 'package:catatbeli/msc/db_moor.dart';
import 'package:catatbeli/page/statistic_page/statistic_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:catatbeli/bloc/stockview/stockview_bloc.dart';
import 'package:catatbeli/page/more_page/item_prop.dart';
import 'package:catatbeli/page/more_page/print.dart';
import 'package:catatbeli/page/more_page/tempat.dart';
import 'package:catatbeli/page/stockview/stockview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flex_color_scheme/flex_color_scheme.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  FlexScheme? dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      Container(
        height: 160,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Pencatatan Pembelian',
                  textScaler: TextScaler.linear(1.35),
                  style: TextStyle(color: Colors.white),
                )),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView(children: [
          ListTile(
            leading: Icon(Icons.history),
            subtitle: Text('Data Masuk Barang'),
            onTap: () {
              BlocProvider.of<StockviewBloc>(context).add(InitiateView());
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ListOfStockItems()));
            },
            title: Text('Riwayat Stock'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            subtitle: Text('Nama, barcode, dsb.'),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ListOfItems()));
            },
            title: Text('Edit Barang'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => TempatEdit()));
            },
            title: Text('Ganti Nama Tempat'),
          ),
          ListTile(
            leading: Icon(Icons.print),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return PrintAlert();
                  });
            },
            title: Text('Print to Excel'),
          ),
          ListTile(
            leading: Icon(Icons.auto_graph),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => StatsPage(),
                  ));
              // ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('not implemented yet, sorry')));
            },
            title: Text('Statistik'),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            onLongPress: () {
              BackupfileUploader()
                  .backup()
                  .onError<Exception>((Exception e, d) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              });
            },
            onTap: () async {
              final dbFolder = await getApplicationDocumentsDirectory();
              final file = File(p.join(dbFolder.path, 'db.sqlite'));
              bool exist = await file.exists();
              if (exist) {
                debugPrint('Exzist');
                if (Platform.isAndroid) {
                  final params = SaveFileDialogParams(
                      sourceFilePath: file.path,
                      fileName:
                          '${DateTime.now().toString().substring(0, 10)}.db');
                  final filePath =
                      await FlutterFileDialog.saveFile(params: params);
                  if (filePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('cancelled')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('file saved at:$filePath')));
                  }
                } else if (!Platform.isAndroid) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('not implemented yet, sorry')));
                }
              }
            },
            title: Text('Backup .db'),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            onLongPress: () {
              showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Alert!'),
                  content: Text('it will replace/remove all datas'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Sure')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('Cancel')),
                  ],
                ),
              ).then(
                (value) => value!
                    ? BackupfileUploader().restore().onError<Exception>((e, s) {
                        if (e.toString().contains('newer')) {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(SnackBar(
                              content: Text(e.toString()),
                              action: SnackBarAction(
                                  label: 'replace',
                                  onPressed: () =>
                                      BackupfileUploader().restore(true)),
                            ));
                          return;
                        }
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(content: Text(e.toString())));
                      })
                    : ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('cancelled'))),
              );
            },
            onTap: () async {
              List sqliteHead = [
                '53',
                '51',
                '4c',
                '69',
                '74',
                '65',
                '20',
                '66',
                '6f',
                '72',
                '6d',
                '61',
                '74',
                '20',
                '33',
                '00'
              ];
              List aeh =
                  sqliteHead.map((e) => int.parse(e, radix: 16)).toList();
              if (Platform.isAndroid) {
                try {
                  final filePath = await FlutterFileDialog.pickFile();
                  if (filePath == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('cancelled:')));
                  } else {
                    File selectedFile = File(filePath);
                    if (await selectedFile.exists()) {
                      var bytes = await selectedFile.readAsBytes();
                      if (listEquals(bytes.sublist(0, 16), aeh)) {
                        final dbFolder =
                            await getApplicationDocumentsDirectory();
                        final file = File(p.join(dbFolder.path, 'db.sqlite'));
                        file.writeAsBytes(await selectedFile.readAsBytes());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('wrong file type')));
                      }
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('cancelled:' + e.toString())));
                }
              }
              if (Platform.isWindows) {
                try {
                  var dbFolder = await getApplicationDocumentsDirectory();
                  var a = await FilePicker.platform
                      .pickFiles(initialDirectory: dbFolder.path);

                  if (a != null && a.isSinglePick) {
                    final importedFile = File(a.files[0].path!);
                    var huh = await importedFile.readAsBytes();
                    if (listEquals(huh.sublist(0, 16), aeh)) {
                      final file = File(p.join(dbFolder.path, 'db.sqlite'));
                      file.writeAsBytes(await importedFile.readAsBytes());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('wrong file type')));
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('cancelled:' + e.toString())));
                }
              }
            },
            title: Text('Restore .db'),
          ),
          ListTile(
            title: Column(
              children: [Text('DarkMode'), Icon(Icons.dark_mode)],
            ),
            onTap: () async {
              context.read<ThemeCubit>().changeDarkLight();
            },
          ),
          Row(
            children: [
              Text('Color : '),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<FlexScheme>(
                  isExpanded: true,
                  items: [
                    for (FlexScheme a in FlexScheme.values)
                      DropdownMenuItem(
                        child: Text(a.name),
                        value: a,
                      ),
                  ],
                  value: dropdownvalue,
                  onChanged: (value) {
                    dropdownvalue = value;
                    if (value != null) {
                      context.read<ThemeCubit>().changeColorScheme(value);
                    }
                  },
                ),
              )),
            ],
          )
        ]),
      )
    ]));
  }
}
