import 'dart:io';

// import 'package:catatbeli/msc/db_moor.dart';
// import 'package:catatbeli/msc/db_moor.dart';
import 'package:catatbeli/bloc/cubit/theme_cubit.dart';
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
                  textScaleFactor: 1.35,
                  style: TextStyle(color: Colors.white),
                )),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView(children: [
          // ListTile(
          //   trailing: Icon(Icons.history),
          //   subtitle: Text('Dev deug'),
          //   onTap: () async {
          //     var a = await RepositoryProvider.of<MyDatabase>(context)
          //         .showInsideStock(idBarang: 91);
          //     print(a);
          //     // BlocProvider.of<StockviewBloc>(context).add(InitiateView());
          //     // Navigator.push(context,
          //     //     CupertinoPageRoute(builder: (context) => ListOfStockItems()));
          //   },
          //   title: Text('dev debug '),
          // ),
          ListTile(
            trailing: Icon(Icons.history),
            subtitle: Text('Data Masuk Barang'),
            onTap: () {
              BlocProvider.of<StockviewBloc>(context).add(InitiateView());
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ListOfStockItems()));
            },
            title: Text('Riwayat Stock'),
          ),
          ListTile(
            trailing: Icon(Icons.edit),
            subtitle: Text('Nama & barcode'),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ListOfItems()));
            },
            title: Text('Ganti Nama Barang'),
          ),
          ListTile(
            trailing: Icon(Icons.edit),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => TempatEdit()));
            },
            title: Text('Ganti Nama Tempat'),
          ),
          ListTile(
            trailing: Icon(Icons.print),
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
            trailing: Icon(Icons.auto_graph),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('not implemented yet, sorry')));
            },
            title: Text('Statistik'),
          ),
          ListTile(
            trailing: Icon(Icons.ac_unit),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('file saved at:$filePath')));
                } else if (!Platform.isAndroid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('not implemented yet, sorry')));
                }
              }
            },
            title: Text('Backup .db'),
          ),
          ListTile(
            trailing: Icon(Icons.ac_unit),
            onTap: () async {
              if (Platform.isAndroid) {
                final filePath = await FlutterFileDialog.pickFile();
                if (filePath != null) {
                  final importedFile = File(filePath);
                  final dbFolder = await getApplicationDocumentsDirectory();
                  final file = File(p.join(dbFolder.path, 'db.sqlite'));
                  file.writeAsBytes(await importedFile.readAsBytes());
                }
              }
              if (Platform.isWindows) {
                try {
                  var dbFolder = await getApplicationDocumentsDirectory();
                  var a = await FilePicker.platform
                      .pickFiles(initialDirectory: dbFolder.path);
                  print(a);
                  if (a != null && a.isSinglePick) {
                    final importedFile = File(a.files[0].path!);
                    final file = File(p.join(dbFolder.path, 'db.sqlite'));
                    file.writeAsBytes(await importedFile.readAsBytes());
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
