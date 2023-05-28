part of 'stockview.dart';

class BottomBar extends StatelessWidget {
  final ScrollController scontrol;
  const BottomBar({super.key, required this.scontrol});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
        // border:
        //     Border(top: BorderSide(color: Colors.black12, width: 1)),
        borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(12, 12),
            topRight: Radius.elliptical(12, 12)),
        boxShadow: [BoxShadow(color: Colors.white54, offset: Offset(0, -1))],
        color: Colors.grey[700],
      ),
      // color: Theme.of(context).primaryColor,
      child: BlocListener<StockviewBloc, StockviewState>(
        listener: (context, state) {
          if (state is StockviewLoaded && state.message != null)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
        },
        child: BlocBuilder<StockviewBloc, StockviewState>(
          builder: (context, state) {
            ///---------- Pagination
            if (state is StockviewLoaded) {
              // print('curr' + state.filter.currentPage.toString());
              return Row(
                children: [
                  ///Refresh to initState
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 4)],
                          ),
                          onPressed: () {
                            BlocProvider.of<StockviewBloc>(context)
                                .add(InitiateView());
                          }),
                    ),
                  ),

                  ///Scroll up button
                  Container(
                    // alignment: Alignment.centerRight,
                    child: Builder(
                      builder: (context) => IconButton(
                          padding: EdgeInsets.all(2),
                          icon: Icon(
                            Icons.keyboard_double_arrow_up,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 4)],
                          ),
                          onPressed: () {
                            scontrol.animateTo(0,
                                duration: Duration(milliseconds: 450),
                                curve: Curves.easeInOut);
                          }),
                    ),
                  ),

                  ///Previous page Button
                  InkWell(
                    onLongPress: () {
                      if (state.filter.currentPage != 0) {
                        BlocProvider.of<StockviewBloc>(context).add(
                            PageChange(state.filter.copyWith(currentPage: 0)));
                      }
                    },
                    onTap: () {
                      if (state.filter.currentPage > 0 &&
                          state.filter.currentPage <= state.filter.maxPage) {
                        BlocProvider.of<StockviewBloc>(context).add(PageChange(
                            state.filter.copyWith(
                                currentPage: state.filter.currentPage - 1)));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.arrow_left,
                        color: (state.filter.currentPage > 0 &&
                                state.filter.currentPage <=
                                    state.filter.maxPage)
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),

                  ///Page Numbering
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(18.0, 4.0)),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          final _formsKey = GlobalKey<FormState>();
                          showDialog(
                              context: context,
                              builder: (context) {
                                var pageTextControl = TextEditingController();
                                return Dialog(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 42,
                                          child: Form(
                                            key: _formsKey,
                                            child: TextFormField(
                                              autofocus: true,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) {
                                                String? a;
                                                if (value != null &&
                                                    value.isNotEmpty) {
                                                  bool hah = (int.parse(value) -
                                                          1) >
                                                      (state.filter.maxPage);
                                                  if (value == "0") {
                                                    a = 'cant be zero';
                                                  } else if (hah) {
                                                    a = 'over';
                                                  }
                                                  return a;
                                                }
                                                return a;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: pageTextControl,
                                              onEditingComplete: () {
                                                if (_formsKey.currentState!
                                                    .validate()) {
                                                  BlocProvider.of<StockviewBloc>(
                                                          context)
                                                      .add(PageChange(
                                                          state.filter.copyWith(
                                                              currentPage: int.parse(
                                                                      pageTextControl
                                                                          .text) -
                                                                  1)));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  labelText: 'Page'),
                                            ),
                                          )),
                                      Text('/'),
                                      Text((state.filter.maxPage + 1)
                                          .toString()),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              (state.filter.currentPage + 1).toString(),
                              textScaleFactor: 1.4,
                            ),
                            Text(
                              '/',
                              textScaleFactor: 1.4,
                            ),
                            Text(
                              (state.filter.maxPage + 1).toString(),
                              textScaleFactor: 1.4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///Next page Button
                  InkWell(
                    onLongPress: () {
                      if (state.filter.currentPage != state.filter.maxPage) {
                        BlocProvider.of<StockviewBloc>(context).add(PageChange(
                            state.filter
                                .copyWith(currentPage: state.filter.maxPage)));
                      }
                    },
                    onTap: () {
                      if (state.filter.maxPage > state.filter.currentPage) {
                        BlocProvider.of<StockviewBloc>(context).add(PageChange(
                            state.filter.copyWith(
                                currentPage: state.filter.currentPage + 1)));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.arrow_right,
                        color:
                            (state.filter.maxPage > (state.filter.currentPage))
                                ? Colors.black
                                : Colors.grey,
                      ),
                    ),
                  ),

                  ///Scroll down Button
                  Container(
                    alignment: Alignment.centerRight,
                    child: Builder(
                      builder: (context) => IconButton(
                          padding: EdgeInsets.all(2),
                          icon: Icon(
                            Icons.keyboard_double_arrow_down,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 4)],
                          ),
                          onPressed: () {
                            // print(_scontrol.position.maxScrollExtent);
                            scontrol.animateTo(
                                scontrol.position.maxScrollExtent + 80,
                                duration: Duration(milliseconds: 450),
                                curve: Curves.easeInOut);
                          }),
                    ),
                  ),

                  ///go to stats per item
                  // Center(
                  //   child: FutureBuilder<List<StockWithDetails>>(
                  //       future: RepositoryProvider.of<MyDatabase>(context)
                  //           .showStockwithDetails(
                  //               name: state.filter.nama,
                  //               startDate: state.filter.startDate,
                  //               endDate: state.filter.endDate),
                  //       builder: (context, snap) {
                  //         if (snap.hasData) {
                  //           return IconButton(
                  //               onPressed: () {
                  //                 Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) =>
                  //                             StatisticperPage(
                  //                                 data: snap.data!)));
                  //               },
                  //               icon: Icon(Icons.bar_chart));
                  //         }
                  //         return SizedBox();
                  //       }),
                  // ),

                  ///Filter button
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Builder(
                      builder: (context) => IconButton(
                          padding: EdgeInsets.all(2),
                          icon: Icon(
                            Icons.filter_alt,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 4)],
                          ),
                          onPressed: () {
                            // BlocProvider.of<StockviewBloc>(context).add(Initializeview());
                            Scaffold.of(context).showBottomSheet(
                              (context) => Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            color: Colors.transparent)),
                                  ),
                                  FilterBox(),
                                ],
                              ),
                              backgroundColor: Colors.black26,
                              // shape:
                              //     CircleBorder(side: BorderSide.none),
                            );
                          }),
                    ),
                  )),
                ],
              );
            }
            return Container();
          },
        ),
      ),
      height: 42,
    );
  }
}
