import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:catatbeli/bloc/stock/insertstock_bloc.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:catatbeli/page/sidebar/sidebar.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
part 'insert_card.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  ScrollController scrollc = ScrollController();
  bool disabletap = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool dialog = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure to exit?'),
                content: Text('Your data on field would be lost.'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('Exit')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('Close message')),
                ],
              );
            });
        return dialog;
      },
      child: Scaffold(
          drawer: SideDrawer(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 7,
            title: Text('Masuk Barang'),
            actions: [
              // IconButton(
              //     onPressed: () async {
              //       var a = await SharedPreferences.getInstance();
              //       bool b = a.getBool('darkmode') ?? false;
              //       a.setBool('darkmode', !b);
              //     },
              //     icon: Icon(Icons.nightlight)),
              Container(
                padding: EdgeInsets.all(8.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    // highlightColor: Colors.green,
                    onTap: () {
                      var state = (BlocProvider.of<InsertstockBloc>(context)
                          .state as Loaded);

                      BlocProvider.of<InsertstockBloc>(context)
                          .add(SendtoDB(state.data));
                    },
                    child: Container(
                        // width: 56,
                        // height: 56,

                        padding: EdgeInsets.only(left: 4.0, right: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          boxShadow: [BoxShadow(blurRadius: 2.0)],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<InsertstockBloc, InsertstockState>(
                              builder: (context, state) {
                                if (state is Loading) {
                                  return CircularProgressIndicator();
                                }
                                return Container();
                              },
                            ),
                            Icon(
                              Icons.upload_file,
                              // Icons.subdirectory_arrow_right,
                              color: Colors.black,
                              size: 24,
                            ),
                            Text(
                              'Submit',
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          body: BlocListener<InsertstockBloc, InsertstockState>(
            listener: (context, state) {
              if (state is Loaded) {
                if (state.success != null) {
                  if (state.success!) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: const Text('Berhasil'),
                    ));
                  } else {
                    if (state.msg != null && state.msg!.isNotEmpty)
                      showGeneralDialog(
                          context: context,
                          pageBuilder: (context, a1, a2) {
                            return Dialog(
                              child: Text(state.msg!),
                            );
                          });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Terjadi kesalahan'),
                    ));
                  }
                }
              }
            },
            child: Container(
              // padding: EdgeInsets.only(top: 12.0),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? MediaQuery.of(context).size.width * 0.05
                      : 4),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black54,
              child: BlocBuilder<InsertstockBloc, InsertstockState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  // if (state is InsertstockInitial) {
                  //   return Center(child: CircularProgressIndicator());
                  // }
                  if (state is Loaded) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.data.length,
                            controller: scrollc,
                            itemBuilder: (context, i) => Row(children: [
                              Text(
                                '${i + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: InsertProductCard(state.data[i],
                                    Key(state.data[i].cardId.toString())),
                              )
                            ]),
                          ),
                        ),
                        // for (int i = 0; i < state.data.length; i++)
                        //   Row(children: [
                        //     Text(
                        //       '${i + 1}',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //     Expanded(
                        //       child: InsertProductCard(state.data[i],
                        //           Key(state.data[i].cardId.toString())),
                        //     )
                        //   ]),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!disabletap) {
                                      disabletap = true;
                                      BlocProvider.of<InsertstockBloc>(context)
                                          .add(AddCard());
                                      FocusScope.of(context).unfocus();
                                      await Future.delayed(
                                          Duration(milliseconds: 420), () {});
                                      if (scrollc.position.maxScrollExtent -
                                              scrollc.offset <=
                                          180) {
                                        print('here');
                                        scrollc.animateTo(
                                            scrollc.position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 180),
                                            curve: Curves.ease);
                                      } else {
                                        print('here 2');
                                        scrollc.jumpTo(
                                            scrollc.position.maxScrollExtent);
                                      }
                                      await Future.delayed(
                                          Duration(milliseconds: 200), () {});
                                      disabletap = false;
                                    }
                                  },
                                  child: Text(
                                    'Tambah Item +',
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(24.0),
                        // )
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          )),
    );
  }
}
