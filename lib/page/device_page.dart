import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/api/APIHelper.dart';

class DevicePage extends StatelessWidget {
  final Devices device;
  const DevicePage({Key key, @required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(device.name),
        ),
        body: FutureBuilder<Devices>(
          future: DeviceApi.getDeviceRecord(this.device.id),
          builder: (context, snapshot) {
            final deviceWithRecord = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('error ${snapshot.error}'));
                } else {
                  return buildRecordList(deviceWithRecord);
                }
            }
          },
        ),
      );

  Widget buildRecordList(Devices device) =>
      ListView.builder(itemBuilder: (context, index) {
        final record = device.records[index];
        return ListTile();
      });
}
