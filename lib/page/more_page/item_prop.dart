import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kasir/model/itemcard.dart';
import 'package:catatbeli/msc/db_moor.dart';
import 'package:intl/intl.dart';

final numFormat = new NumberFormat("#,##0.00", "en_US");

class ListOfItems extends StatefulWidget {
  final String? initQuery;

  const ListOfItems({super.key, this.initQuery});
  @override
  _ListOfItemsState createState() => _ListOfItemsState();
}

class _ListOfItemsState extends State<ListOfItems> {
  late ScrollController sc;
  late TextEditingController namaC;
  List changes = [];
  int optionVal = 2;
  bool showHiddenOnly = false;
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
  late Future<List<StockItem>> getData;
  @override
  void initState() {
    sc = ScrollController();
    namaC = TextEditingController(text: widget.initQuery ?? '');
    getData = RepositoryProvider.of<MyDatabase>(context)
        .showInsideItems(null, optionVal);
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     sc.addListener(scListener);
    //     // namebefore = '';
    //   }
    // });
  }

  double opacity = 0.0;
  String currentTitleBar = '';
  setTitleBar(String v) {
    if (currentTitleBar != v) {
      setState(() {
        currentTitleBar = v;
      });
    }
  }

  void scListener() {
    var a = sc.offset;
    if (a < 132) {
      if (opacity != 0) {
        setState(() {
          opacity = 0;
          // namebefore = '';
        });
      }
      print(a);
    } else if (opacity == 0) {
      setState(() {
        opacity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              }),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<List<StockItem>>(
                future: RepositoryProvider.of<MyDatabase>(context)
                    .showInsideItems(namaC.text.isEmpty ? null : namaC.text,
                        optionVal, showHiddenOnly),
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.hasData) {
                    if (optionVal == 2) {
                      changes = [];
                      // int count = 0;
                      int wordCount = 0;
                      // List<Key> telobgst = [];
                      List<Map> wordCountList = [];
                      // String namebefore = ' ';
                      for (int a = 0; a < snapshot.data!.length; a++) {
                        if (a == 0) {
                          changes.add(snapshot.data![a].nama[0]);
                        } else if (snapshot.data![a].nama[0] !=
                            snapshot.data![a - 1].nama[0]) {
                          wordCountList.add({
                            'word': snapshot.data![a - 1].nama[0],
                            'count': wordCount
                          });
                          changes.add(snapshot.data![a].nama[0]);
                          wordCount = 0;
                        } else if (snapshot.data![a] == snapshot.data!.last) {
                          wordCountList.add({
                            'word': snapshot.data![a].nama[0],
                            'count': wordCount
                          });
                          wordCount = 0;
                        }
                        changes.add(snapshot.data![a]);
                        wordCount += 1;
                      }
                      // print(telobgst);
                      return ListView.builder(
                        controller: sc,
                        itemCount: changes.length + 1,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return Card(
                              elevation: 12,
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 24),
                              child: Container(
                                  margin: EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Filter',
                                        textScaler: TextScaler.linear(1.8),
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
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: namaC,
                                              decoration: InputDecoration(
                                                  suffix: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          namaC.clear();
                                                        });
                                                      },
                                                      icon: Icon(
                                                          Icons.close_sharp)),
                                                  labelText: 'Nama barang'),
                                            ),
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Show hidden only'),
                                          Expanded(child: Container()),
                                          Switch(
                                            value: showHiddenOnly,
                                            onChanged: (value) {
                                              setState(() {
                                                showHiddenOnly = value;
                                              });
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            );
                          }
                          if ((changes[i - 1] is StockItem)) {
                            if (changes[i - 1].nama == '[deleted]') {
                              return Container();
                            }
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditItemPage(
                                      data: changes[i - 1],
                                    ),
                                  ),
                                ).then((value) {
                                  print(value);
                                  setState(() {});
                                });
                              },
                              title: Text(changes[i - 1].nama),
                            );
                          }
                          if (changes[i - 1] is! StockItem) {
                            return Separator(
                              // key: telobgst[count - 1],
                              sc: sc,
                              fun: setTitleBar,
                              name: changes[i - 1],
                            );
                            // namebefore = changes[i - 1];
                            // return fak;
                          }
                          return Container();
                        },
                      );
                    }
                    // print(snapshot.data);
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
                                      textScaler: TextScaler.linear(1.8),
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

                        if (snapshot.data![i - 1].nama == '[deleted]')
                          return Container();
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
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  child: Text(currentTitleBar),
                ),
              )),
        ],
      ),
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
  // SuggestionsController sbc = SuggestionsController();

  TextEditingController namec = TextEditingController(),
      hargaJual = TextEditingController(),
      barcodeC = TextEditingController(),
      qtyc = TextEditingController();
  late StockItem data;
  bool switchValue = false;
  final _formkey = GlobalKey<FormState>();
  // int optionVal = 0;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    RepositoryProvider.of<MyDatabase>(context)
        .viewHidden(widget.data.id)
        .then((value) {
      setState(() {
        switchValue = value.isNotEmpty;
      });
    });
    ;
    data = widget.data;
    // sbc =
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
        backgroundColor: Colors.red,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_forever,
                size: 18,
              ),
              AutoSizeText(
                'Remove Item',
                textAlign: TextAlign.center,
                maxLines: 2,
                maxFontSize: 12,
                // minFontSize: 8,
              ),
            ],
          ),
        ),
        onPressed: () async {
          bool a = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Caution'),
                  content: Text('deskripsi menghapus'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        'Sure',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('Cancel')),
                  ],
                );
              });
          if (a) {
            int? barcode =
                barcodeC.text.isEmpty ? null : int.parse(barcodeC.text);
            await RepositoryProvider.of<MyDatabase>(context)
                .updateItemProp(data.id, '[deleted]', null, barcode)
                .then((value) => Navigator.pop(context));
          }
        },
      ),
      appBar: AppBar(title: Text('Edit'), actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green)),
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                // print('succ here');
                int? barcode =
                    barcodeC.text.isEmpty ? null : int.parse(barcodeC.text);
                // print('succ here');
                await RepositoryProvider.of<MyDatabase>(context)
                    .updateItemProp(data.id, namec.text,
                        int.tryParse(hargaJual.text), barcode)
                    .then(
                        (value) => Navigator.pop(context, 'halo minnasan XD'));
              }
            },
            child: Text(
              'Save',
              textScaler: TextScaler.linear(1.15),
            ))
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
                            child: TextFormField(
                                // autovalidate: true,
                                validator: (text) {
                                  if (text!.length <= 2) {
                                    return '3 or more character';
                                  }

                                  return null;
                                },
                                // suggestionsBoxController: sbc,
                                maxLines: 2,
                                minLines: 1,
                                controller: namec,
                                onChanged: (v) {
                                  // dO Something
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama item')),
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
                                              try {
                                                var barcodeScan =
                                                    await BarcodeScanner.scan(
                                                        options: ScanOptions());
                                                barcodeC.text =
                                                    barcodeScan.rawContent;
                                              } catch (e) {}
                                              // print(barcodeScan.type==ResultType.Error);
                                              // if (barcodeScan == -1) return;
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
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title:
                                      Text('Sembunyikan dari input suggestion'),
                                  subtitle:
                                      Text('tetap muncul di histori stock'),
                                ),
                              ),
                              Switch(
                                  value: switchValue,
                                  onChanged: (a) async {
                                    print(await await RepositoryProvider.of<
                                            MyDatabase>(context)
                                        .viewHidden());
                                    setState(() {
                                      switchValue = a;
                                    });
                                    if (a) {
                                      await RepositoryProvider.of<MyDatabase>(
                                              context)
                                          .addToHidden(data.id);
                                    } else {
                                      await RepositoryProvider.of<MyDatabase>(
                                              context)
                                          .removeFromHidden(data.id);
                                    }
                                  })
                            ],
                          )
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

