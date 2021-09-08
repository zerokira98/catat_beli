part of 'stockview.dart';

class FilterBox extends StatelessWidget {
  final dateFrom = TextEditingController(
      // text: DateTime.now()
      //     .subtract(Duration(days: 1365))
      //     .toString()
      //     .substring(0, 10),
      );
  final dateTo = TextEditingController(
      // text: DateTime.now().add(Duration(days: 1)).toString().substring(0, 10),
      );
  final namaBarang = TextEditingController();
  final tempatBeliController = TextEditingController();
  final int dropdownValue = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockviewBloc, StockviewState>(
      builder: (context, state) {
        if (state is StockviewLoaded) {
          namaBarang.text = state.filter.nama ?? '';
          tempatBeliController.text = state.filter.tempatBeli ?? '';
          dateFrom.text = state.filter.startDate.substring(0, 10);
          dateTo.text = state.filter.endDate.substring(0, 10);
          return Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[50]!),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.0))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Filter',
                          textScaleFactor: 1.75,
                          textAlign: TextAlign.left,
                        ),
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
                        decoration: InputDecoration(
                          labelText: 'Tempat beli',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Tanggal : '),
                    Expanded(
                      child:
                          // InputDatePickerFormField(
                          //     firstDate: DateTime.now(), lastDate: DateTime.now()),
                          InkWell(
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (selectedDate != null) {
                            dateFrom.text =
                                selectedDate.toString().substring(0, 10);
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
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (selectedDate != null) {
                            dateTo.text =
                                selectedDate.toString().substring(0, 10);
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
                Row(
                  children: [
                    Text('Sort by:'),
                    DropdownButton(
                        value: dropdownValue,
                        items: [
                          DropdownMenuItem(
                            child: Text('Nama A->Z'),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Text('Nama Z->A'),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text('Tanggal Ascending'),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text('Tanggal Descending'),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text('Tempat Beli A->Z'),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text('Tempat Beli Z->A'),
                            value: 5,
                          ),
                        ],
                        onChanged: (dynamic v) {
                          // dropdownValue = v;
                        }),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print(dateTo.text);
                          // print(namaBarang.text + dateFromFull + dateToFull);
                          BlocProvider.of<StockviewBloc>(context)
                              .add(FilterChange(state.filter.copyWith(
                            nama: namaBarang.text,
                            currentPage: 0,
                            tempatBeli: tempatBeliController.text,
                            startDate: dateFrom.text,
                            endDate: dateTo.text,
                          )));

                          Navigator.pop(context);
                        },
                        child: Text('Go'),
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
