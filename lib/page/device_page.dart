import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/api/APIHelper.dart';

class DevicePage extends StatefulWidget {
  final Devices device;
  // final List<DateTime> allowedDay;
  const DevicePage({Key key, @required this.device}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState(device);
}

class _DevicePageState extends State<DevicePage> {
  final Devices device;
  // final List<DateTime> allowedDay;
  _DevicePageState(this.device);
  DateTime date = DateTime.now();
  // var dayFormat = DateFormat.yMd(date);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.device.name),
        ),
        body: Column(
          children: [
            Flexible(
              child: Stack(
                children: [
                  FutureBuilder<List<Record>>(
                    future: RecordAPI.getRecord(device.id, date),
                    builder: (context, snapshot) {
                      final deviceWithRecord = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('error ${snapshot.error}'));
                          } else {
                            return buildRecordList(deviceWithRecord);
                          }
                      }
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: Stack(
                children: [
                  FutureBuilder<List<Record>>(
                    future: RecordAPI.getRecord(device.id, date),
                    builder: (context, snapshot) {
                      final deviceWithRecord = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('error ${snapshot.error}'));
                          } else {
                            return buildRecordList(deviceWithRecord);
                          }
                      }
                    },
                  ),
                ],
              ),
            ),
            ListTileTheme(
                tileColor: Colors.tealAccent,
                child: ListTile(
                  title:
                      Text("Date : ${DateFormat('yyyy-MM-dd').format(date)}"),
                  leading: Icon(Icons.date_range),
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.parse("2010-01-01"),
                            lastDate: DateTime.now())
                        .then((dateSet) {
                      setState(() {
                        date = dateSet ?? date;
                      });
                    });
                  },
                ))
          ],
        ),
      );

  Widget buildRecordList(List<Record> records) => SfCartesianChart(
        trackballBehavior: TrackballBehavior(
            // Enables the trackball
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipSettings:
                InteractiveTooltip(enable: true, color: Colors.red)),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: false,
          zoomMode: ZoomMode.xy,
          enablePanning: true,
        ),
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Daily Usage'),
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
            visibleMinimum: records[0].kwh - 1000,
            autoScrollingDelta: 5,
            visibleMaximum: records[records.length - 1].kwh + 1000,
            axisLine: const AxisLine(width: 0),
            labelFormat: '{value}',
            majorTickLines: const MajorTickLines(size: 0)),
        series: <ChartSeries>[
          AreaSeries<Record, DateTime>(
              color: Colors.blueAccent,
              dataSource: records,
              xValueMapper: (record, _) => record.timestamp,
              yValueMapper: (record, _) => record.kwh)
        ],
      );
}
