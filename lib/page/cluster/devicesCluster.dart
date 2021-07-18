import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/apiHelper.dart';
import 'package:futurebuilder_example/model/cluster.dart';
import 'package:futurebuilder_example/model/clusterCount.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuple/tuple.dart';

class DevicesCluster extends StatefulWidget {
  const DevicesCluster({Key? key}) : super(key: key);

  @override
  _DevicesClusterState createState() => _DevicesClusterState();
}

class _DevicesClusterState extends State<DevicesCluster> {
  _DevicesClusterState();
  DateTime dateStart = DateTime.now().subtract(Duration(hours: 1));
  DateTime dateEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Tuple2<List<Device>, List<Cluster>>>(
            future: getDeviceWithCluster(dateStart, dateEnd),
            builder: (context, snapshot) {
              final clusterWithDevices = snapshot.data;
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
                              'Data not available, try to select anoter starting date')
                        ],
                      )),
                    );
                  } else {
                    return buildPage(clusterWithDevices?.item2 ?? [],
                        clusterWithDevices?.item1 ?? []);
                  }
              }
            }),
        ListTileTheme(
            tileColor: Colors.tealAccent,
            child: ListTile(
              title: Text(
                  "Start Date : ${DateFormat('yyyy-MM-d').format(dateStart)}"),
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
              title:
                  Text("End Date : ${DateFormat('yyyy-MM-d').format(dateEnd)}"),
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

  Widget buildPage(List<Cluster> clusters, List<Device> devices) {
    return Flexible(
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(child: Stack(children: [buildClusterGraph(clusters)])),
              Flexible(
                  child:
                      Stack(children: [buildClusterTable(clusters, devices)]))
            ],
          )
        ],
      ),
    );
  }

  Widget buildClusterGraph(List<Cluster> clusters) {
    var count = [0, 0, 0, 0];
    clusters.forEach((element) {
      count[element.cluster! + 1]++;
    });
    var clustersCount =
        List<ClusterCount>.from(count.asMap().entries.map((entry) {
      int idx = entry.key - 1;
      int val = entry.value;
      return new ClusterCount(
          value: val,
          clusterCategory:
              (idx < 0) ? "No Cluster" : ClusterCount.clusterCategoryName[idx]);
    }));
    List<ClusterCount> countClusterExistent = [];
    clustersCount.forEach((value) {
      if (value.value! > 0) {
        countClusterExistent.add(value);
      }
    });

    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ClusterCount, String>(
            dataSource: countClusterExistent,
            xValueMapper: (ClusterCount clusterCount, _) =>
                clusterCount.clusterCategory,
            yValueMapper: (ClusterCount clusterCount, _) => clusterCount.value,
            dataLabelSettings: DataLabelSettings(isVisible: true))
      ],
    );
  }

  Widget buildClusterTable(List<Cluster> clusters, List<Device> devices) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 10,
            columns: <DataColumn>[
              DataColumn(label: Text('Consumption')),
              DataColumn(label: Expanded(child: Text('Cluster Type'))),
              DataColumn(label: Text('Timestamp')),
              DataColumn(label: Text('Building'))
            ],
            rows: clusters
                .map((e) => DataRow(cells: <DataCell>[
                      DataCell(Text(
                          "${((e.powerConsumption ?? -1) < 0) ? "No Record" : e.powerConsumption}")),
                      DataCell(Text(((e.cluster ?? -1) < 0)
                          ? "Cluster NA"
                          : "${ClusterCount.clusterCategoryName[e.cluster!]}")),
                      DataCell(Text((e.timestamp!
                              .isAfter(DateTime.fromMillisecondsSinceEpoch(1)))
                          ? "${DateFormat('yyyy-MM-dd').format(e.timestamp!)}"
                          : "-")),
                      DataCell(Text("${devices[e.deviceId! - 1].name}"))
                    ]))
                .toList(),
          ),
        ),
      );

  static Future<Tuple2<List<Device>, List<Cluster>>> getDeviceWithCluster(
      DateTime dateStart, DateTime dateEnd) async {
    var devices = await DeviceApi.getDevices();
    var cluster = await ClusterAPI.getDevicesCluster(
        dateStart: dateStart, dateEnd: dateEnd);
    return Tuple2(devices, cluster);
  }
}
