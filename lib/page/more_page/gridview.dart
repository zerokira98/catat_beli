import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir/bloc/stockview/stockview_bloc.dart';
// import 'package:kasir/msc/db_moor.dart';
import 'package:kasir/page/more_page/item_prop.dart';
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
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 8
                  : 3,
          children: [
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListOfItems()));
                  // var a = await RepositoryProvider.of<MyDatabase>(context)
                  //     .dataStock;
                  // print(a);
                },
                child: Text('Edit Item')),
            ElevatedButton(
              child: Center(
                // padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.print),
                    Flexible(
                      child: Text(
                        'Print Monthly Stock',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.list),
                    Flexible(
                        child: Center(
                            child: Text(
                      'List Inserted Item',
                      textAlign: TextAlign.center,
                    ))),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
