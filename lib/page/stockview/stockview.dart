import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
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
  final format = DateFormat('d MMMM y', 'id_ID');
  @override
  void initState() {
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
                          // print('length = ' + state.datas.length.toString());
                          widget = Column(
                            children: [
                              Expanded(child: Center(child: Text('Empty!'))),
                            ],
                          );
                        } else {
                          widget = ListView.builder(
                            key: UniqueKey(),
                            // reverse: state.filter.currentPage ==
                            //     state.filter.maxPage,
                            controller: _scontrol,
                            padding: EdgeInsets.only(bottom: 42),
                            itemBuilder: (context, i) {
                              ItemCards data = state.datas[i];
                              // if (state.filter.currentPage ==
                              //     state.filter.maxPage) {
                              //   data =
                              //       state.datas[(state.datas.length - 1) - i];
                              // }
                              // print(data.ditambahkan.weekday);
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
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              margin:
                                                  EdgeInsets.only(bottom: 8.0),
                                              color: Colors.grey[700],
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
                          );
                        }
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 450),
                          child: widget,
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
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              decoration: BoxDecoration(
                // border:
                //     Border(top: BorderSide(color: Colors.black12, width: 1)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(28, 8),
                    topRight: Radius.elliptical(28, 8)),
                boxShadow: [
                  BoxShadow(color: Colors.white54, offset: Offset(0, -1))
                ],
                color: Colors.grey[700],
              ),
              // color: Theme.of(context).primaryColor,
              child: BlocListener<StockviewBloc, StockviewState>(
                listener: (context, state) {
                  if (state is StockviewLoaded && state.message != null)
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message!)));
                },
                child: BlocBuilder<StockviewBloc, StockviewState>(
                  builder: (context, state) {
                    ///---------- Pagination
                    if (state is StockviewLoaded) {
                      // print('curr' + state.filter.currentPage.toString());
                      return Row(
                        children: [
                          ///Refresh to initState
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    shadows: [Shadow(blurRadius: 4)],
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<StockviewBloc>(context)
                                        .add(InitiateView());
                                  }),
                            ),
                          ),

                          ///Scroll up button
                          Container(
                            // alignment: Alignment.centerRight,
                            child: Builder(
                              builder: (context) => IconButton(
                                  padding: EdgeInsets.all(2),
                                  icon: Icon(
                                    Icons.keyboard_double_arrow_up,
                                    color: Colors.white,
                                    shadows: [Shadow(blurRadius: 4)],
                                  ),
                                  onPressed: () {
                                    _scontrol.animateTo(0,
                                        duration: Duration(milliseconds: 450),
                                        curve: Curves.easeInOut);
                                  }),
                            ),
                          ),

                          ///Previous page Button
                          InkWell(
                            onTap: () {
                              if (state.filter.currentPage > 0 &&
                                  state.filter.currentPage <=
                                      state.filter.maxPage) {
                                BlocProvider.of<StockviewBloc>(context).add(
                                    PageChange(state.filter.copyWith(
                                        currentPage:
                                            state.filter.currentPage - 1)));
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
                                color: (state.filter.currentPage > 0 &&
                                        state.filter.currentPage <=
                                            state.filter.maxPage)
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),

                          ///Page Numbering
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(18.0, 4.0)),
                              color: Theme.of(context).backgroundColor,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  final _formsKey = GlobalKey<FormState>();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        var pageTextControl =
                                            TextEditingController();
                                        return Dialog(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 42,
                                                  child: Form(
                                                    key: _formsKey,
                                                    child: TextFormField(
                                                      autofocus: true,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: (value) {
                                                        if (value != null &&
                                                            value.isNotEmpty) {
                                                          bool hah = (int.parse(
                                                                      value) -
                                                                  1) >
                                                              (state.filter
                                                                  .maxPage);
                                                          if (value == "0")
                                                            return 'cant be zero';
                                                          return hah
                                                              ? 'over'
                                                              : null;
                                                        }
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          pageTextControl,
                                                      onEditingComplete: () {
                                                        if (_formsKey
                                                            .currentState!
                                                            .validate()) {
                                                          BlocProvider.of<
                                                                      StockviewBloc>(
                                                                  context)
                                                              .add(PageChange(state
                                                                  .filter
                                                                  .copyWith(
                                                                      currentPage:
                                                                          int.parse(pageTextControl.text) -
                                                                              1)));
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  'Page'),
                                                    ),
                                                  )),
                                              Text('/'),
                                              Text((state.filter.maxPage + 1)
                                                  .toString()),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      (state.filter.maxPage + 1).toString(),
                                      textScaleFactor: 1.4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          ///Next page Button
                          InkWell(
                            onTap: () {
                              if (state.filter.maxPage >
                                  state.filter.currentPage) {
                                BlocProvider.of<StockviewBloc>(context).add(
                                    PageChange(state.filter.copyWith(
                                        currentPage:
                                            state.filter.currentPage + 1)));
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
                                color: (state.filter.maxPage >
                                        (state.filter.currentPage))
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),

                          ///Scroll down Button
                          Container(
                            alignment: Alignment.centerRight,
                            child: Builder(
                              builder: (context) => IconButton(
                                  padding: EdgeInsets.all(2),
                                  icon: Icon(
                                    Icons.keyboard_double_arrow_down,
                                    color: Colors.white,
                                    shadows: [Shadow(blurRadius: 4)],
                                  ),
                                  onPressed: () {
                                    // print(_scontrol.position.maxScrollExtent);
                                    _scontrol.animateTo(
                                        _scontrol.position.maxScrollExtent + 80,
                                        duration: Duration(milliseconds: 450),
                                        curve: Curves.easeInOut);
                                  }),
                            ),
                          ),

                          ///Filter button
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerRight,
                            child: Builder(
                              builder: (context) => IconButton(
                                  padding: EdgeInsets.all(2),
                                  icon: Icon(
                                    Icons.filter_alt,
                                    color: Colors.white,
                                    shadows: [Shadow(blurRadius: 4)],
                                  ),
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
                                                child: Container(
                                                    color: Colors.transparent)),
                                          ),
                                          FilterBox(),
                                        ],
                                      ),
                                      backgroundColor: Colors.black26,
                                    );
                                  }),
                            ),
                          )),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
              height: 42,
            ),
          ),
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
