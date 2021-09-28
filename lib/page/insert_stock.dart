import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:kasir/bloc/insertstock_bloc.dart';
import 'package:kasir/bloc/stock/insertstock_bloc.dart';
import 'package:kasir/model/itemcard.dart';
import 'package:kasir/msc/db_moor.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  ScrollController scrollc = ScrollController();
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
          appBar: AppBar(
            elevation: 7,
            title: Text('Masuk Barang'),
            actions: [
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
                          color: Colors.green[100],
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
                              Icons.subdirectory_arrow_right,
                              color: Colors.grey,
                              size: 28,
                            ),
                            Text(
                              'Submit',
                              textScaleFactor: 1.25,
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Terjadi kesalahan'),
                    ));
                  }
                }
              }
              // if (state is Loaded) {
              //   if (state.error != null) {
              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       content: Text('Error : ${state.error!['msg']}'),
              //     ));
              //   }
              //   if (state.success != null && state.success!) {
              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       content: Text('Berhasil'),
              //     ));
              //   }
              // }
            },
            child: Container(
              // padding: EdgeInsets.only(top: 12.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // color: Colors.grey[100],
              child: SingleChildScrollView(
                controller: scrollc,
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
                          for (int i = 0; i < state.data.length; i++)
                            InsertProductCard(state.data[i],
                                Key(state.data[i].cardId.toString())),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        // elevation: 12.0,

                                        ),
                                    // color: Colors.redAccent,
                                    onPressed: () {
                                      BlocProvider.of<InsertstockBloc>(context)
                                          .add(AddCard());
                                      print('tambah\'ed');
                                      FocusScope.of(context).unfocus();
                                      Future.delayed(
                                          Duration(milliseconds: 950), () {
                                        scrollc.animateTo(
                                            scrollc.position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.ease);
                                      });
                                      // bool valids = state.data.any((element) =>
                                      //     element.formkey.currentState
                                      //         .validate());
                                      // if (valids) {
                                      //   print('valids');
                                      //   BlocProvider.of<InsertstockBloc>(context)
                                      //       .add(UploadtoDB(state.data));
                                      // } else {
                                      //   print('not valid');
                                      // }
                                    },
                                    child: Text(
                                      'Tambah Item +',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(24.0),
                          )
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          )),
    );
  }
}

class InsertProductCard extends StatefulWidget {
  @override
  Key get key => _key;
  final Key _key;
  final ItemCards data;
  InsertProductCard(this.data, this._key);
  @override
  _InsertProductCardState createState() => _InsertProductCardState();
}

