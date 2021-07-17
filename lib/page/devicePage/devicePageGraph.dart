import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/api/apiHelper.dart';

class GraphModes {
  static const int CUMULATIVE = 0;
  static const int DIFFERENCE = 1;
  static const int DELTA = 2;
}

class DevicePage extends StatefulWidget {
  final Device device;
  // final List<DateTime> allowedDay;
  const DevicePage({Key key, @required this.device}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState(device);
}

class _DevicePageState extends State<DevicePage> {
  final Device device;
  // final List<DateTime> allowedDay;
  _DevicePageState(this.device);
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.device.name),
        ),
        body: Column(
          children: [
            FutureBuilder<List<Record>>(
              future: RecordAPI.getRecord(device.id, date),
              builder: (context, snapshot) {
                final deviceRecords = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Flexible(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('error ${snapshot.error}')),
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      return buildPage(deviceRecords);
                    }
                }
              },
            ),
            ListTileTheme(
                tileColor: Colors.tealAccent,
                child: ListTile(
                  title:
                      Text("Date : ${DateFormat('yyyy-MM-dd').format(date)}"),
                  subtitle: Text("$date"),
                  leading: Icon(Icons.date_range),
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.parse("2010-01-01"),
                            lastDate: DateTime.now())
                        .then((dateSet) {
                      if (dateSet != null)
                        setState(() {
                          date = dateSet ?? date;
                        });
                    });
                  },
                )),
          ],
        ),
      );

  Widget buildPage(List<Record> records) {
    List<Record> difference = records
        .asMap() //ubah record menjadi jadi (key, value)
        .map((key, value) => MapEntry(
            // tldr: dibuat jadi entry sebuah map bentuk nya mapentry -> mapentry adalah isi dari Map {0:record0,1:record1}
            key,
            (key < 1)
                ? (new Record(
                    deviceId: value.deviceId,
                    id: value.id,
                    kwh: 0,
                    timestamp: value.timestamp))
                : (new Record(
                    deviceId: value.deviceId,
                    id: value.id,
                    kwh: value.kwh - records[key - 1].kwh,
                    timestamp: value.timestamp))))
        .values //udah gitu dari map di ambil value nya aja -> berubah jadi iterable
        .toList();

    List<Record> delta = difference
        .asMap() //ubah record menjadi jadi (key, value)
        .map((key, value) => MapEntry(
            // tldr: dibuat jadi entry sebuah map bentuk nya mapentry -> mapentry adalah isi dari Map {0:record0,1:record1}
            key,
            (key < 1)
                ? (new Record(
                    deviceId: value.deviceId,
                    id: value.id,
                    kwh: 0,
                    timestamp: value.timestamp))
                : (new Record(
                    deviceId: value.deviceId,
                    id: value.id,
                    kwh: value.kwh - difference[key - 1].kwh,
                    timestamp: value.timestamp))))
        .values //udah gitu dari map di ambil value nya aja -> berubah jadi iterable
        .toList();
    //iterable diubah ke list, iterable adalah sequence of data
    //(sequence of data yang diakses oleh __next__()) , kyk linked list

    return Flexible(
        child: Stack(
      children: [
        Column(
          children: [
            Flexible(child: buildRecordGraph(records, GraphModes.CUMULATIVE)),
            Flexible(
                child: buildRecordGraph(difference, GraphModes.DIFFERENCE)),
            Flexible(child: buildRecordGraph(delta, GraphModes.DELTA))
          ],
        )
      ],
    ));
  }

  Widget buildRecordGraph(List<Record> records, int mode) {
    return SfCartesianChart(
      series: <ChartSeries>[
        AreaSeries<Record, DateTime>(
            color: Colors.blueAccent,
            dataSource: records,
            xValueMapper: (Record record, _) => record.timestamp,
            yValueMapper: (Record record, _) => record.kwh)
      ],
      trackballBehavior: TrackballBehavior(
          // Enables the trackball
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(enable: true, color: Colors.red)),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: false,
        zoomMode: ZoomMode.xy,
        enablePanning: true,
      ),
      plotAreaBorderWidth: 0,
      title: (mode == GraphModes.CUMULATIVE)
          ? ChartTitle(text: "Daily Usage Cumulative")
          : (mode == GraphModes.DIFFERENCE)
              ? ChartTitle(text: "Daily Usage Growth per Hour")
              : ChartTitle(text: "Daily Usage Delta per hour"),
      legend:
          Legend(isVisible: false, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: DateTimeAxis(
          title: AxisTitle(text: 'Hour'),
          majorGridLines: const MajorGridLines(width: 0),
          intervalType: DateTimeIntervalType.hours,
          dateFormat: DateFormat.H(),
          visibleMaximum: records[0].timestamp.add(Duration(hours: 5))),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'kWh'),
          visibleMinimum: records
              .reduce((value, element) => // ngeiterate list return satu element
                  (value.kwh < element.kwh) ? value : element)
              .kwh,
          autoScrollingDelta: 5,
          visibleMaximum: records
              .reduce((value, element) =>
                  (value.kwh > element.kwh) ? value : element)
              .kwh,
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
    );
  }
}
