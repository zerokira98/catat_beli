import 'package:auto_size_text/auto_size_text.dart';
// import 'package:camera/camera.dart';
// import 'package:catatbeli/bloc/stock/insertstock_bloc.dart';
import 'package:catatbeli/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'cubit/editstock_cubit.dart';

class StockEdit extends StatelessWidget {
  final ItemCards data;
  const StockEdit(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditstockCubit(RepositoryProvider.of<MyDatabase>(context))
            ..update(data),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
          actions: [
            BlocBuilder<EditstockCubit, ItemCards>(builder: (context, state) {
              return IconButton(
                  onPressed: () async {
                    print('save');
                    await BlocProvider.of<EditstockCubit>(context).sendToDB();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.save));
            })
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<EditstockCubit, ItemCards>(
            builder: (context, state) {
              return EditCard(state);
            },
          ),
        ),
      ),
    );
  }
}

class EditCard extends StatefulWidget {
  // @override
  // Key get key => _key;
  // final Key _key;
  final ItemCards data;
  EditCard(
    this.data,
  );
  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> with TickerProviderStateMixin {
  // SuggestionsBoxController? sbc;
  TextEditingController hargaBeli = TextEditingController();
  TextEditingController nameC = TextEditingController(),
      dateC = TextEditingController(),
      placeC = TextEditingController(text: '')
      // barcodeC = TextEditingController()
      ;
  TextEditingController qtyc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  FocusNode fsn = FocusNode();
  @override
  void initState() {
    // sbc = SuggestionsBoxController();
    // hargaBeli = ;
    fsn.addListener(() {
      if (fsn.hasFocus)
        qtyc.selection =
            TextSelection(baseOffset: 0, extentOffset: qtyc.text.length);
    });
    super.initState();
  }

  @override
  void dispose() {
    hargaBeli.dispose();
    nameC.dispose();
    dateC.dispose();
    placeC.dispose();
    super.dispose();
  }

  var a = DateFormat('d/M/y');
  @override
  Widget build(BuildContext context) {
    // print('a');
    // print(BlocProvider.of<EditstockCubit>(context).state);
    if (widget.data.namaBarang != nameC.text) {
      nameC.text = widget.data.namaBarang ?? '';
    }
    if (widget.data.tempatBeli != placeC.text) {
      placeC.text = widget.data.tempatBeli ?? '';
    }
    if (widget.data.hargaBeli?.toString() != hargaBeli.text) {
      hargaBeli.text = widget.data.hargaBeli?.toString() ?? '';
    }
    if (widget.data.pcs?.toString() != qtyc.text) {
      qtyc.text = widget.data.pcs?.toString() ?? '';
      qtyc.selection = TextSelection.fromPosition(
          TextPosition(offset: qtyc.text.indexOf('.')));
    }
    dateC.text = a.format(widget.data.ditambahkan!);
    Widget bottom(context) => Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (double.tryParse(qtyc.text.trim()) == 0)
                      return 'cant be zero';
                    if (double.tryParse(qtyc.text.trim()) == null) {
                      return 'Invalid type';
                    }
                    if (text!.isNotEmpty &&
                        !RegExp(r'^\d+(\.\d+)*$').hasMatch(text)) {
                      return 'must be a number';
                    } else if (text.isEmpty) {
                      return 'tidak boleh kosong';
                    }
                    return null;
                  },
                  controller: qtyc,
                  focusNode: fsn,
                  onChanged: (v) {
                    var doublePcs = double.tryParse(qtyc.text.trim());
                    if (doublePcs != null)
                      BlocProvider.of<EditstockCubit>(context)
                          .update(widget.data.copywith(pcs: doublePcs));
                    // FocusScope.of(context).
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: AutoSizeText(
                      'jumlah unit',
                      maxLines: 1,
                    ),
                    // labelText: 'jumlah unit',
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: TextFormField(
            //     controller: barcodeC,
            //     decoration: InputDecoration(
            //         floatingLabelBehavior: FloatingLabelBehavior.always,
            //         labelText: 'barcode',
            //         suffixIcon: FutureBuilder<List>(
            //             future: availableCameras(),
            //             builder: (context, snapshot) {
            //               if (snapshot.hasData && snapshot.data!.isEmpty)
            //                 return Container();
            //               return InkWell(
            //                   canRequestFocus: false,
            //                   onTap: () async {
            //                     String barcodeScan =
            //                         await FlutterBarcodeScanner.scanBarcode(
            //                             '#ffffff',
            //                             'Cancel',
            //                             false,
            //                             ScanMode.BARCODE);
            //                     print(barcodeScan);
            //                     if (barcodeScan != '-1') {
            //                       // barcodeC.text = barcodeScan;
            //                       // BlocProvider.of<InsertstockBloc>(context).add(
            //                       //     DataChange(widget.data.copywith(
            //                       //         barcode: int.parse(barcodeScan))));
            //                     }
            //                   },
            //                   child: Icon(Icons.qr_code));
            //             })),
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Not Configured yet')));
                },
                child: TypeAheadFormField(
                    enabled: false,
                    textFieldConfiguration: TextFieldConfiguration(
                      enabled: false,
                      controller: placeC,
                      onChanged: (v) {
                        BlocProvider.of<EditstockCubit>(context).update(
                            (widget.data.copywith(tempatBeli: placeC.text)));
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                            onTap: () {
                              BlocProvider.of<EditstockCubit>(context)
                                  .update((widget.data.copywith(
                                tempatBeli: '',
                              )));
                            },
                            child: Icon(Icons.close_rounded)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(overflow: TextOverflow.clip),
                        labelText: 'Tempat Beli',
                      ),
                    ),
                    onSuggestionSelected: (TempatBeli val) {
                      BlocProvider.of<EditstockCubit>(context)
                          .update((widget.data.copywith(tempatBeli: val.nama)));
                    },
                    itemBuilder: (context, TempatBeli datas) {
                      return ListTile(
                        title: Text(datas.nama),
                      );
                    },
                    suggestionsCallback: (data) async {
                      var vals =
                          await RepositoryProvider.of<MyDatabase>(context)
                              .datatempat(data);
                      List<TempatBeli> newvals = [];
                      if (vals.isNotEmpty) {
                        vals.forEach((element) {
                          newvals.add(element);
                        });
                        newvals.removeWhere((element) => element.nama == '');
                        return newvals;
                      }
                      return newvals;
                    }),
              ),
            ),
          ],
        );
    return Form(
      key: _formkey,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.00),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.0,
                    blurRadius: 12.0,
                    color: Colors.grey[400]!)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // autovalidate: ,
                          enabled: false,
                          controller: nameC,
                          maxLines: 2,
                          minLines: 1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama item'),
                          validator: (text) {
                            if (text!.length <= 2) {
                              return '3 or more character';
                            }
                            return null;
                          },
                          // suggestionsBoxController: sbc,
                          // textFieldConfiguration: TextFieldConfiguration(
                          //     controller: namec,
                          //     onChanged: (v) {
                          //       BlocProvider.of<InsertstockBloc>(context)
                          //           .add(DataChange(widget.data.copywith(
                          //         namaBarang: namec.text,
                          //         productId: null,
                          //       )));
                          //     },
                          //     style: DefaultTextStyle.of(context)
                          //         .style
                          //         .copyWith(fontStyle: FontStyle.italic),
                          //     decoration: InputDecoration(
                          //         border: OutlineInputBorder(),
                          //         labelText: 'Nama item')),
                          // suggestionsCallback: (pattern) async {
                          //   List<StockItem> a = [];
                          //   if (pattern.length >= 3) {
                          //     a = await RepositoryProvider.of<MyDatabase>(
                          //             context)
                          //         .showInsideItems(pattern);
                          //   }
                          //   return a;
                          // },
                          // itemBuilder: (context, StockItem suggestion) {
                          //   return ListTile(
                          //     leading: Icon(Icons.shopping_cart),
                          //     title: Text(suggestion.nama),
                          //   );
                          // },
                          // onSuggestionSelected: (StockItem suggestion) async {
                          //   var res1 =
                          //       await RepositoryProvider.of<MyDatabase>(context)
                          //           .showInsideStock(idBarang: (suggestion.id));
                          //   var tempat =
                          //       await RepositoryProvider.of<MyDatabase>(context)
                          //           .tempatwithid(res1.last.idSupplier!);
                          //   BlocProvider.of<InsertstockBloc>(context)
                          //       .add(DataChange(widget.data.copywith(
                          //     namaBarang: suggestion.nama,
                          //     productId: suggestion.id,
                          //     hargaBeli: res1.isNotEmpty ? res1.last.price : 0,
                          //     tempatBeli: tempat.single.nama,
                          //     // hargaJual: suggestion,
                          //   )));
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (text) {
                              if (text!.isNotEmpty &&
                                  !RegExp(r'^[0-9]*$').hasMatch(text)) {
                                return 'must be a number';
                              } else if (text.isEmpty) {
                                return 'tidak boleh kosong';
                              }
                              return null;
                            },
                            onChanged: (v) {
                              print('test');
                              BlocProvider.of<EditstockCubit>(context)
                                  .update((widget.data.copywith(
                                hargaBeli: int.tryParse(hargaBeli.text),
                              )));
                            },
                            controller: hargaBeli,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Harga beli ',
                                suffixIcon: InkWell(
                                    onTap: () {
                                      BlocProvider.of<EditstockCubit>(context)
                                          .update((widget.data.copywith(
                                        hargaBeli: 0,
                                      )));
                                    },
                                    child: Icon(Icons.close_rounded))),
                          ),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                initialDatePickerMode: DatePickerMode.day,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101));
                            if (picked != null) {
                              dateC.text = a.format(picked);
                              print(picked.toString());
                              BlocProvider.of<EditstockCubit>(context).update(
                                  (widget.data.copywith(ditambahkan: picked)));
                            }
                          },
                          child: TextField(
                            controller: dateC,
                            enabled: false,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Buy date',
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )),
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                      Expanded(flex: 3, child: bottom(context))
                  ],
                ),
                if (MediaQuery.of(context).orientation == Orientation.portrait)
                  bottom(context)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
