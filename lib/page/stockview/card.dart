part of 'stockview.dart';

class StockviewCard extends StatefulWidget {
  @override
  Key get key => _key;
  final Key _key;

  final ItemCards data;
  StockviewCard(this.data, this._key);

  @override
  _StockviewCardState createState() => _StockviewCardState();
}

class _StockviewCardState extends State<StockviewCard> {
  double horizontal = 0.0;
  var df = DateFormat('d/M/y');
  double opacityval = 1.0;
  @override
  Widget build(BuildContext context) {
    // var telo = widget.data.note;
    // print('note:$telo');
    var hargaBeli = numFormat.format(widget.data.hargaBeli.value);
    // var hargaJual = numFormat.format(widget.data.hargaJual);
    // print(widget.data.pcs);
    var totalBeli =
        numFormat.format(widget.data.pcs.value * widget.data.hargaBeli.value);
    // print('tempat:' + (widget.data.tempatBeli ?? ''));
    // return Container();
    return GestureDetector(
      onTap: () {
        if (widget.data.note != null) {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(widget.data.note!),
                  ),
                );
              });
        }
      },
      onHorizontalDragStart: (details) {
        setState(() {
          opacityval = 0.0;
        });
      },
      onHorizontalDragUpdate: (details) {
        // print(details.delta);
        setState(() {
          horizontal += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        var width = MediaQuery.of(context).size.width;
        print(details.primaryVelocity);
        // print();
        if (horizontal >= width * 0.5 ||
            (details.primaryVelocity ?? 0.0) >= 100.0) {
          setState(() {
            horizontal = width;
            opacityval = 0.0;
          });
        } else if (horizontal <= width * -0.5 ||
            (details.primaryVelocity ?? 0.0) <= -100.0) {
          setState(() {
            opacityval = 0.0;
            horizontal = -width;
          });
        } else {
          // print('kesini/');
          setState(() {
            horizontal = 0.0;
            opacityval = 1.0;
          });
        }
        Future.delayed(Duration(seconds: 4), () {
          // if (horizontal != 0.0)
          setState(() {
            horizontal = 0.0;
            opacityval = 1.0;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? MediaQuery.of(context).size.width * 0.1
                  : 0,
          vertical: 0,
        ),
        child: Stack(
          children: [
            //BackGround
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
              // padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
              ),
              child: ListTile(
                isThreeLine: true,
                dense: true,
                // shape: RoundedRectangleBorder( ),
                // tileColor: Colors.white,
                title: Text(''),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text('' + ''),
                        Expanded(
                          child: Container(),
                        ),
                        Text(' ' + '')
                      ],
                    ),
                    Row(
                      children: [
                        Text('' + ''),
                        Expanded(
                          child: Container(),
                        ),
                        Text(' ' + '')
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
                child: Container(
              margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'Are you sure want to delete?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            BlocProvider.of<StockviewBloc>(context)
                                .add(DeleteEntry(
                              widget.data,
                            ));
                          },
                          child: Text('Yes',
                              style: TextStyle(color: Colors.white))),
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    InkWell(
                        onTap: () {
                          print('tapped');
                          setState(() {
                            horizontal = 0.0;
                            opacityval = 1.0;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                        )),
                  ],
                ),
              ),
            )),
            Positioned.fill(
                child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: opacityval,
              child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      colors: [
                        Colors.green,
                        Colors.green,
                        Colors.green,
                        Colors.green,
                        Colors.red,
                        Colors.red,
                        Colors.red,
                        Colors.red,
                      ],
                      // stops: [],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(bottom: 8, left: 8, right: 180),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StockEdit(widget.data),
                                ));
                            BlocProvider.of<StockviewBloc>(context)
                                .add(InitiateView());
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return Dialog(
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(18.0),
                            //           child: Text(
                            //             'Future Feature!',
                            //             textScaleFactor: 2.0,
                            //           ),
                            //         ),
                            //       );
                            //     });
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var width = MediaQuery.of(context).size.width;
                            // print(horizontal);
                            setState(() {
                              horizontal = width;
                              opacityval = 0.0;
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
            AnimatedContainer(
              duration: Duration(milliseconds: 450),
              transform: Matrix4.identity()..translate(horizontal),
              margin: EdgeInsets.only(bottom: 0, left: 34, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(),
                boxShadow: [
                  BoxShadow(blurRadius: 8, color: Colors.black26),
                ],
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.white,
              ),
              child: ListTile(
                isThreeLine: true,
                dense: true,
                // shape: RoundedRectangleBorder( ),
                // tileColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: AutoSizeText(
                      widget.data.namaBarang.value.toString(),
                      minFontSize: 12,
                      style: TextStyle(height: 0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Container(
                      child: Text(
                        widget.data.note == null ? '' : '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    // Expanded(child: Container()),
                    Text('Total : ${widget.data.pcs.value}'),
                  ],
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: AutoSizeText(
                            '${widget.data.tempatBeli.value}',
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                              'Tgl : ${df.format(widget.data.ditambahkan!)}'),
                        ),
                        // Expanded(
                        //   child: Container(),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          // fit: FlexFit.tight,
                          child: Text(
                            'Harga beli : Rp$hargaBeli',
                            // maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          // fit: FlexFit.tight,
                          child: Text(
                            'Total: Rp$totalBeli',
                            // maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
