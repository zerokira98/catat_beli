import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir/bloc/stockview/stockview_bloc.dart';
import 'package:kasir/msc/db_moor.dart';
import 'package:kasir/page/more_page/print.dart';
import 'package:kasir/page/stockview/stockview.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

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
          crossAxisCount: 8,
          children: [
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
