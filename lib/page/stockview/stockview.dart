import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir/bloc/stockview/stockview_bloc.dart';
import 'package:kasir/main.dart';
import 'package:kasir/model/itemcard.dart';

part 'card.dart';
part 'filterbox.dart';

final numFormat = new NumberFormat("#,##0", "id");

class ListOfStockItems extends StatelessWidget {
  final ScrollController _scontrol = ScrollController();
  @override
  Widget build(BuildContext context) {
    Widget a = Scaffold(
      bottomNavigationBar: Container(
        color: Colors.grey[700],
        // color: Theme.of(context).primaryColor,
        child: BlocBuilder<StockviewBloc, StockviewState>(
          builder: (context, state) {
            ///---------- Pagination
            if (state is StockviewLoaded) {
              return Row(
                children: [
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      if ((state.filter.maxRow / 20).floor() !=
                              state.filter.currentPage - 1 &&
                          state.filter.currentPage != 0) {
                        BlocProvider.of<StockviewBloc>(context).add(
                            FilterChange(state.filter.copyWith(
                                currentPage: state.filter.currentPage - 1)));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.arrow_left,
                        color: ((state.filter.maxRow / 20).floor() !=
                                    state.filter.currentPage - 1 &&
                                state.filter.currentPage != 0)
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.grey[350],
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            (state.filter.currentPage + 1).toString(),
                            textScaleFactor: 1.4,
                          ),
                          Text(
                            '/',
                            textScaleFactor: 1.4,
                          ),
                          Text(
                            ((state.filter.maxRow / 20).floor() + 1).toString(),
                            textScaleFactor: 1.4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print(state.filter.currentPage);
                      print((state.filter.maxRow / 20).floor());
                      if ((state.filter.maxRow / 20).floor() + 1 !=
                          (state.filter.currentPage + 1)) {
                        BlocProvider.of<StockviewBloc>(context).add(
                            FilterChange(state.filter.copyWith(
                                currentPage: state.filter.currentPage + 1)));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.arrow_right,
                        color: ((state.filter.maxRow / 20).floor() + 1 !=
                                (state.filter.currentPage + 1))
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              );
            }
            return Container();
          },
        ),
        height: 42,
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Histori tambah stock'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                BlocProvider.of<StockviewBloc>(context).add(InitiateView());
              }),
          Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  // BlocProvider.of<StockviewBloc>(context).add(Initializeview());
                  Scaffold.of(context).showBottomSheet(
                      (context) => Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Container(color: Colors.transparent)),
                              ),
                              FilterBox(),
                            ],
                          ),
                      backgroundColor: Colors.black26);
                }),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            // FilterBox(),
            Expanded(
              child: BlocBuilder<StockviewBloc, StockviewState>(
                  builder: (context, state) {
                if (state is StockviewLoaded) {
                  var widget;
                  if (state.datas.isEmpty) {
                    widget = Column(
                      children: [
                        Row(children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(bottom: 8.0),
                              color: Colors.grey[700],
                              child: Text(
                                state.filter.startDate
                                    .toString()
                                    .substring(0, 10),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ]),
                        Expanded(child: Center(child: Text('Empty!'))),
                      ],
                    );
                  }
                  widget = ListView.builder(
                    key: UniqueKey(),
                    controller: _scontrol,
                    padding: EdgeInsets.only(bottom: 12),
                    itemBuilder: (context, i) {
                      ItemCards data = state.datas[i];
                      // print(data.ditambahkan);
                      // return Container();
                      return Column(
                        children: [
                          ///---- date seperator
                          if ((i >= 1 &&
                                  data.ditambahkan
                                          .toString()
                                          .substring(0, 10) !=
                                      state.datas[i - 1].ditambahkan
                                          .toString()
                                          .substring(0, 10)) ||
                              i == 0)
                            Row(children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  color: Colors.grey[700],
                                  child: Text(
                                    data.ditambahkan
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ]),

                          ///------
                          StockviewCard(data, Key(data.cardId.toString())),
                        ],
                      );
                    },
                    itemCount: state.datas.length,
                  );
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 450),
                    child: widget,
                  );
                }
                return CircularProgressIndicator();
              }),
            ),
          ],
        ),
      ),
    );
    return (Platform.isWindows)
        ? CustomWindow(
            child: a,
          )
        : a;
  }
}
