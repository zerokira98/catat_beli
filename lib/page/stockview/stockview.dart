import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:catatbeli/page/statistic_page/statistic_per_item.dart';
import 'package:catatbeli/page/stockview/edit_stock/edit_stock.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:catatbeli/bloc/stockview/stockview_bloc.dart';
import 'package:catatbeli/main.dart';
import 'package:catatbeli/model/itemcard.dart';

part 'card.dart';
part 'filterbox.dart';
part 'bottom_bar.dart';

final numFormat = new NumberFormat("#,##0", 'id_ID');

class ListOfStockItems extends StatefulWidget {
  final bool search;

  ListOfStockItems({bool? search}) : this.search = search ?? false;

  @override
  State<ListOfStockItems> createState() => _ListOfStockItemsState();
}

class _ListOfStockItemsState extends State<ListOfStockItems> {
  final ScrollController _scontrol = ScrollController();
  // Key scaffkey =GlobalKey<Scaff>();
  bool search = false;
  // bool maxScroll = false;
  // bool zeroScroll = true;
  final format = DateFormat('d MMMM y', 'id_ID');
  @override
  void initState() {
    // _scontrol.addListener(() {
    //   if (_scontrol.offset == _scontrol.position.maxScrollExtent) {}
    // });
    search = widget.search;
    super.initState();
    if (mounted && search) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showBottomSheet(
          context: context,
          builder: (context) => Column(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(color: Colors.transparent)),
              ),
              FilterBox(),
            ],
          ),
          backgroundColor: Colors.black26,
        );
        setState(() {
          search = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Scaffold(
      // key: ,
      appBar: AppBar(
        actions: [
          BlocBuilder<StockviewBloc, StockviewState>(
            builder: (context, state) {
              if (state is StockviewLoaded) {
                return IconButton(
                    onPressed: () async {
                      var db = await RepositoryProvider.of<MyDatabase>(context)
                          .showStockwithDetails(filter: state.filter);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticperPage(data: db),
                          ));
                    },
                    icon: Icon(Icons.bar_chart_rounded));
              }
              return SizedBox();
            },
          )
        ],
        // backgroundColor: Colors.grey[800],
        title: BlocBuilder<StockviewBloc, StockviewState>(
            builder: (context, state) {
          if (state is StockviewLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Riwayat stock'),
                Text(
                  format
                          .format(((BlocProvider.of<StockviewBloc>(context)
                                  .state as StockviewLoaded)
                              .filter
                              .startDate))
                          .toString() +
                      // .substring(0, 10) +
                      ' - ' +
                      format
                          .format(((BlocProvider.of<StockviewBloc>(context)
                                  .state as StockviewLoaded)
                              .filter
                              .endDate))
                          .toString(),
                  textScaleFactor: 0.65,
                )
              ],
            );
          }
          return CircularProgressIndicator();
        }),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.grey[100],
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                              Expanded(child: Center(child: Text('Empty!'))),
                            ],
                          );
                        } else {
                          widget = RefreshIndicator(
                            onRefresh: () async {
                              var block =
                                  BlocProvider.of<StockviewBloc>(context)
                                      .stream
                                      .first;
                              print((block as StockviewLoaded).filter);
                              BlocProvider.of<StockviewBloc>(context)
                                  .add(Refresh());
                              await block;
                            },
                            child: ListView.builder(
                              key: UniqueKey(),
                              controller: _scontrol,
                              padding: EdgeInsets.only(bottom: 42),
                              itemBuilder: (context, i) {
                                ItemCards data = state.datas[i];
                                return Column(
                                  children: [
                                    ///---- date separator
                                    if ((i >= 1 &&
                                            data.ditambahkan
                                                    .toString()
                                                    .substring(0, 10) !=
                                                state.datas[i - 1].ditambahkan
                                                    .toString()
                                                    .substring(0, 10)) ||
                                        i == 0)
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                margin: EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                  Theme.of(context)
                                                      .primaryColorDark,
                                                  Theme.of(context)
                                                      .primaryColorDark,
                                                  Theme.of(context)
                                                      .primaryColorDark
                                                      .withOpacity(0.45)
                                                ])),
                                                // color: ,
                                                child: Text(
                                                  DateFormat('EEEE, d MMMM y',
                                                          'id_ID')
                                                      .format(data.ditambahkan!)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ]),

                                    ///------end of date seperator
                                    StockviewCard(
                                        data, Key(data.cardId.toString())),
                                  ],
                                );
                              },
                              itemCount: state.datas.length,
                            ),
                          );
                        }
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 450),
                          child: widget,
                          // switchInCurve: Curves,
                          transitionBuilder: (child, animation) {
                            var begin = 0.0;
                            var end = 1.0;
                            final tween = Tween(begin: begin, end: end).animate(
                                CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut));
                            return SizeTransition(
                              sizeFactor: tween,
                              child:
                                  FadeTransition(opacity: tween, child: child),
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomBar(scontrol: _scontrol)),
        ],
      ),
    );
    return (Platform.isWindows)
        ? CustomWindow(
            child: body,
          )
        : body;
  }
}
