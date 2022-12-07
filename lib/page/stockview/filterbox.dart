part of 'stockview.dart';

class FilterBox extends StatelessWidget {
  final format = DateFormat('d/M/y');
  final dateFrom = TextEditingController();
  final dateTo = TextEditingController();
  final namaBarang = TextEditingController();
  final tempatBeliController = TextEditingController();
  final barcodeController = TextEditingController();
  final int dropdownValue = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockviewBloc, StockviewState>(
      builder: (context, state) {
        if (state is StockviewLoaded) {
          namaBarang.text = state.filter.nama ?? '';
          tempatBeliController.text = state.filter.tempatBeli ?? '';
          dateFrom.text = format.format((state.filter.startDate));
          dateTo.text = format.format((state.filter.endDate));
          // state.filter.startDate.substring(0, 10);
          // dateTo.text = state.filter.endDate.substring(0, 10);
          barcodeController.text = state.filter.barcode?.toString() ?? '';
          return Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Theme.of(context).backgroundColor,
                border: Border.all(color: Colors.grey[50]!),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.0))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Filter',
                              textScaleFactor: 1.75,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          // IconButton(

                          //     onPressed: () => Navigator.pop(context),
                          //     icon: Icon(Icons.close,)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: namaBarang,
                        decoration: InputDecoration(
                          labelText: 'Nama barang',
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: tempatBeliController,
                        onEditingComplete: () {
                          BlocProvider.of<StockviewBloc>(context)
                              .add(FilterChange(state.filter.copyWith(
                            barcode: int.tryParse(barcodeController.text),
                            nama: namaBarang.text,
                            currentPage: 0,
                            tempatBeli: tempatBeliController.text,
                          )));
                          // FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Tempat beli',
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tanggal :'),
                          TextButton(
                              onPressed: () {
                                dateFrom.text = format.format((DateTime.now()
                                    .subtract(Duration(days: 365))));
                                BlocProvider.of<StockviewBloc>(context)
                                    .add(FilterChange(state.filter.copyWith(
                                  startDate: DateTime.now()
                                      .subtract(Duration(days: 365)),
                                )));
                              },
                              child: Text('1Year'))
                        ],
                      ),
                      Expanded(
                        child:
                            // InputDatePickerFormField(
                            //     firstDate: DateTime.now(), lastDate: DateTime.now()),
                            InkWell(
                          onTap: () async {
                            var selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    (BlocProvider.of<StockviewBloc>(context)
                                            .state as StockviewLoaded)
                                        .filter
                                        .startDate,
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)));
                            if (selectedDate != null) {
                              // dateFrom.text =
                              //     selectedDate.toString().substring(0, 10);
                              BlocProvider.of<StockviewBloc>(context).add(
                                  FilterChange(state.filter
                                      .copyWith(startDate: selectedDate)));
                            }
                            // dateFromFull = selectedDate.toString();
                          },
                          child: TextField(
                            enabled: false,
                            controller: dateFrom,
                            decoration: InputDecoration(labelText: 'From'),
                          ),
                        ),
                      ),
                      Text(' - '),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            var selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    (BlocProvider.of<StockviewBloc>(context)
                                            .state as StockviewLoaded)
                                        .filter
                                        .endDate,
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)));
                            if (selectedDate != null) {
                              // dateTo.text =
                              //     selectedDate.toString().substring(0, 10);
                              BlocProvider.of<StockviewBloc>(context).add(
                                  FilterChange(state.filter
                                      .copyWith(endDate: selectedDate)));
                            }
                            // dateToFull = selectedDate.toString();
                          },
                          child: TextField(
                            controller: dateTo,
                            enabled: false,
                            decoration: InputDecoration(labelText: 'To'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: barcodeController,
                        onEditingComplete: () {
                          BlocProvider.of<StockviewBloc>(context)
                              .add(FilterChange(state.filter.copyWith(
                            barcode: int.tryParse(barcodeController.text),
                            nama: namaBarang.text,
                            currentPage: 0,
                            tempatBeli: tempatBeliController.text,
                            // startDate: dateFrom.text,
                            // endDate: dateTo.text,
                          )));
                          // FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Barcode',
                          suffixIcon: InkWell(
                              onTap: () {
                                barcodeController.text = '';
                                // BlocProvider.of<StockviewBloc>(context)
                                //     .add(FilterChange(state.filter.copyWith(
                                //   barcode: null,
                                // )));
                              },
                              child: Icon(Icons.close_rounded)),
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(overflow: TextOverflow.clip),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(12)),
                    // Text('Sort by:'),
                    // DropdownButton(
                    //     value: dropdownValue,
                    //     items: [
                    //       DropdownMenuItem(
                    //         child: Text('Nama A->Z'),
                    //         value: 0,
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text('Nama Z->A'),
                    //         value: 1,
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text('Tanggal Ascending'),
                    //         value: 2,
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text('Tanggal Descending'),
                    //         value: 3,
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text('Tempat Beli A->Z'),
                    //         value: 4,
                    //       ),
                    //       DropdownMenuItem(
                    //         child: Text('Tempat Beli Z->A'),
                    //         value: 5,
                    //       ),
                    //     ],
                    //     onChanged: (dynamic v) {
                    //       // dropdownValue = v;
                    //     }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // print(dateTo.text);
                            // print(namaBarang.text + dateFromFull + dateToFull);
                            BlocProvider.of<StockviewBloc>(context)
                                .add(FilterChange(state.filter.copyWith(
                              barcode: int.tryParse(barcodeController.text),
                              nama: namaBarang.text,
                              currentPage: 0,
                              tempatBeli: tempatBeliController.text,
                              // startDate: dateFrom.text,
                              // endDate: dateTo.text,
                            )));

                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Go'),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
