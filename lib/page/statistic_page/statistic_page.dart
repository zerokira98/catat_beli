import 'package:catatbeli/msc/db_moor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsPage extends StatefulWidget {
  StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final TextEditingController monthController = TextEditingController();
  int dropdownValue = 0;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    var y = DateFormat('MMM y').format(selectedDate);
    monthController.text = y.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Statistik'),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Pembelian Kumulatif Bulan : '),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showMonthPicker(
                          dismissible: true,
                          context: context,
                          lastDate: DateTime.now(),
                          initialDate: selectedDate,
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              var y = DateFormat('MMM y').format(date);
                              monthController.text = y.toString();
                              selectedDate = date;
                            });
                          }
                        });
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: monthController,
                        // onTap: () {
                        //   FocusScope.of(context).unfocus();
                        // },
                      ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     DropdownButton<int>(
              //       items: [
              //         DropdownMenuItem(
              //           child: Text('Harian'),
              //           value: 0,
              //         ),
              //         DropdownMenuItem(
              //           child: Text('Mingguan'),
              //           value: 1,
              //         ),
              //       ],
              //       value: dropdownValue,
              //       onChanged: (value) {
              //         if (value != null) {
              //           setState(() {
              //             dropdownValue = value;
              //           });
              //         }
              //       },
              //     ),
              //   ],
              // ),
              Text(
                'Pembelian Terbesar:',
                style: TextStyle(fontSize: 24),
                // textScaleFactor: 1.25,
              ),
              FutureBuilder<List<StockWithDetails>>(
                  future: RepositoryProvider.of<MyDatabase>(context)
                      .showStockwithDetails(
                          startDate: DateTime(
                              selectedDate.year, selectedDate.month, 1),
                          endDate: DateTime(
                                  selectedDate.year, selectedDate.month + 1)
                              .subtract(Duration(days: 1))),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) return Text('Error, No data');
                      var datas = snapshot.data;
                      Map telo = Map<dynamic, Map>();
                      for (var i = 0; i < datas!.length; i++) {
                        var a = (datas[i].stock.dateAdd!);
                        if (telo[a.day] == null) telo[a.day] = {};
                        if (telo[a.day]['val'] == null) {
                          telo[a.day]['val'] = 0;
                          telo[a.day]['date'] = a;
                        }
                        telo[a.day]['val'] = telo[a.day]['val'] +
                            (datas[i].stock.price * datas[i].stock.qty);
                      }
                      // Map result = {'date'};
                      var maxval = 0.0;
                      DateTime? maxvaldate;
                      telo.forEach((key, value) {
                        if (value['val'] > maxval) {
                          maxval = value['val'];
                          // print(DateTime.tryParse(telo[key][]));
                          maxvaldate = value['date'];
                        }
                      });

                      String maxvalFormatted = NumberFormat.compactCurrency(
                              locale: 'ID_id', symbol: 'Rp.')
                          .format(maxval);
                      String maxvaldateFormatted =
                          DateFormat('EEEE', 'ID_id').format(maxvaldate!);

                      return Container(
                        margin: EdgeInsets.all(8.0),
                        height: 200,
                        width: 150,
                        child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxvaldateFormatted,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text('tanggal ${maxvaldate!.day}'),
                                  Expanded(child: Container()),
                                  Text('sebesar $maxvalFormatted'),
                                ],
                              ),
                            )),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Grafik',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: FutureBuilder<List<StockWithDetails>>(
                      future: RepositoryProvider.of<MyDatabase>(context)
                          .showStockwithDetails(
                              startDate: DateTime(
                                  selectedDate.year, selectedDate.month, 1),
                              endDate: DateTime(
                                      selectedDate.year, selectedDate.month + 1)
                                  .subtract(Duration(days: 1))),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty)
                            return Text('Error, No data');
                          return ChartWidget(datas: snapshot.data);
                          // return CircularProgressIndicator();
                        }
                        return CircularProgressIndicator();
                      })),
              // Expanded(child: Center(child: Text('No Data'))),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartWidget extends StatefulWidget {
  final List<StockWithDetails>? datas;
  ChartWidget({Key? key, this.datas}) : super(key: key);

  @override
  ChartWidgetState createState() => ChartWidgetState();
}

class ChartWidgetState extends State<ChartWidget> {
  // late
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // data = widget.datas==null?[
    //   _ChartData('CHN', 12),
    //   _ChartData('GER', 15),
    //   _ChartData('RUS', 30),
    //   _ChartData('BRZ', 6.4),
    //   _ChartData('IND', 14)
    // ]:widget.datas.map((e) => _ChartData(e.item., y));
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<_ChartData> data = [];
    Map<int, dynamic> telo = Map();
    // print(widget.datas);
    if (widget.datas != null) {
      for (var i = 0; i < widget.datas!.length; i++) {
        var a = widget.datas![i].stock.dateAdd!.day;
        if (telo[a] == null) telo[a] = 0;
        telo[a] = telo[a] +
            (widget.datas![i].stock.price * widget.datas![i].stock.qty);
      }
    }
    telo.forEach((key, value) {
      // print(key);
      // setState(() {
      data.add(_ChartData(key.toString(), value));
      // });
    });
    print(data);
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          AreaSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              // name: 'Gold',
              color: Theme.of(context).primaryColor)
        ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
