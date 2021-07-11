import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/APIHelper.dart';
import 'package:futurebuilder_example/model/cluster.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:intl/intl.dart';

class DevicesListCluster extends StatefulWidget {
  const DevicesListCluster({Key key}) : super(key: key);

  @override
  _DevicesListClusterState createState() => _DevicesListClusterState();
}

class _DevicesListClusterState extends State<DevicesListCluster> {
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
                        final deviceWithRecord = snapshot.data;
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('error ${snapshot.error}'));
                            } else {
                              return Center(child: Text("yeee"));
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
}
