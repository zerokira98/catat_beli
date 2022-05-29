import 'dart:io';

import 'package:catatbeli/msc/db_moor.dart';
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

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      Container(
        height: 180,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Pencatatan Pembelian',
                  textScaleFactor: 1.3,
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
            trailing: Icon(Icons.edit),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListOfItems()));
            },
            title: Text('Ganti deskripsi produk'),
          ),
          ListTile(
            trailing: Icon(Icons.list_alt_rounded),
            onTap: () {
              BlocProvider.of<StockviewBloc>(context).add(InitiateView());
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListOfStockItems()));
            },
            title: Text('Riwayat Stock'),
          ),
          ListTile(
            trailing: Icon(Icons.edit),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => TempatEdit()));
            },
            title: Text('Tempat edit'),
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
            title: Text('Print to csv'),
          ),
          ListTile(
            trailing: Icon(Icons.ac_unit),
            onTap: () async {
              final dbFolder = await getApplicationDocumentsDirectory();
              final file = File(p.join(dbFolder.path, 'db.sqlite'));
              bool exist = await file.exists();
              if (exist) {
                debugPrint('Exzist');
                final params = SaveFileDialogParams(
                    sourceFilePath: file.path,
                    fileName:
                        '${DateTime.now().toString().substring(0, 10)}.db');
                final filePath =
                    await FlutterFileDialog.saveFile(params: params);
              }
            },
            title: Text('Backup .db'),
          ),
          ListTile(
            trailing: Icon(Icons.ac_unit),
            onTap: () async {
              final filePath = await FlutterFileDialog.pickFile();
              if (filePath != null) {
                final importedFile = File(filePath);
                final dbFolder = await getApplicationDocumentsDirectory();
                final file = File(p.join(dbFolder.path, 'db.sqlite'));
                file.writeAsBytes(await importedFile.readAsBytes());
              }
            },
            title: Text('Restore .db'),
          ),
          // ListTile(
          //   title: Text('Telo'),
          //   onTap: () async {
          //     var a = await RepositoryProvider.of<MyDatabase>(context)
          //         .showInsideStock();
          //     print(a);
          //   },
          // )
        ]),
      )
    ]));
  }
}
