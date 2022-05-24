import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:kasir/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:intl/intl.dart';

final numFormat = new NumberFormat("#,##0.00", "en_US");

class ListOfItems extends StatefulWidget {
  @override
  _ListOfItemsState createState() => _ListOfItemsState();
}

class _ListOfItemsState extends State<ListOfItems> {
  int optionVal = 0;
  var options = [
    DropdownMenuItem(
      child: Text('Date Asc'),
      value: 0,
    ),
    DropdownMenuItem(
      child: Text('Date Dsc'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('Name Asc'),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text('Name Dsc'),
      value: 3,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Registered Items'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder<List<StockItem>>(
          future: RepositoryProvider.of<MyDatabase>(context)
              .showInsideItems(null, optionVal),
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.hasData) {
              print(snapshot.data);
              return ListView.builder(
                itemBuilder: (context, i) {
                  if (i == 0)
                    return Card(
                      elevation: 12,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 24),
                      child: Container(
                          margin: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                'Filter',
                                textScaleFactor: 1.8,
                              ),
                              Row(
                                children: [
                                  Text('Sort by : '),
                                  DropdownButton<int>(
                                      items: options,
                                      onChanged: (val) {
                                        setState(() {
                                          optionVal = val!;
                                        });
                                      },
                                      value: optionVal),
                                ],
                              ),
                            ],
                          )),
                    );
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditItemPage(
                            data: snapshot.data![i - 1],
                          ),
                        ),
                      ).then((value) {
                        print(value);
                        setState(() {});
                      });
                    },
                    title: Text(snapshot.data![i - 1].nama),
                  );
                },
                itemCount: snapshot.data!.length + 1,
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class EditItemPage extends StatefulWidget {
  final StockItem data;
  EditItemPage({required this.data});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage>
    with TickerProviderStateMixin {
  late SuggestionsBoxController sbc;

  TextEditingController namec = TextEditingController(),
      hargaJual = TextEditingController(),
      barcodeC = TextEditingController(),
      qtyc = TextEditingController();
  late StockItem data;
  final _formkey = GlobalKey<FormState>();
  // int optionVal = 0;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    data = widget.data;
    sbc = SuggestionsBoxController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data.nama != namec.text) {
      namec.text = data.nama;
    }
    if (data.barcode.toString() != barcodeC.text) {
      barcodeC.text = data.barcode?.toString() ?? '';
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save),
            Text(
              'Save',
            ),
          ],
        ),
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            print('succ here');
            int? barcode =
                barcodeC.text.isEmpty ? null : int.parse(barcodeC.text);
            print('succ here');
            await RepositoryProvider.of<MyDatabase>(context)
                .updateItemProp(
                    data.id, namec.text, int.tryParse(hargaJual.text), barcode)
                .then((value) => Navigator.pop(context, 'halo minnasan XD'));
          }
        },
      ),
      appBar: AppBar(title: Text('Edit'), actions: [
        ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                print('succ here');
                int? barcode =
                    barcodeC.text.isEmpty ? null : int.parse(barcodeC.text);
                print('succ here');
                await RepositoryProvider.of<MyDatabase>(context)
                    .updateItemProp(data.id, namec.text,
                        int.tryParse(hargaJual.text), barcode)
                    .then(
                        (value) => Navigator.pop(context, 'halo minnasan XD'));
              }
            },
            child: Text('Save'))
      ]),
      body: Column(
        children: [
          Container(
            child: AnimatedClipRect(
              curve: Curves.ease,
              reverseCurve: Curves.ease,
              duration: Duration(milliseconds: 450),
              horizontalAnimation: false,
              open: true,
              child: Form(
                key: _formkey,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16.0),
                      padding: EdgeInsets.all(8.00),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
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
                            child: Material(
                              child: TypeAheadFormField(
                                // autovalidate: true,
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
                                      // dO Something
                                    },
                                    // style: DefaultTextStyle.of(context)
                                    //     .style
                                    //     .copyWith(fontStyle: FontStyle.italic),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Nama item')),
                                suggestionsCallback: (pattern) async {
                                  var res =
                                      await RepositoryProvider.of<MyDatabase>(
                                              context)
                                          .showInsideItems(pattern);
                                  return res;
                                },
                                itemBuilder: (context, StockItem suggestion) {
                                  return ListTile(
                                    leading: Icon(Icons.shopping_cart),
                                    title: Text(suggestion.nama),
                                    // subtitle:
                                    //     Text('\$${suggestion['HARGA_JUAL']}'),
                                  );
                                },
                                onSuggestionSelected:
                                    (dynamic suggestion) async {
                                  // var res = await RepositoryProvider.of<
                                  //         DatabaseRepository>(context)
                                  //     .showInsideStock(
                                  //         idbarang: suggestion['ID']);
                                  // print(res);

                                  /// dO sOMETHING
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Expanded(
                              //     child: Padding(
                              //   padding: const EdgeInsets.all(4.0),
                              //   child: TextFormField(
                              //     autovalidateMode:
                              //         AutovalidateMode.onUserInteraction,
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
                              //       ///Do Smthg
                              //     },
                              //     keyboardType: TextInputType.number,
                              //     decoration: InputDecoration(
                              //         labelText: 'Harga jual per pcs'),
                              //   ),
                              // )),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: barcodeC,
                                    decoration: InputDecoration(
                                        labelText: 'barcode',
                                        suffixIcon: InkWell(
                                            onTap: () async {
                                              String barcodeScan =
                                                  await FlutterBarcodeScanner
                                                      .scanBarcode(
                                                          '#ffffff',
                                                          'Cancel',
                                                          false,
                                                          ScanMode.BARCODE);
                                              print(barcodeScan);
                                              if (barcodeScan == -1) return;
                                              barcodeC.text = barcodeScan;
                                            },
                                            child: Icon(Icons.qr_code))),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //     child: Padding(
                              //   padding: const EdgeInsets.all(4.0),
                              //   child: TextFormField(
                              //     enabled: false,
                              //     autovalidateMode:
                              //         AutovalidateMode.onUserInteraction,
                              //     // validator: (text) {
                              //     //   if (text.isNotEmpty &&
                              //     //       !RegExp(r'^[0-9]*$').hasMatch(text)) {
                              //     //     return 'must be a number';
                              //     //   } else if (text.isEmpty) {
                              //     //     return 'tidak boleh kosong';
                              //     //   }
                              //     //   return null;
                              //     // },
                              //     controller: qtyc,
                              //     onChanged: (v) {},
                              //     keyboardType: TextInputType.number,
                              //     decoration:
                              //         InputDecoration(labelText: 'jumlah unit'),
                              //   ),
                              // )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Edit Item Page ${widget.data.nama}'),
            ),
          ),
        ],
      ),
    );
  }
}
//------------------------------------------------------

///---------------------------------------------------------------

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
