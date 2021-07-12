import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/apiHelper.dart';
import 'package:futurebuilder_example/model/cluster.dart';
import 'package:futurebuilder_example/model/clusterCount.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DevicesListClusterHourly extends StatefulWidget {
  const DevicesListClusterHourly({Key key}) : super(key: key);

  @override
  _DevicesListClusterHourlyState createState() =>
      _DevicesListClusterHourlyState();
}

class _DevicesListClusterHourlyState extends State<DevicesListClusterHourly> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Device>>(
          future: DeviceApi.getDevices(),
          builder: (context, snapshot) {
            final devices = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('error ${snapshot.error}'));
                } else {
                  return ClusterChartView(devices: devices);
                }
            }
          },
        ),
      );
}

class ClusterChartView extends StatefulWidget {
  final List<Device> devices;
  const ClusterChartView({Key key, @required this.devices}) : super(key: key);

  @override
  _ClusterChartViewState createState() => _ClusterChartViewState(devices);
}

class _ClusterChartViewState extends State<ClusterChartView> {
  final List<Device> devices;
  _ClusterChartViewState(this.devices);
  int select = -1;
  DateTime dateStart = DateTime.now().subtract(Duration(hours: 1));
  DateTime dateEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          value: select,
          onChanged: (int idSelect) {
            setState(() {
              select = idSelect;
            });
          },
          items: devices.map((Device value) {
            return DropdownMenuItem<int>(
              value: value.id,
              child: Text(value.name),
            );
          }).toList()
            //.insert itu void biar bisa nge return ..insert
            ..insert(0, new DropdownMenuItem(value: -1, child: Text("Select"))),
        ),
        Flexible(
          child: select == -1
              ? Center(child: Text("user belum memilih device"))
              : Stack(
                  children: [
                    FutureBuilder<List<Cluster>>(
                      future:
                          ClusterAPI.getCluster(dateStart, dateEnd, 0, select),
                      builder: (context, snapshot) {
                        final clusterDataDaily = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('error ${snapshot.error}'));
                            } else {
                              return buildClusterGraph(clusterDataDaily);
                            }
                        }
                      },
                    ),
                  ],
                ),
        ),
        Flexible(
          child: select == -1
              ? Center(child: Text("user belum memilih device"))
              : Stack(
                  children: [
                    FutureBuilder<List<Cluster>>(
                      future:
                          ClusterAPI.getCluster(dateStart, dateEnd, 0, select),
                      builder: (context, snapshot) {
                        final clusterDataDaily = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Center(
                                  child: Column(
                                children: [
                                  Text('error ${snapshot.error}'),
                                  Text(
                                      'Data not available, try to select earlier starting date')
                                ],
                              ));
                            } else {
                              return buildClusterTable(clusterDataDaily);
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
              title: Text(
                  "Start Date : ${DateFormat('yyyy-MM-dd H:m').format(dateStart)}"),
              // subtitle: Text("Start Date"),
              leading: Icon(Icons.date_range),
              onTap: () async {
                var dateSet = await showDatePicker(
                    context: context,
                    initialDate: dateStart,
                    firstDate: DateTime.parse("2010-01-01"),
                    lastDate: dateEnd);
                // var timeSet = await showTimePicker(
                //     context: context, initialTime: TimeOfDay.now());
                if (dateSet == null /*|| timeSet == null*/) {
                  return;
                }
                // dateSet = DateTime(dateSet.year, dateSet.month, dateSet.day,
                //     timeSet.hour, timeSet.minute);
                if (dateSet.isAfter(dateEnd) ||
                    dateSet.isAtSameMomentAs(dateEnd)) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("Start Date is set after End Date"),
                                  Text(
                                      "make sure the Start Date is before End Date"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                  return;
                }
                setState(() {
                  dateStart = dateSet;
                });
              },
            )),
        ListTileTheme(
            tileColor: Colors.tealAccent,
            child: ListTile(
              title: Text(
                  "End Date : ${DateFormat('yyyy-MM-dd H:m').format(dateEnd)}"),
              // subtitle: Text("End Date"),
              leading: Icon(Icons.date_range),
              onTap: () async {
                var dateSet = await showDatePicker(
                    context: context,
                    initialDate: dateEnd,
                    firstDate: dateStart,
                    lastDate: DateTime.now());
                // var timeSet = await showTimePicker(
                //     context: context, initialTime: TimeOfDay.now());
                if (dateSet == null /*|| timeSet == null*/) {
                  return;
                }
                // dateSet = DateTime(dateSet.year, dateSet.month, dateSet.day,
                //     timeSet.hour, timeSet.minute);
                if (dateSet.isBefore(dateStart) ||
                    dateSet.isAtSameMomentAs(dateStart)) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Error"),
                            content: SingleChildScrollView(
                                child: ListBody(
                              children: [
                                Text("End Date is set after Start Date"),
                                Text(
                                    "make sure the End date is after Start Date"),
                              ],
                            )),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                  return;
                }
                setState(() {
                  dateEnd = dateSet;
                  print(dateEnd.toString());
                });
              },
            ))
      ],
    );
  }

  Widget buildClusterGraph(List<Cluster> clusters) {
    var count = [0, 0, 0];
    clusters.forEach((element) {
      count[element.cluster]++;
    });
    var clustersCount =
        List<ClusterCount>.from(count.asMap().entries.map((entry) {
      int idx = entry.key;
      int val = entry.value;
      return new ClusterCount(
          value: val, clusterCategory: ClusterCount.clusterCategoryName[idx]);
    }));

    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<ClusterCount, String>(
          dataSource: clustersCount,
          xValueMapper: (ClusterCount clusterCount, _) =>
              clusterCount.clusterCategory,
          yValueMapper: (ClusterCount clusterCount, _) => clusterCount.value,
        )
      ],
    );
  }

  Widget buildClusterTable(List<Cluster> clusters) => InteractiveViewer(
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(label: Text('Consumption')),
            DataColumn(label: Text('Cluster Type')),
            DataColumn(label: Text('Timestamp'))
          ],
          rows: [
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
            DataRow(cells: <DataCell>[
              DataCell(Text("test")),
              DataCell(Text("test")),
              DataCell(Text("test")),
            ]),
          ],
        ),
      );
}
