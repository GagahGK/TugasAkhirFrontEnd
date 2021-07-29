import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/apiHelper.dart';
import 'package:futurebuilder_example/model/cluster.dart';
import 'package:futurebuilder_example/model/clusterCount.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeviceCluster extends StatefulWidget {
  const DeviceCluster({Key? key, required this.category}) : super(key: key);
  final int category;
  @override
  _DeviceClusterState createState() => _DeviceClusterState(category);
}

class _DeviceClusterState extends State<DeviceCluster> {
  final int category;
  _DeviceClusterState(this.category);

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
                  return ClusterView(
                    devices: devices,
                    category: category,
                  );
                }
            }
          },
        ),
      );
}

class ClusterView extends StatefulWidget {
  const ClusterView({Key? key, required this.devices, required this.category})
      : super(key: key);
  final List<Device>? devices;
  final int category;

  @override
  _ClusterViewState createState() => _ClusterViewState(devices, category);
}

class _ClusterViewState extends State<ClusterView> {
  final List<Device>? devices;
  final int category;
  _ClusterViewState(this.devices, this.category);
  int? select = -1;
  DateTime dateStart = DateTime.now().subtract(Duration(hours: 1));
  DateTime dateEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          isExpanded: true,
          value: select,
          onChanged: (int? idSelect) {
            setState(() {
              select = idSelect;
            });
          },
          items: devices!.map((Device value) {
            return DropdownMenuItem<int>(
              value: value.id,
              child: Text(value.name!),
            );
          }).toList()
            //.insert itu void biar bisa nge return ..insert
            ..insert(0, new DropdownMenuItem(value: -1, child: Text("Select"))),
        ),
        (select == -1)
            ? Flexible(
                child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Select Date First"),
                      Text("Then Select Device"),
                    ],
                  )
                ],
              ))
            : FutureBuilder<List<Cluster>>(
                future:
                    ClusterAPI.getCluster(category, dateStart, dateEnd, select),
                builder: (context, snapshot) {
                  final clustersData = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Flexible(
                          child: Center(child: CircularProgressIndicator()));
                    default:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Flexible(
                          child: Center(
                              child: Column(
                            children: [
                              Text('error ${snapshot.error}'),
                              Text(
                                  'Data not available, try to select earlier starting date and make sure to select device')
                            ],
                          )),
                        );
                      } else {
                        return buildPage(clustersData!);
                      }
                  }
                }),
        ListTileTheme(
            tileColor: Colors.tealAccent,
            child: ListTile(
              title: datePickerTitle(category, dateStart, 'Start'),
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
              title: datePickerTitle(category, dateEnd, 'End'),
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

  Widget buildPage(List<Cluster> clusters) {
    return Flexible(
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(child: Stack(children: [buildClusterGraph(clusters)])),
              Flexible(child: Stack(children: [buildClusterTable(clusters)]))
            ],
          )
        ],
      ),
    );
  }

  Widget buildClusterGraph(List<Cluster> clusters) {
    var count = [0, 0, 0];
    clusters.forEach((element) {
      count[element.cluster!]++;
    });
    var clustersCount =
        List<ClusterCount>.from(count.asMap().entries.map((entry) {
      int idx = entry.key;
      int val = entry.value;
      return new ClusterCount(
          value: val, clusterCategory: ClusterCount.clusterCategoryName[idx]);
    }));

    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ClusterCount, String>(
            dataSource: clustersCount,
            pointColorMapper: (ClusterCount data, _) =>
                (ClusterCount.color[data.clusterCategory]),
            xValueMapper: (ClusterCount clusterCount, _) =>
                clusterCount.clusterCategory,
            yValueMapper: (ClusterCount clusterCount, _) => clusterCount.value,
            dataLabelSettings: DataLabelSettings(isVisible: true))
      ],
    );
  }

  Widget buildClusterTable(List<Cluster> clusters) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(label: Text('Consumption')),
            DataColumn(label: Expanded(child: Text('Cluster Type'))),
            DataColumn(label: Text('Timestamp'))
          ],
          rows: clusters
              .map((e) => DataRow(
                      color: MaterialStateProperty.all(
                          (e.cluster! == 2) ? Colors.red.shade200 : null),
                      cells: <DataCell>[
                        DataCell(Text("${e.powerConsumption}")),
                        DataCell(Text(
                            "${ClusterCount.clusterCategoryName[e.cluster!]}")),
                        DataCell(Text(
                            "${DateFormat('yyyy-MM-dd HH:mm').format(e.timestamp!)}")),
                      ]))
              .toList(),
        ),
      );

  Widget datePickerTitle(int category, DateTime dateStart, String select) {
    switch (category) {
      case 2:
        return (Text(
            "$select Date : ${DateFormat('yyyy-MM').format(dateStart)}"));
      default:
        return (Text(
            "$select Date : ${DateFormat('yyyy-MM-dd').format(dateStart)}"));
    }
  }
}
