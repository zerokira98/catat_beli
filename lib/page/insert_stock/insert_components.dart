part of 'insert_stock.dart';

class BarcodeField extends StatelessWidget {
  final TextEditingController barcodeC;
  final ItemCards data;

  const BarcodeField({super.key, required this.barcodeC, required this.data});

  String? barcodeError() {
    switch (data.barcode.error) {
      case BarcodeValidationError.negative:
        return "Nilai Negatif";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      controller: barcodeC,
      onChanged: (a) {
        if (int.tryParse(a) == null) {
          barcodeC.clear();
          return;
        }
        BlocProvider.of<InsertstockBloc>(context).add(DataChange(
            data.copywith(barcode: Barcode.dirty(int.tryParse(a) ?? 0))));
      },
      decoration: InputDecoration(
          errorText: barcodeError(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'barcode',
          suffixIcon: SuffixBarcode(
            barcodeC: barcodeC,
            data: data,
          )),
    );
  }
}

class HargaBeliField extends StatelessWidget {
  final TextEditingController hargaBeli;
  final ItemCards data;
  const HargaBeliField(
      {super.key, required this.hargaBeli, required this.data});
  String? hargabeliError() {
    // return widget.data.hargaBeli.invalid ? 'invalid' : null;
    switch (data.hargaBeli.error) {
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (v) {
        BlocProvider.of<InsertstockBloc>(context).add(DataChange(data.copywith(
          hargaBeli: Hargabeli.dirty(int.tryParse(hargaBeli.text) ?? 0),
        )));
      },
      controller: hargaBeli,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          errorText: hargabeliError(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: AutoSizeText(
              'Harga Beli ${data.modeHarga == ModeHarga.pcs ? "Pcs" : "Total"}',
              maxLines: 1),
          suffixIcon: InkWell(
              onTap: () {
                BlocProvider.of<InsertstockBloc>(context)
                    .add(DataChange(data.copywith(
                  hargaBeli: Hargabeli.dirty(0),
                )));
              },
              child: Icon(Icons.close_rounded))),
    );
  }
}

class NamaBarangField extends StatelessWidget {
  final SuggestionsBoxController sbc;
  final TextEditingController namec;
  final ItemCards data;
  const NamaBarangField(
      {required this.sbc, required this.namec, required this.data, super.key});
  String? namabarangError() {
    switch (data.namaBarang.error) {
      case NamaBarangValidationError.empty:
        return 'Kosong';
      case NamaBarangValidationError.atleast3:
        return 'Kurang panjang';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14.0, left: 4, top: 4, bottom: 0),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              suggestionsBoxController: sbc,
              textFieldConfiguration: TextFieldConfiguration(
                  maxLines: 2,
                  minLines: 1,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  controller: namec,
                  onChanged: (v) {
                    print("onchanged :(");
                    var nv = v;
                    if (namec.text.isNotEmpty && namec.text.length >= 1) {
                      nv =
                          namec.text[0].toUpperCase() + namec.text.substring(1);
                    }
                    BlocProvider.of<InsertstockBloc>(context)
                        .add(DataChange(data.copywith(
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
                  a = await RepositoryProvider.of<MyDatabase>(context)
                      .showInsideItems(pattern);
                }
                return a;
              },
              itemBuilder: (context, StockItem suggestion) {
                if (suggestion.nama == '[deleted]') return Container();
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(suggestion.nama),
                );
              },
              onSuggestionSelected: (StockItem suggestion) async {
                var res1 = await RepositoryProvider.of<MyDatabase>(context)
                    .showInsideStock(idBarang: (suggestion.id));
                var tempat = await RepositoryProvider.of<MyDatabase>(context)
                    .tempatwithid(res1.last.idSupplier!);
                BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                    data.copywith(
                        namaBarang: NamaBarang.dirty(suggestion.nama),
                        productId: () => suggestion.id,
                        hargaBeli: Hargabeli.dirty(
                            res1.isNotEmpty ? res1.last.price : 0),
                        tempatBeli: Tempatbeli.dirty(tempat.single.nama),
                        barcode: Barcode.dirty(suggestion.barcode ?? 0),
                        discount: Discount.pure()
                        // hargaJual: suggestion,
                        )));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QtyField extends StatelessWidget {
  final TextEditingController qtyc;
  final FocusNode fsn1;
  final ItemCards data;
  const QtyField(
      {super.key, required this.qtyc, required this.fsn1, required this.data});
  String? pcsError() {
    switch (data.pcs.error) {
      case PcsValidationError.empty:
        return "Nilai 0";
      case PcsValidationError.negative:
        return "Nilai Negatif";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: () => FocusScope.of(context)
          .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (text) {
        if (double.tryParse(qtyc.text.trim()) == 0) return 'cant be zero';
        if (double.tryParse(qtyc.text.trim()) == null) {
          return 'Invalid type';
        }
        if (text!.isNotEmpty && !RegExp(r'^\d+(\.\d+)*$').hasMatch(text)) {
          return 'must be a number';
        } else if (text.isEmpty) {
          return 'tidak boleh kosong';
        }
        return null;
      },
      controller: qtyc,
      focusNode: fsn1,
      onChanged: (v) {
        var doublePcs = double.tryParse(qtyc.text.trim());
        if (doublePcs != null)
          BlocProvider.of<InsertstockBloc>(context)
              .add(DataChange(data.copywith(pcs: Pcs.dirty(doublePcs))));
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
    );
  }
}

class TanggalBeliField extends StatelessWidget {
  final ItemCards data;
  final TextEditingController datec;
  TanggalBeliField({super.key, required this.data, required this.datec});

  final DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
            BlocProvider.of<InsertstockBloc>(context)
                .add(DataChange(data.copywith(ditambahkan: picked)));
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
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: AutoSizeText('Tanggal Beli',
                maxLines: 1,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            // labelText: 'Buy date',
            // fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TempatBeliField extends StatelessWidget {
  final TextEditingController placec;
  final FocusNode fsn2;
  final ItemCards data;
  const TempatBeliField(
      {super.key,
      required this.placec,
      required this.fsn2,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          focusNode: fsn2,
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          controller: placec,
          onChanged: (v) {
            BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                data.copywith(tempatBeli: Tempatbeli.dirty(placec.text))));
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            suffixIcon: InkWell(
                onTap: () {
                  BlocProvider.of<InsertstockBloc>(context)
                      .add(DataChange(data.copywith(
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
              data.copywith(tempatBeli: Tempatbeli.dirty(val.nama))));
        },
        itemBuilder: (context, TempatBeli datas) {
          return ListTile(
            title: Text(datas.nama),
          );
        },
        suggestionsCallback: (data) async {
          var vals =
              await RepositoryProvider.of<MyDatabase>(context).datatempat(data);
          List<TempatBeli> newvals = [];
          if (vals.isNotEmpty) {
            vals.forEach((element) {
              newvals.add(element);
            });
            newvals.removeWhere((element) => element.nama == '');
            return newvals;
          }
          return newvals;
        });
  }
}

class ModeHargaButton extends StatelessWidget {
  final ItemCards data;

  ModeHargaButton({super.key, required this.data});
  var basicFormat = NumberFormat("#,###", "en_US");
  static var numFormat = NumberFormat.currency(
    locale: 'ID_id',
    symbol: 'Rp.',
    decimalDigits: 0,
  );
  @override
  Widget build(BuildContext context) {
    String calculation() {
      num total = 0;
      num disco = 0;
      switch (data.modeHarga) {
        case ModeHarga.pcs:
          total = data.hargaBeli.value * data.pcs.value;
          if (data.discountMode == DiscountMode.perPcs) {
            disco = (data.discount.value * data.pcs.value);
          } else if (data.discountMode == DiscountMode.total) {
            disco = (data.discount.value);
          }
          break;
        case ModeHarga.total:
          total = data.hargaBeli.value / data.pcs.value;
          if (data.discountMode == DiscountMode.perPcs) {
            disco = (data.discount.value * data.pcs.value);
          } else if (data.discountMode == DiscountMode.total) {
            disco = (data.discount.value);
          }
          break;
      }
      return 'Total :${numFormat.format(total)} - ${basicFormat.format(disco)} = ${numFormat.format(total - disco)}';
    }

    return Row(
      children: [
        InkWell(
            onTap: () {
              switch (data.modeHarga) {
                case ModeHarga.pcs:
                  BlocProvider.of<InsertstockBloc>(context)
                      .add(DataChange(data.copywith(
                    modeHarga: ModeHarga.total,
                    hargaBeli: Hargabeli.dirty(
                        (data.hargaBeli.value * data.pcs.value).floor()),
                  )));
                  break;
                case ModeHarga.total:
                  BlocProvider.of<InsertstockBloc>(context)
                      .add(DataChange(data.copywith(
                    modeHarga: ModeHarga.pcs,
                    hargaBeli: Hargabeli.dirty(
                        (data.hargaBeli.value / data.pcs.value).floor()),
                  )));
                  break;
                default:
              }
            },
            child: Icon(
              Icons.swap_horizontal_circle,
              size: 18,
            )),
        Text(calculation())
      ],
    );
  }
}

class SuffixBarcode extends StatelessWidget {
  final TextEditingController barcodeC;
  final ItemCards data;
  const SuffixBarcode({required this.barcodeC, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
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
                    try {
                      var barcodeScan = await BarcodeScanner.scan();
                      // print(barcodeScan);
                      if (barcodeScan != '-1') {
                        barcodeC.text = barcodeScan.rawContent.trim();
                        List<StockWithDetails> data =
                            await RepositoryProvider.of<MyDatabase>(context)
                                .showStockwithDetails(
                                    startDate: DateTime(2020),
                                    barcode: int.parse(barcodeC.text));
                        if (data.isEmpty) {
                          BlocProvider.of<InsertstockBloc>(context)
                              .add(DataChange(this.data.copywith(
                                    barcode: Barcode.dirty(int.tryParse(
                                            barcodeScan.rawContent.trim()) ??
                                        0),
                                  )));
                        } else {
                          BlocProvider.of<InsertstockBloc>(context)
                              .add(DataChange(this.data.copywith(
                                    namaBarang:
                                        NamaBarang.dirty(data.last.item.nama),
                                    hargaBeli:
                                        Hargabeli.dirty(data.last.stock.price),
                                    productId: () => data.last.item.id,
                                    tempatBeli: Tempatbeli.dirty(
                                        data.last.tempatBeli.nama),
                                    barcode: Barcode.dirty(int.tryParse(
                                            barcodeScan.rawContent.trim()) ??
                                        0),
                                  )));
                        }
                      }
                    } catch (e) {
                      print("eer: $e");
                    }
                  },
                  child: Icon(Icons.qr_code));
            }
          }
          return SizedBox();
        });
  }
}

class FloatingOptions extends StatefulWidget {
  final ItemCards data;
  final Function() noteToggle;
  final Function() discountToggle;
  FloatingOptions(
      {super.key,
      required this.data,
      required this.noteToggle,
      required this.discountToggle});

