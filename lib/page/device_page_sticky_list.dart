import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/api/APIHelper.dart';
import 'package:intl/intl.dart';

class DevicePage extends StatefulWidget {
  final Devices device;
  const DevicePage({Key key, @required this.device}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState(device);
}

class _DevicePageState extends State<DevicePage> {
  final Devices device;
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
                )),
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
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildRecordList(List<Record> records) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return ListTile(
          title: Text(record.kwh.toString()),
          subtitle: Text(index.toString()),
        );
      });
}
