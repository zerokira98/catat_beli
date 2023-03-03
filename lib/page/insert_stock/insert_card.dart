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
  // final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool noteVisible = false;
  FocusNode fsn1 = FocusNode();
  FocusNode fsn2 = FocusNode();
  DateFormat dateFormat = DateFormat('d/MM/y');
  ModeHarga modeHarga = ModeHarga.pcs;
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
      fsn1.addListener(fsn1Listener);
      fsn2.addListener(fsn2Listener);
      if (widget.data.created == false) {
        print(widget.data.created);
        print('huh');
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
          return 'Kosong';
        case NamaBarangValidationError.atleast3:
          return 'Kurang panjang';
        default:
          return null;
      }
    }

    String? pcsError() {
      switch (widget.data.pcs.error) {
        case PcsValidationError.empty:
          return "Nilai 0";
        case PcsValidationError.negative:
          return "Nilai Negatif";
        default:
          return null;
      }
    }

    String? hargabeliError() {
      // return widget.data.hargaBeli.invalid ? 'invalid' : null;
      switch (widget.data.hargaBeli.error) {
        case HargabeliValidationError.empty:
          return "Kosong";
        case HargabeliValidationError.negative:
          return "Nilai negatif";
        // case HargabeliValidationError.toosmall:
        //   return "sus, toosmall";
        default:
          return null;
      }
    }

    String? barcodeError() {
      switch (widget.data.barcode.error) {
        case BarcodeValidationError.negative:
          return "Nilai Negatif";
        default:
          return null;
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
      } else {
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
    Widget suffixBarcodeIcon = FutureBuilder<List>(
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
                        await FlutterBarcodeScanner.scanBarcode(
                            '#ffffff', 'Batal', true, ScanMode.BARCODE);
                    // print(barcodeScan);
                    if (barcodeScan != '-1') {
                      barcodeC.text = barcodeScan.trim();
                      List<StockWithDetails> data =
                          await RepositoryProvider.of<MyDatabase>(context)
                              .showStockwithDetails(
                                  startDate: DateTime(2020),
                                  barcode: int.parse(barcodeC.text));
                      if (data.isEmpty) {
                        BlocProvider.of<InsertstockBloc>(context)
                            .add(DataChange(widget.data.copywith(
                          barcode: Barcode.dirty(
                              int.tryParse(barcodeScan.trim()) ?? 0),
                        )));
                      } else {
                        BlocProvider.of<InsertstockBloc>(context)
                            .add(DataChange(widget.data.copywith(
                          namaBarang: NamaBarang.dirty(data.last.item.nama),
                          hargaBeli: Hargabeli.dirty(data.last.stock.price),
                          productId: () => data.last.stock.id,
                          tempatBeli:
                              Tempatbeli.dirty(data.last.tempatBeli.nama),
                          barcode: Barcode.dirty(
                              int.tryParse(barcodeScan.trim()) ?? 0),
                        )));
                      }
                    }
                  },
                  child: Icon(Icons.qr_code));
            }
          }
          return SizedBox();
        });
    Widget additionalBottom = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: notec,
        decoration: InputDecoration(label: Text('Note')),
        onChanged: (v) {
          BlocProvider.of<InsertstockBloc>(context)
              .add(DataChange((widget.data.copywith(note: v))));
        },
      ),
    );
    Widget bottom = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
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
            Padding(padding: EdgeInsets.all(2)),
            Expanded(
                flex: 5,
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
                        BlocProvider.of<InsertstockBloc>(context).add(
                            DataChange(
                                widget.data.copywith(ditambahkan: picked)));
                      }
                    },
                    child: TextField(
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      controller: datec,
                      enabled: false,
                      // style: TextStyle(fontSize: 14),
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: AutoSizeText('Tanggal Beli',
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        // labelText: 'Buy date',
                        // fillColor: Colors.white,
                      ),
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.all(2)),
            Expanded(
              flex: 7,
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
                    BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                        widget.data
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
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    switch (widget.data.modeHarga) {
                      case ModeHarga.pcs:
                        // modeHarga = ModeHarga.total;
                        BlocProvider.of<InsertstockBloc>(context)
                            .add(DataChange(widget.data.copywith(
                          modeHarga: ModeHarga.total,
                          hargaBeli: Hargabeli.dirty(
                              (widget.data.hargaBeli.value *
                                      widget.data.pcs.value)
                                  .floor()),
                        )));
                        break;
                      case ModeHarga.total:
                        // modeHarga = ModeHarga.pcs;

                        BlocProvider.of<InsertstockBloc>(context)
                            .add(DataChange(widget.data.copywith(
                          modeHarga: ModeHarga.pcs,
                          hargaBeli: Hargabeli.dirty(
                              (widget.data.hargaBeli.value /
                                      widget.data.pcs.value)
                                  .floor()),
                        )));
                        break;
                      default:
                    }
                  },
                  child: Icon(
                    Icons.swap_horizontal_circle,
                    size: 18,
                  )),
              widget.data.modeHarga == ModeHarga.pcs
                  ? Text(
                      'Total :${NumberFormat.currency(
                        locale: 'ID_id',
                        symbol: 'Rp.',
                        decimalDigits: 0,
                      ).format(widget.data.hargaBeli.value * widget.data.pcs.value)}',
                      textAlign: TextAlign.left,
                      textScaleFactor: 0.8,
                    )
                  : Text(
                      '1pcs :${NumberFormat.currency(
                        locale: 'ID_id',
                        symbol: 'Rp.',
                        decimalDigits: 0,
                      ).format(widget.data.hargaBeli.value / widget.data.pcs.value)}',
                      textAlign: TextAlign.left,
                      textScaleFactor: 0.8,
                    )
            ],
          ),
        )
      ],
    );
    Widget theForm = Form(
      // key: _formkey,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            elevation: 3,
            child: Container(
              // margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: 14.0, left: 4, top: 4, bottom: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TypeAheadFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            suggestionsBoxController: sbc,
                            textFieldConfiguration: TextFieldConfiguration(
                                maxLines: 2,
                                minLines: 1,
                                onEditingComplete: () =>
                                    FocusScope.of(context).unfocus(),
                                controller: namec,
                                onChanged: (v) {
                                  print("onchanged :(");
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
                              var res1 = await RepositoryProvider.of<
                                      MyDatabase>(context)
                                  .showInsideStock(idBarang: (suggestion.id));
                              var tempat =
                                  await RepositoryProvider.of<MyDatabase>(
                                          context)
                                      .tempatwithid(res1.last.idSupplier!);
                              BlocProvider.of<InsertstockBloc>(context)
                                  .add(DataChange(widget.data.copywith(
                                namaBarang: NamaBarang.dirty(suggestion.nama),
                                productId: () => suggestion.id,
                                hargaBeli: Hargabeli.dirty(
                                    res1.isNotEmpty ? res1.last.price : 0),
                                tempatBeli:
                                    Tempatbeli.dirty(tempat.single.nama),
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
                    padding: EdgeInsets.all(2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              TextFormField(
                                onEditingComplete: () =>
                                    FocusScope.of(context).unfocus(),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                    label: AutoSizeText(
                                        'Harga Beli ${widget.data.modeHarga == ModeHarga.pcs ? "Pcs" : "Total"}',
                                        maxLines: 1),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          BlocProvider.of<InsertstockBloc>(
                                                  context)
                                              .add(DataChange(
                                                  widget.data.copywith(
                                            hargaBeli: Hargabeli.dirty(0),
                                          )));
                                        },
                                        child: Icon(Icons.close_rounded))),
                              ),
                            ],
                          )),
                      Padding(padding: EdgeInsets.all(2)),
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          controller: barcodeC,
                          onChanged: (a) {
                            if (int.tryParse(a) == null) {
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'barcode',
                              suffixIcon: suffixBarcodeIcon),
                        ),
                      ),
                      if (MediaQuery.of(context).orientation ==
                          Orientation.landscape)
                        Expanded(flex: 8, child: bottom)
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 8)),
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait)
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
                  color: Colors.red.withOpacity(0.85),
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
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.brown.withOpacity(0.85),
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

enum ModeHarga { total, pcs }

class SuffixBarcode extends StatelessWidget {
  const SuffixBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
