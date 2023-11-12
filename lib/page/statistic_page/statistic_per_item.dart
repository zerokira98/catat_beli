import 'package:catatbeli/msc/db_moor.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticperPage extends StatefulWidget {
  final List<StockWithDetails> data;
  StatisticperPage({super.key, required this.data});

  @override
  State<StatisticperPage> createState() => _StatisticperPageState();
}

class _StatisticperPageState extends State<StatisticperPage> {
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
              // Row(
              //   children: [
              //     Text('Pembelian Kumulatif Bulan : '),
              //     Padding(padding: EdgeInsets.all(4)),
              //     Expanded(
              //       child: GestureDetector(
              //         onTap: () {
              //           showMonthPicker(
              //             dismissible: true,
              //             context: context,
              //             lastDate: DateTime.now(),
              //             initialDate: selectedDate,
              //           ).then((date) {
              //             if (date != null) {
              //               setState(() {
              //                 var y = DateFormat('MMM y').format(date);
              //                 monthController.text = y.toString();
              //                 selectedDate = date;
              //               });
              //             }
              //           });
              //         },
              //         child: TextFormField(
              //           enabled: false,
              //           controller: monthController,
              //           // onTap: () {
              //           //   FocusScope.of(context).unfocus();
              //           // },
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Grafik ${widget.data[0].item.nama}',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              ChartWidgetperItem(datas: widget.data),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     'Detail',
              //     style: TextStyle(fontSize: 24),
              //   ),
              // ),
              // Container(
              //   child: FutureBuilder<List<StockWithDetails>>(
              //       future: RepositoryProvider.of<MyDatabase>(context)
              //           .showStockwithDetails(
              //               startDate: DateTime(
              //                   selectedDate.year, selectedDate.month, 1),
              //               endDate: DateTime(
              //                       selectedDate.year, selectedDate.month + 1)
              //                   .subtract(Duration(days: 1))),
              //       builder: (context, snapshot) {
              //         if (snapshot.hasData) {
              //           var total = 0.0;

              //           if (snapshot.data!.isEmpty)
              //             return Text('Error, No data');
              //           for (var w in snapshot.data!) {
              //             total = total + (w.stock.price * w.stock.qty);
              //           }
              //           return Column(
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   Text('Total belanja(jumlah*hargabeli)'),
              //                   Text(NumberFormat.currency(locale: 'ID_id')
              //                       .format(total))
              //                 ],
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   Text('Rata-rata per hari(total/31)'),
              //                   Text(NumberFormat.currency(locale: 'ID_id')
              //                       .format(total / 31))
              //                 ],
              //               ),
              //             ],
              //           );
              //           // return CircularProgressIndicator();
              //         }
              //         return CircularProgressIndicator();
              //       }),
              // )
              // Expanded(child: Center(child: Text('No Data'))),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartWidgetperItem extends StatefulWidget {
  final List<StockWithDetails>? datas;
  ChartWidgetperItem({Key? key, this.datas}) : super(key: key);

  @override
  ChartWidgetperItemState createState() => ChartWidgetperItemState();
}

class ChartWidgetperItemState extends State<ChartWidgetperItem> {
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
    // Map<int, dynamic> telo = Map();
    // print(widget.datas);
    if (widget.datas != null) {
      for (var i = 0; i < widget.datas!.length; i++) {
        var a = widget.datas![i].stock;
        data.add(_ChartData(i.toString(), a.price.toDouble(), a.dateAdd!));
      }
    }
    // print(data);
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          AreaSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) =>
                  data.x +
                  ' [' +
                  data.date.day.toString() +
                  '/' +
                  data.date.month.toString() +
                  ']',
              yValueMapper: (_ChartData data, _) => data.y,

              // name: 'Gold',
              color: Theme.of(context).primaryColor)
        ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.date);

  final String x;
  final double y;
  final DateTime date;
}