  @override
  State<FloatingOptions> createState() => _FloatingOptionsState();
}

class _FloatingOptionsState extends State<FloatingOptions> {
  bool openOption = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          canRequestFocus: false,
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              openOption = !openOption;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.lightBlue.withOpacity(0.85),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ),
        AnimatedClipRect(
          duration: Duration(milliseconds: 120),
          reverseDuration: Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          alignment: Alignment.bottomCenter,
          horizontalAnimation: false,
          open: openOption,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(2)),
              InkWell(
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
              Padding(padding: EdgeInsets.all(2)),
              InkWell(
                canRequestFocus: false,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.noteToggle();
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
              Padding(padding: EdgeInsets.all(2)),
              InkWell(
                canRequestFocus: false,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.discountToggle();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.greenAccent.withOpacity(0.85),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.discount_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiscountField extends StatefulWidget {
  final TextEditingController discc;
  final ItemCards data;

  const DiscountField({super.key, required this.discc, required this.data});

  @override
  State<DiscountField> createState() => _DiscountFieldState();
}

class _DiscountFieldState extends State<DiscountField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: widget.discc,
        validator: (value) {
          if (int.tryParse(value ?? '') == null) return 'invalid format';
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            label: widget.data.discountMode.index % 2 == 0
                ? Text('Total Discount')
                : Text('Discount per pcs'),
            suffixIcon: IconButton(
              onPressed: () {
                // setState(() {
                //   discMode = DiscountMode.values[(discMode.index + 1) % 2];
                // });
                switch (widget.data.discountMode) {
                  case DiscountMode.perPcs:
                    BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                      widget.data.copywith(discountMode: DiscountMode.total),
                    ));
                    break;
                  case DiscountMode.total:
                    BlocProvider.of<InsertstockBloc>(context).add(DataChange(
                      widget.data.copywith(discountMode: DiscountMode.perPcs),
                    ));
                    break;

                  default:
                }
              },
              icon: Icon(Icons.change_circle_outlined),
            )),
        onChanged: (v) {
          BlocProvider.of<InsertstockBloc>(context).add(DataChange((widget.data
              .copywith(
                  discount:
                      Discount.dirty(int.tryParse(widget.discc.text) ?? 0)))));
        },
      ),
    );
  }
}

class NoteField extends StatelessWidget {
  final TextEditingController notec;
  final ItemCards data;
  const NoteField({super.key, required this.notec, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: notec,
        decoration: InputDecoration(label: Text('Note')),
        onChanged: (v) {
          BlocProvider.of<InsertstockBloc>(context)
              .add(DataChange((data.copywith(note: v))));
        },
      ),
    );
  }
}
