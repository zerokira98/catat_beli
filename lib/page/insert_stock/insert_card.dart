part of 'insert_stock.dart';

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
  TextEditingController hargaBeli = TextEditingController();
  TextEditingController namec = TextEditingController(),
      datec = TextEditingController(),
      placec = TextEditingController(text: ''),
      barcodeC = TextEditingController();
  TextEditingController qtyc = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  FocusNode fsn = FocusNode();
  @override
  void dispose() {
    // sbc.close();
    namec.dispose();
    datec.dispose();
    placec.dispose();
    barcodeC.dispose();
    qtyc.dispose();
    hargaBeli.dispose();
    super.dispose();
  }

  @override
  void initState() {
    sbc = SuggestionsBoxController();
    // hargaBeli = ;
    fsn.addListener(() {
      if (fsn.hasFocus)
        qtyc.selection =
            TextSelection(baseOffset: 0, extentOffset: qtyc.text.length);
    });

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        BlocProvider.of<InsertstockBloc>(context).add(
            DataChange(widget.data.copywith(formkey: _formkey, open: true))));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.namaBarang != namec.text) {
      namec.text = widget.data.namaBarang ?? '';
    }
    if (widget.data.tempatBeli != placec.text) {
      placec.text = widget.data.tempatBeli ?? '';
    }
    if (widget.data.hargaBeli?.toString() != hargaBeli.text) {
      hargaBeli.text = widget.data.hargaBeli?.toString() ?? '';
    }
    if (widget.data.barcode?.toString() != barcodeC.text) {
      barcodeC.text = widget.data.barcode?.toString() ?? '';
    }
    if (widget.data.pcs?.toString() != qtyc.text) {
      qtyc.text = widget.data.pcs?.toString() ?? '';
      qtyc.selection = TextSelection.fromPosition(
          TextPosition(offset: qtyc.text.indexOf('.')));
    }
    datec.text = widget.data.ditambahkan.toString().substring(0, 10);
    Widget bottom = Row(
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
                print(v);
                print('aaa');
                var doublePcs = double.tryParse(qtyc.text.trim());
                print(doublePcs);
                if (doublePcs != null)
                  BlocProvider.of<InsertstockBloc>(context)
                      .add(DataChange(widget.data.copywith(pcs: doublePcs)));
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
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: barcodeC,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (a) {
              if (a != null && a.isNotEmpty) {
                if (int.tryParse(a) == null) {
                  print('hey');
                  return 'invalid barcode';
                }
              }
              return null;
            },
            onChanged: (a) {
              BlocProvider.of<InsertstockBloc>(context).add(
                  DataChange(widget.data.copywith(barcode: int.tryParse(a))));
            },
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'barcode',
                suffixIcon: FutureBuilder<List>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isEmpty)
                        return Container();
                      return InkWell(
                          canRequestFocus: false,
                          onTap: () async {
                            String barcodeScan =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#ffffff', 'Batal', true, ScanMode.BARCODE);
                            // print(barcodeScan);
                            if (barcodeScan != '-1') {
                              barcodeC.text = barcodeScan.trim();
                              BlocProvider.of<InsertstockBloc>(context)
                                  .add(DataChange(widget.data.copywith(
                                barcode: int.tryParse(barcodeScan.trim()),
                              )));
                            }
                          },
                          child: Icon(Icons.qr_code));
                    })),
          ),
        ),
        Expanded(
          flex: 2,
          child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: placec,
                onChanged: (v) {
                  BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                      widget.data.copywith(tempatBeli: placec.text)));
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                      onTap: () {
                        BlocProvider.of<InsertstockBloc>(context)
                            .add(DataChange(widget.data.copywith(
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
                BlocProvider.of<InsertstockBloc>(context).add(
                    DataChange(widget.data.copywith(tempatBeli: val.nama)));
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
                                  namaBarang: namec.text,
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
                              BlocProvider.of<InsertstockBloc>(context)
                                  .add(DataChange(widget.data.copywith(
                                hargaBeli: int.tryParse(hargaBeli.text),
                              )));
                            },
                            controller: hargaBeli,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                // labelText: 'Harga beli ',
                                label: AutoSizeText('Harga Beli'),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      BlocProvider.of<InsertstockBloc>(context)
                                          .add(DataChange(widget.data.copywith(
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
                              datec.text = picked.toString().substring(0, 19);
                              print(picked.toString());
                              BlocProvider.of<InsertstockBloc>(context).add(
                                  DataChange(widget.data
                                      .copywith(ditambahkan: picked)));
                            }
                          },
                          child: TextField(
                            controller: datec,
                            enabled: false,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,

                              label: AutoSizeText('Tanggal Beli'),
                              // labelText: 'Buy date',
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
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
        ],
      ),
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      child: AnimatedClipRect(
        curve: Curves.ease,
        reverseCurve: Curves.ease,
        duration: Duration(milliseconds: 400),
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