class _InsertProductCardState extends State<InsertProductCard>
    with TickerProviderStateMixin {
  SuggestionsBoxController? sbc;
  TextEditingController? namec = TextEditingController(),
      hargaBeli,
      hargaJual = TextEditingController(),
      datec = TextEditingController(),
      placec = TextEditingController(),
      barcodeC = TextEditingController(),
      qtyc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    sbc = SuggestionsBoxController();
    hargaBeli = TextEditingController();

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        BlocProvider.of<InsertstockBloc>(context).add(
            DataChange(widget.data.copywith(formkey: _formkey, open: true))));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.namaBarang != namec!.text) {
      namec!.text = widget.data.namaBarang ?? '';
    }
    if (widget.data.tempatBeli != placec!.text) {
      placec!.text = widget.data.tempatBeli ?? '';
    }
    if (widget.data.hargaBeli?.toString() != hargaBeli!.text) {
      hargaBeli!.text = widget.data.hargaBeli?.toString() ?? '';
    }
    if (widget.data.hargaJual?.toString() != hargaJual!.text) {
      hargaJual!.text = widget.data.hargaJual?.toString() ?? '';
    }
    if (widget.data.pcs?.toString() != qtyc!.text) {
      qtyc!.text = widget.data.pcs?.toString() ?? '';
    }
    datec!.text = widget.data.ditambahkan.toString().substring(0, 10);
    Widget bottom = Row(
      children: [
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
                  datec!.text = picked.toString().substring(0, 19);
                  print(picked.toString());
                  BlocProvider.of<InsertstockBloc>(context).add(
                      DataChange(widget.data.copywith(ditambahkan: picked)));
                }
              },
              child: TextField(
                controller: datec,
                // enabled: false,
                enabled: false,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Buy date'),
              ),
            ),
          ),
        )),
        Expanded(
          child: TextFormField(
            controller: barcodeC,
            decoration: InputDecoration(
                labelText: 'barcode',
                suffixIcon: FutureBuilder<List>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isEmpty)
                        return Container();
                      return InkWell(
                          onTap: () async {
                            String barcodeScan =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#ffffff',
                                    'Cancel',
                                    false,
                                    ScanMode.BARCODE);
                            print(barcodeScan);
                            barcodeC!.text = barcodeScan;

                            BlocProvider.of<InsertstockBloc>(context).add(
                                DataChange(widget.data.copywith(
                                    barcode: int.parse(barcodeScan))));
                          },
                          child: Icon(Icons.qr_code));
                    })),
          ),
        ),
        Expanded(
          child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: placec,
                onChanged: (v) {
                  BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                      widget.data.copywith(tempatBeli: placec!.text)));
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Tempat pembelian'),
              ),
              onSuggestionSelected: (TempatBeli val) {
                BlocProvider.of<InsertstockBloc>(context).add(
                    DataChange(widget.data.copywith(tempatBeli: val.nama)));
              },
              itemBuilder: (context, TempatBeli datas) {
                return ListTile(
                  // leading: Icon(Icons.place),
                  title: Text(datas.nama),
                  // subtitle: Text('\$${datas['HARGA_JUAL']}'),
                );
              },
              suggestionsCallback: (data) async {
                var vals = await RepositoryProvider.of<MyDatabase>(context)
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
      ],
    );
    Widget theForm = Form(
      key: _formkey,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(8.00),
            decoration: BoxDecoration(
              color: Colors.white,
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
                      // Padding(
                      //     padding: EdgeInsets.only(right: 6),
                      //     child: Text('${widget.data.cardId}.')),
                      Expanded(
                        child: TypeAheadFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // autovalidate: ,
                          validator: (text) {
                            if (text!.length <= 2) {
                              return '3 or more character';
                            }
                            return null;
                          },
                          suggestionsBoxController: sbc,
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: namec,
                              onChanged: (v) {
                                BlocProvider.of<InsertstockBloc>(context)
                                    .add(DataChange(widget.data.copywith(
                                  namaBarang: namec!.text,
                                  productId: null,
                                )));
                              },
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama item')),
                          suggestionsCallback: (pattern) async {
                            List<StockItem> a = [];
                            if (pattern.length >= 3) {
                              a = await RepositoryProvider.of<MyDatabase>(
                                      context)
                                  .showInsideItems(pattern);
                            }
                            return a;
                            // return await BackendService.getSuggestions(pattern);
                          },
                          itemBuilder: (context, StockItem suggestion) {
                            return ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text(suggestion.nama),
                              // subtitle: Text('\$${suggestion}'),
                            );
                          },
                          onSuggestionSelected: (StockItem suggestion) async {
                            var res1 =
                                await RepositoryProvider.of<MyDatabase>(context)
                                    .showInsideStock(
                              idBarang: (suggestion.id),
                              //  page: 0
                            );
                            var tempat =
                                await RepositoryProvider.of<MyDatabase>(context)
                                    .tempatwithid(res1.last.idSupplier!);
                            // List res = res1['res'];
                            // print(res);
                            BlocProvider.of<InsertstockBloc>(context)
                                .add(DataChange(widget.data.copywith(
                              namaBarang: suggestion.nama,
                              productId: suggestion.id,
                              hargaBeli: res1.isNotEmpty ? res1.last.price : 0,
                              tempatBeli: tempat.single.nama,
                              // hargaJual: suggestion,
                            )));
                          },
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
                        flex: 1,
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
                              BlocProvider.of<InsertstockBloc>(context)
                                  .add(DataChange(widget.data.copywith(
                                hargaBeli: int.tryParse(hargaBeli!.text),
                              )));
                            },
                            controller: hargaBeli,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Harga beli '),
                          ),
                        )),
                    // Expanded(
                    //     child: Padding(
                    //   padding: const EdgeInsets.all(4.0),
                    //   child: TextFormField(
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     validator: (text) {
                    //       if (text!.isNotEmpty &&
                    //           !RegExp(r'^[0-9]*$').hasMatch(text)) {
                    //         return 'must be a number';
                    //       } else if (text.isEmpty) {
                    //         return 'tidak boleh kosong';
                    //       }
                    //       return null;
                    //     },
                    //     // enabled: false,
                    //     controller: hargaJual,

                    //     onChanged: (v) {
                    //       BlocProvider.of<InsertstockBloc>(context).add(
                    //           DataChange(widget.data.copywith(
                    //               hargaJual: int.parse(hargaJual!.text))));
                    //     },
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(labelText: 'Harga jual '),
                    //   ),
                    // )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          if (text!.isNotEmpty &&
                              !RegExp(r'^[0-9]*$').hasMatch(text)) {
                            return 'must be a number';
                          } else if (text.isEmpty) {
                            return 'tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: qtyc,
                        onChanged: (v) {
                          BlocProvider.of<InsertstockBloc>(context).add(
                              DataChange(widget.data.copywith(
                                  pcs: int.parse(qtyc!.text.trim()))));
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'jumlah unit'),
                      ),
                    )),
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                      Expanded(flex: 3, child: bottom)
                  ],
                ),
                if (MediaQuery.of(context).orientation == Orientation.portrait)
                  bottom
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                BlocProvider.of<InsertstockBloc>(context)
                    .add(RemoveCard(widget.data.cardId!));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.red.withOpacity(0.9),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      // height: 1,
      child: AnimatedClipRect(
        curve: Curves.ease,
        reverseCurve: Curves.ease,
        duration: Duration(milliseconds: 450),
        horizontalAnimation: false,
        open: widget.data.open,
        child: theForm,
      ),
    );
  }
}

class AnimatedClipRect extends StatefulWidget {
  @override
  _AnimatedClipRectState createState() => _AnimatedClipRectState();

  final Widget? child;
  final bool? open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;

  ///The behavior of the controller when [AccessibilityFeatures.disableAnimations] is true.
  final AnimationBehavior animationBehavior;

  AnimatedClipRect({
    this.child,
    this.open,
    this.horizontalAnimation = true,
    this.verticalAnimation = true,
    this.alignment = Alignment.center,
    this.duration,
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.animationBehavior = AnimationBehavior.normal,
  });
}

class _AnimatedClipRectState extends State<AnimatedClipRect>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: widget.duration ?? const Duration(milliseconds: 500),
        reverseDuration: widget.reverseDuration ??
            (widget.duration ?? const Duration(milliseconds: 500)),
        vsync: this,
        value: widget.open! ? 1.0 : 0.0,
        animationBehavior: widget.animationBehavior);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve ?? widget.curve,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open!
        ? _animationController.forward()
        : _animationController.reverse();

    return ClipRect(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _animation.value : 1.0,
            widthFactor: widget.horizontalAnimation ? _animation.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
