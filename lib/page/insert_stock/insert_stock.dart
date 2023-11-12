import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:catatbeli/bloc/stockview/stockview_bloc.dart';
import 'package:catatbeli/model/itemcard_formz.dart';
import 'package:catatbeli/page/sidebar/sidebar.dart';
import 'package:catatbeli/page/stockview/stockview.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:drift/drift.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:catatbeli/bloc/stock/insertstock_bloc.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
part 'insert_card.dart';
part 'insert_components.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  ScrollController scrollc = ScrollController();
  bool disabletap = false;
  bool shadowColor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: shadowColor
              ? Theme.of(context).colorScheme.shadow
              : Colors.transparent,
          title: Text('Masuk Barang'),
          actions: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    var state =
                        (BlocProvider.of<InsertstockBloc>(context).state);

                    BlocProvider.of<InsertstockBloc>(context)
                        .add(SendtoDB(state.data));
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight.lighten(),
                        boxShadow: [BoxShadow(blurRadius: 2.0)],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BlocBuilder<InsertstockBloc, InsertstockState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Submit',
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (!disabletap) {
              disabletap = true;
              BlocProvider.of<InsertstockBloc>(context).add(AddCard());
              FocusScope.of(context).unfocus();
              await Future.delayed(Duration(milliseconds: 460), () {});
              var seconds = 500;

              await scrollc.animateTo(scrollc.position.maxScrollExtent,
                  duration: Duration(
                      milliseconds:
                          (scrollc.position.maxScrollExtent - scrollc.offset)
                                  .ceil() +
                              seconds),
                  curve: Curves.easeInOut);
              disabletap = false;
            }
          },
          tooltip: 'Add New Item',
          elevation: 0.0,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: BottomAppBar(
          child: Container(
            child: Row(
              children: [
                ElevatedButton.icon(
                    label: Text('Search'),
                    onPressed: () {
                      BlocProvider.of<StockviewBloc>(context)
                          .add(InitiateView(search: true));
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Scaffold(
                                    body: ListOfStockItems(search: true),
                                  )));
                    },
                    icon: Icon(Icons.search)),
                Padding(padding: EdgeInsets.only(right: 4)),
                ElevatedButton.icon(
                  label: Text('Clear all'),
                  onPressed: () {
                    var state = BlocProvider.of<InsertstockBloc>(context).state;
                    BlocProvider.of<InsertstockBloc>(context)
                        .add(ClearAll(beforeState: state));
                  },
                  icon: Icon(Icons.delete_sweep),
                  // tooltip: 'Hapus Semua',
                ),
                Padding(padding: EdgeInsets.all(4)),
              ],
            ),
          ),
        ),
        body: BlocListener<InsertstockBloc, InsertstockState>(
          listener: (context, state) {
            if (state.isLoaded) {
              if (state.data.isEmpty) {
                BlocProvider.of<InsertstockBloc>(context).add(Initiate());
              }
              if (state.isSuccess != null) {
                if (state.isSuccess!) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: const Text('Berhasil'),
                  ));
                } else {
                  if (state.msg != null && state.msg!.isNotEmpty)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Terjadi kesalahan:${state.msg!}'),
                    ));
                }
              }
            }
            if (state.msg != null) {
              if (state.msg!.contains('Cleared')) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Cleared'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      BlocProvider.of<InsertstockBloc>(context)
                          .add(Initiate(fromstate: state.beforeState));
                      print(state.beforeState);
                    },
                  ),
                ));
              }
              print(state.msg);
            }
          },
          child: Container(
            child: BlocBuilder<InsertstockBloc, InsertstockState>(
              builder: (context, state) {
                if (state.isLoading) {
                  if (state.isLoaded == false) {
                    return Center(
                      child: ElevatedButton(
                        child: Text('Load'),
                        onPressed: () =>
                            BlocProvider.of<InsertstockBloc>(context)
                                .add(Initiate()),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }
                if (state.isLoaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? MediaQuery.of(context).size.width * 0.05
                                  : 4),
                          child: ListView.builder(
                            itemCount: state.data.length,
                            controller: scrollc,
                            itemBuilder: (context, i) => Row(children: [
                              Column(
                                children: [
                                  Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    '-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: i % 2 == 0
                                            ? Colors.blue
                                            : Colors.yellow),
                                  )
                                ],
                              ),
                              Expanded(
                                child: InsertProductCard(
                                    state.data[i],
                                    Key(state.data[i].cardId.toString()),
                                    scrollc),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
