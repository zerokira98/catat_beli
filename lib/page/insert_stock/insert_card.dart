part of 'insert_stock.dart';

class InsertProductCard extends StatefulWidget {
  @override
  Key get key => _key;
  final Key _key;
  final ItemCards data;
  final ScrollController scrollc;
  InsertProductCard(this.data, this._key, this.scrollc);
  @override
  _InsertProductCardState createState() => _InsertProductCardState();
}

class _InsertProductCardState extends State<InsertProductCard>
    with TickerProviderStateMixin {
  SuggestionsBoxController sbc = SuggestionsBoxController();
  TextEditingController hargaBeli = TextEditingController();
  TextEditingController namec = TextEditingController(),
      datec = TextEditingController(),
      placec = TextEditingController(text: ''),
      notec = TextEditingController(text: ''),
      barcodeC = TextEditingController(),
      qtyc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool noteVisible = false;
  FocusNode fsn1 = FocusNode();
  FocusNode fsn2 = FocusNode();
  DateFormat dateFormat = DateFormat('d/MM/y');
  @override
  void dispose() {
    // sbc.close();
    // hargaBeli.dispose();
    // namec.dispose();
    // datec.dispose();
    // placec.dispose();
    // notec.dispose();
    // barcodeC.dispose();
    // qtyc.dispose();

    // fsn1.dispose();
    // fsn1.removeListener(fsn1Listener);
    super.dispose();
  }

  @override
  void initState() {
    // hargaBeli = ;
    if (mounted) {
      print(widget.data.created);
      fsn1.addListener(fsn1Listener);
      fsn2.addListener(fsn2Listener);
      if (widget.data.created == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted)
            BlocProvider.of<InsertstockBloc>(context).add(
                DataChange(widget.data.copywith(open: true, created: true)));
          // Future.delayed(Duration(milliseconds: 400), () {
          //   widget.scrollc.animateTo(widget.scrollc.position.maxScrollExtent,
          //       duration: Duration(milliseconds: 450), curve: Curves.easeInOut);
          // });
        });
      }
    }

    super.initState();
  }

  fsn1Listener() {
    if (fsn1.hasFocus)
      qtyc.selection =
          TextSelection(baseOffset: 0, extentOffset: qtyc.text.length);
  }

  fsn2Listener() {
    if (fsn2.hasFocus)
      placec.selection =
          TextSelection(baseOffset: 0, extentOffset: placec.text.length);
  }

  @override
  Widget build(BuildContext context) {
    String? namabarangError() {
      switch (widget.data.namaBarang.error) {
        case NamaBarangValidationError.empty:
          return 'Empty';
        case NamaBarangValidationError.atleast3:
          return '3 or more char';
        default:
          null;
      }
    }

    String? pcsError() {
      switch (widget.data.pcs.error) {
        case PcsValidationError.empty:
          return "can't be a 0";
        case PcsValidationError.negative:
          return "Negative value";
        default:
          null;
      }
    }

    String? hargabeliError() {
      // return widget.data.hargaBeli.invalid ? 'invalid' : null;
      switch (widget.data.hargaBeli.error) {
        case HargabeliValidationError.empty:
          return "Empty";
        case HargabeliValidationError.negative:
          return "cant negative";
        // case HargabeliValidationError.toosmall:
        //   return "sus, toosmall";
        default:
          null;
      }
    }

    String? barcodeError() {
      switch (widget.data.barcode.error) {
        case BarcodeValidationError.negative:
          return "Negative";
        default:
          null;
      }
    }

    if (widget.data.namaBarang.value != namec.text) {
      namec.text = widget.data.namaBarang.value;
      if (namec.text.length == 1) {
        namec.selection =
            TextSelection.fromPosition(TextPosition(offset: namec.text.length));
      }
    }
    if (widget.data.tempatBeli.value != placec.text) {
      placec.text = widget.data.tempatBeli.value;
    }
    if (widget.data.hargaBeli.value.toString() != hargaBeli.text) {
      hargaBeli.text = widget.data.hargaBeli.value.toString();
      if (hargaBeli.text.length == 1) {
        hargaBeli.selection = TextSelection.fromPosition(
            TextPosition(offset: hargaBeli.text.length));
      }
    }
    if (widget.data.barcode.value.toString() != barcodeC.text) {
      if (widget.data.barcode.value.toString() == '0') {
        barcodeC.text = '';
      }
      // else if (int.tryParse(barcodeC.text) == null) {
      //   barcodeC.text = '';
      // }
      else {
        barcodeC.text = widget.data.barcode.value.toString();
      }
    }
    if (widget.data.pcs.value.toString() != qtyc.text) {
      qtyc.text = widget.data.pcs.value.toString();
      qtyc.selection = TextSelection.fromPosition(
          TextPosition(offset: qtyc.text.indexOf('.')));
    }
    if (widget.data.note != notec.text) {
      notec.text = widget.data.note ?? '';
    }
    datec.text = dateFormat.format(widget.data.ditambahkan!);
    Widget additionalBottom = TextFormField(
      controller: notec,
      decoration: InputDecoration(label: Text('Note')),
      onChanged: (v) {
        BlocProvider.of<InsertstockBloc>(context)
            .add(DataChange((widget.data.copywith(note: v))));
      },
    );
    Widget bottom = Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              onEditingComplete: () => FocusScope.of(context).unfocus(
                  disposition: UnfocusDisposition.previouslyFocusedChild),
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
              focusNode: fsn1,
              onChanged: (v) {
                // print(v);
                // print('aaa');
                var doublePcs = double.tryParse(qtyc.text.trim());
                // print(doublePcs);
                if (doublePcs != null)
                  BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                      widget.data.copywith(pcs: Pcs.dirty(doublePcs))));
                // FocusScope.of(context).
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: pcsError(),
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
        Expanded(
            flex: 4,
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
                      // datec.text = picked.toString().substring(0, 19);
                      print(picked.toString());
                      BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                          widget.data.copywith(ditambahkan: picked)));
                    }
                  },
                  child: TextField(
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    controller: datec,
                    enabled: false,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,

                      label: AutoSizeText('Tanggal Beli'),
                      // labelText: 'Buy date',
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
            )),
        Expanded(
          flex: 6,
          child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: fsn2,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                controller: placec,
                onChanged: (v) {
                  BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                      widget.data.copywith(
                          tempatBeli: Tempatbeli.dirty(placec.text))));
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                      onTap: () {
                        BlocProvider.of<InsertstockBloc>(context)
                            .add(DataChange(widget.data.copywith(
                          tempatBeli: Tempatbeli.pure(),
                        )));
                      },
                      child: Icon(Icons.close_rounded)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(overflow: TextOverflow.clip),
                  labelText: 'Tempat Beli',
                ),
              ),
              onSuggestionSelected: (TempatBeli val) {
                BlocProvider.of<InsertstockBloc>(context).add(DataChange(widget
                    .data
                    .copywith(tempatBeli: Tempatbeli.dirty(val.nama))));
              },
              itemBuilder: (context, TempatBeli datas) {
                return ListTile(
                  title: Text(datas.nama),
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
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.00),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.0,
                    blurRadius: 6.0,
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
                        child: TypeAheadFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // autovalidate: ,
                          // validator: (text) {
                          //   if (text!.length <= 2) {
                          //     return '3 or more character';
                          //   }
                          //   return null;
                          // },
                          suggestionsBoxController: sbc,
                          textFieldConfiguration: TextFieldConfiguration(
                              maxLines: 2,
                              minLines: 1,
                              onEditingComplete: () =>
                                  FocusScope.of(context).unfocus(),
                              controller: namec,
                              onChanged: (v) {
                                var nv = v;
                                if (namec.text.isNotEmpty &&
                                    namec.text.length >= 1) {
                                  nv = namec.text[0].toUpperCase() +
                                      namec.text.substring(1);
                                }
                                BlocProvider.of<InsertstockBloc>(context)
                                    .add(DataChange(widget.data.copywith(
                                  namaBarang: NamaBarang.dirty(nv),
                                  productId: () => null,
                                )));
                              },
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
                                  errorText: namabarangError(),
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama item')),
                          suggestionsCallback: (pattern) async {
                            List<StockItem> a = [];
                            if (pattern.length >= 3) {
                              a = await RepositoryProvider.of<MyDatabase>(
                                      context)
                                  .showInsideItems(pattern);
                            }
                            // print('hello');
                            // print(a);
                            return a;
                          },
                          itemBuilder: (context, StockItem suggestion) {
                            if (suggestion.nama == '[deleted]')
                              return Container();
                            return ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text(suggestion.nama),
                            );
                          },
                          onSuggestionSelected: (StockItem suggestion) async {
                            var res1 =
                                await RepositoryProvider.of<MyDatabase>(context)
                                    .showInsideStock(idBarang: (suggestion.id));
                            // print('heres');
                            var tempat =
                                await RepositoryProvider.of<MyDatabase>(context)
                                    .tempatwithid(res1.last.idSupplier!);
                            BlocProvider.of<InsertstockBloc>(context)
                                .add(DataChange(widget.data.copywith(
                              namaBarang: NamaBarang.dirty(suggestion.nama),
                              productId: () => suggestion.id,
                              hargaBeli: Hargabeli.dirty(
                                  res1.isNotEmpty ? res1.last.price : 0),
                              tempatBeli: Tempatbeli.dirty(tempat.single.nama),
                              barcode: Barcode.dirty(suggestion.barcode ?? 0),
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
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: (text) {},
                            onChanged: (v) {
                              print('test');
                              BlocProvider.of<InsertstockBloc>(context)
                                  .add(DataChange(widget.data.copywith(
                                hargaBeli: Hargabeli.dirty(
                                    int.tryParse(hargaBeli.text) ?? 0),
                              )));
                            },
                            controller: hargaBeli,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorText: hargabeliError(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // labelText: 'Harga beli ',
                                label: AutoSizeText('Harga Beli'),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      BlocProvider.of<InsertstockBloc>(context)
                                          .add(DataChange(widget.data.copywith(
                                        hargaBeli: Hargabeli.dirty(0),
                                      )));
                                    },
                                    child: Icon(Icons.close_rounded))),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        controller: barcodeC,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (a) {
                        //   if (a != null && a.isNotEmpty) {
                        //     if (int.tryParse(a) == null) {
                        //       print('hey');
                        //       return 'invalid barcode';
                        //     }
                        //   }
                        //   return null;
                        // },
                        onChanged: (a) {
                          if (int.tryParse(a) == null) {
                            print('helo$a');
                            barcodeC.clear();
                            return;
                          }
                          BlocProvider.of<InsertstockBloc>(context).add(
                              DataChange(widget.data.copywith(
                                  barcode:
                                      Barcode.dirty(int.tryParse(a) ?? 0))));
                        },
                        decoration: InputDecoration(
                            errorText: barcodeError(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'barcode',
                            suffixIcon: FutureBuilder<List>(
                                future: Platform.isAndroid || Platform.isIOS
                                    ? availableCameras()
                                    : Future.value([]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.isEmpty) {
                                      return SizedBox();
                                    } else {
                                      return InkWell(
                                          canRequestFocus: false,
                                          onTap: () async {
                                            String barcodeScan =
                                                await FlutterBarcodeScanner
                                                    .scanBarcode(
                                                        '#ffffff',
                                                        'Batal',
                                                        true,
                                                        ScanMode.BARCODE);
                                            // print(barcodeScan);
                                            if (barcodeScan != '-1') {
                                              barcodeC.text =
                                                  barcodeScan.trim();
                                              BlocProvider.of<InsertstockBloc>(
                                                      context)
                                                  .add(DataChange(
                                                      widget.data.copywith(
                                                barcode: Barcode.dirty(
                                                    int.tryParse(barcodeScan
                                                            .trim()) ??
                                                        0),
                                              )));
                                            }
                                          },
                                          child: Icon(Icons.qr_code));
                                    }
                                  }
                                  return SizedBox();
                                })),
                      ),
                    ),
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                      Expanded(flex: 3, child: bottom)
                  ],
                ),
                if (MediaQuery.of(context).orientation == Orientation.portrait)
                  bottom,
                AnimatedClipRect(
                    horizontalAnimation: false,
                    duration: Duration(milliseconds: 260),
                    reverseDuration: Duration(milliseconds: 260),
                    open: noteVisible,
                    child: additionalBottom),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 8,
            child: InkWell(
              canRequestFocus: false,
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
          Positioned(
            right: 0,
            top: 56,
            child: InkWell(
              canRequestFocus: false,
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  noteVisible = !noteVisible;
                });
                // BlocProvider.of<InsertstockBloc>(context)
                //     .add(RemoveCard(widget.data.cardId!));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.brown.withOpacity(0.9),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.note_add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return AnimatedClipRect(
      curve: Curves.ease,
      reverseCurve: Curves.ease,
      duration: Duration(milliseconds: 260),
      horizontalAnimation: false,
      open: widget.data.open,
      child: theForm,
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
