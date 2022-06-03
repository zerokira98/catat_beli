// import 'dart:io';

// import 'package:catatbeli/msc/db_moor.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';

// // import 'package:file/file.dart';

// class PrintXlsx {
//   MyDatabase db;
//   PrintXlsx(this.db);
//   // PrintXlsx get instance=>PrintXlsx(db);
//   main(
//     String bulan,
//   ) async {
//     var excel = Excel.createExcel();
//     var sheet = excel['${bulan}'];
//     var data = await RepositoryProvider.of<MyDatabase>(context)
//         .showStockwithDetails(
//             startDate: DateTime(curdate.year, multivalue + 1, 1),
//             endDate: DateTime(curdate.year, multivalue + 2, 1)
//                 .subtract(Duration(days: 1)));
//     sheet.cell(CellIndex.indexByColumnRow(
//       columnIndex: 0,
//       rowIndex: 0,
//     ));
//     var docPath = await getApplicationDocumentsDirectory();
//     var filePath = docPath.path + bulan;
//     // var file = File(path);
//   }
// }
