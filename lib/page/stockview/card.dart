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
  @override
  Widget build(BuildContext context) {
    var hargaBeli = numFormat.format(widget.data.hargaBeli);
    // var hargaJual = numFormat.format(widget.data.hargaJual);
    // print(widget.data.pcs);
    var totalBeli = numFormat.format(widget.data.pcs! * widget.data.hargaBeli!);
    // print('tempat:' + (widget.data.tempatBeli ?? ''));
    // return Container();
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // print(details.delta);
        setState(() {
          horizontal += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        var width = MediaQuery.of(context).size.width;
        print(details.primaryVelocity);
        if (horizontal >= width * 0.5 ||
            (details.primaryVelocity ?? 0.0) >= 100.0) {
          setState(() {
            horizontal = width;
          });
        } else if (horizontal <= width * -0.5 ||
            (details.primaryVelocity ?? 0.0) <= -100.0) {
          setState(() {
            horizontal = -width;
          });
        } else {
          setState(() {
            horizontal = 0.0;
          });
        }
        Future.delayed(Duration(seconds: 4), () {
          setState(() {
            horizontal = 0.0;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? MediaQuery.of(context).size.width * 0.05
                  : 0,
          vertical: 0,
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
              // padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
              ),
              child: ListTile(
                // isThreeLine: true,
                // shape: RoundedRectangleBorder( ),
                // tileColor: Colors.white,
                title: Text(''),
                subtitle: Row(
                  children: [
                    Text('' + ''),
                    Expanded(
                      child: Container(),
                    ),
                    Text(' ' + '')
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
                    InkWell(
                        onTap: () {
                          setState(() {
                            horizontal = 0.0;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                        )),
                  ],
                ),
              ),
            )),
            AnimatedContainer(
              duration: Duration(milliseconds: 450),
              transform: Matrix4.identity()..translate(horizontal),
              margin: EdgeInsets.only(bottom: 0, left: 8, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(),
                boxShadow: [
                  BoxShadow(blurRadius: 8, color: Colors.black26),
                ],
                color: Colors.white,
              ),
              child: ListTile(
                // isThreeLine: true,
                // shape: RoundedRectangleBorder( ),
                // tileColor: Colors.white,
                title: Row(
                  children: [
                    Text(widget.data.namaBarang.toString()),
                    Expanded(child: Container()),
                    Text('Jumlah item : ${widget.data.pcs}'),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          child:
                              Text('Tempat beli: ${widget.data.tempatBeli}')),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                          'Tanggal beli : ${widget.data.ditambahkan.toString().substring(0, 10)}'),
                    ),
                    // Expanded(
                    //   child: Container(),
                    // ),
                    Expanded(
                      flex: 1,
                      // fit: FlexFit.tight,
                      child: Text(
                        'Harga beli : $hargaBeli',
                        // maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      // fit: FlexFit.tight,
                      child: Text(
                        'Total beli : $totalBeli',
                        // maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
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
