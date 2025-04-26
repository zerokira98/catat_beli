import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';

class BackupfileUploader {
  var dio = Dio(BaseOptions(
      baseUrl:
          !kDebugMode ? 'http://192.168.0.211:3000' : 'http://10.0.2.2:3000'));
  Future restore([bool force = false]) async {
    print('restore');
    // var a = await dio.post("/restoreapi");
    var file = File(p.join(
        (await getApplicationDocumentsDirectory()).path, 'downloaded.db'));
    var dbfile = File(
        p.join((await getApplicationDocumentsDirectory()).path, 'db.sqlite'));
    var b = await dio.get("/restoreapi");
    var jsondata = (jsonDecode(b.data));
    print(dbfile.lastModifiedSync());
    print(jsondata['last_modified']);
    if (dbfile
            .lastModifiedSync()
            .isBefore(DateTime.parse(jsondata["last_modified"])) |
        force) {
      print('come ');
      var c = await dio.download(jsondata["download_url"], file.path,
          options: Options(responseType: ResponseType.bytes));
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
      var fileread = file.readAsBytesSync();
      List aeh = sqliteHead.map((e) => int.parse(e, radix: 16)).toList();
      if (listEquals(fileread.sublist(0, 16), aeh)) {
        print('sqlite file, replacing ...');
        await dbfile.writeAsBytes(fileread);
      } else {
        throw Exception('not sqlite file');
      }
    } else {
      print('db is newer,aborting');
      throw Exception('client\'s db is newer');
    }
    // print(aeh);
    // print(file.readAsBytesSync());
    // print(dbfile.readAsBytesSync());
    // print(a.headers);
    // print(a);
    // print(a.data.runtimeType);
  }

  Future backup() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    bool exist = await file.exists();

    var fileName = '${(await file.lastModified()).toString()}.db';
    var hash = sha256.convert(file.readAsBytesSync());
    // print(hash);
    var checkfile = await dio.post('/checkfile',
        data: FormData.fromMap({
          'hash': hash.toString(),
          'last_modified': (await file.lastModified()).toIso8601String(),
        }));
    print(checkfile.data);
    if (checkfile.data.toString().contains('diff')) {
      print('proceed to upload');

      await dio.post(
        '/backupapi',
        // data: FormData.fromMap({})
        data: FormData.fromMap({
          "hash": hash,
          "last_modified": (await file.lastModified()).toIso8601String(),
          'file': await MultipartFile.fromFile(file.path, filename: fileName),
        }),
      );
    } else {
      print('same file, aborted');
      throw Exception('same file, aborted');
    }
  }

  Future restoreForce() async {}
}