class Separator extends StatefulWidget {
  final ScrollController sc;
  final String name;
  final Function(String v) fun;
  const Separator(
      {Key? key, required this.name, required this.sc, required this.fun})
      : super(key: key);

  @override
  State<Separator> createState() => _SeparatorState();
}

class _SeparatorState extends State<Separator> {
  GlobalKey key = GlobalKey();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((a) {
    //   if (mounted) {
    //     widget.sc.addListener(listenerer);
    //   }
    // });
  }

  void listenerer() {
    final RenderBox? renderBox = key.currentContext != null
        ? key.currentContext!.findRenderObject() as RenderBox
        : null;
    Offset? a = renderBox?.globalToLocal(Offset.zero);
    if (widget.sc.position.userScrollDirection == ScrollDirection.reverse) {
      if (a != null && a.dy >= -80 && a.dy <= -48) {
        widget.fun(widget.name);
        print('n' + widget.name);
        // print('nb' + widget.nameBefore);
      }
    }
    // if (widget.sc.position.userScrollDirection == ScrollDirection.forward) {
    //   if (a != null && a.dy >= -130 && a.dy <= -110) {
    //     // print('is it here?');
    //     print(widget.name);
    //     print(widget.nameBefore);
    //     // print(a);
    //     widget.fun(widget.nameBefore);
    //   }
    // }
  }

  @override
  void dispose() {
    widget.sc.removeListener(listenerer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: EdgeInsets.all(8.0),
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      child: Text(widget.name),
    );
  }
}
