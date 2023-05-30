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
      discc = TextEditingController(),
      qtyc = TextEditingController();
  // final _formkey = GlobalKey<FormState>();
  bool noteVisible = false;
  bool discountVisible = false;
  FocusNode fsn1 = FocusNode();
  FocusNode fsn2 = FocusNode();
  DateFormat dateFormat = DateFormat('d/MM/y');
  ModeHarga modeHarga = ModeHarga.pcs;
  @override
  void dispose() {
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

  noteToggle() {
    setState(() {
      noteVisible = !noteVisible;
    });
  }

  discountToggle() {
    setState(() {
      discountVisible = !discountVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
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
    if (widget.data.discount.value != discc.text) {
      discc.text = widget.data.discount.value.toString();
      discc.selection =
          TextSelection.fromPosition(TextPosition(offset: discc.text.length));
    }
    datec.text = dateFormat.format(widget.data.ditambahkan!);
    Widget bottom = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: QtyField(qtyc: qtyc, fsn1: fsn1, data: widget.data)),
            Padding(padding: EdgeInsets.all(2)),
            Expanded(
                flex: 5,
                child: TanggalBeliField(data: widget.data, datec: datec)),
            Padding(padding: EdgeInsets.all(2)),
            Expanded(
                flex: 7,
                child: TempatBeliField(
                    placec: placec, fsn2: fsn2, data: widget.data)),
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(2.0),
            child: ModeHargaButton(data: widget.data))
      ],
    );
    Widget theForm = Form(
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            elevation: 3,
            child: Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NamaBarangField(sbc: sbc, namec: namec, data: widget.data),
                  Padding(
                    padding: EdgeInsets.all(2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4,
                          child: HargaBeliField(
                              hargaBeli: hargaBeli, data: widget.data)),
                      Padding(padding: EdgeInsets.all(2)),
                      Expanded(
                          flex: 5,
                          child: BarcodeField(
                              barcodeC: barcodeC, data: widget.data)),
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
                      child: NoteField(notec: notec, data: widget.data)),
                  AnimatedClipRect(
                      horizontalAnimation: false,
                      duration: Duration(milliseconds: 260),
                      reverseDuration: Duration(milliseconds: 260),
                      open: discountVisible,
                      child: DiscountField(discc: discc, data: widget.data)),
                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              top: 8,
              child: FloatingOptions(
                data: widget.data,
                noteToggle: noteToggle,
                discountToggle: discountToggle,
              )),
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
