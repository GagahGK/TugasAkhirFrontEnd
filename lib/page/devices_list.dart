import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/APIHelper.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/page/device_page.dart';
// import 'package:futurebuilder_example/page/deviceDetail.dart';

class DeviceListPage extends StatelessWidget {
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
                  return buildDevices(devices);
                }
            }
          },
        ),
      );

  Widget buildDevices(List<Device> devices) => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          device.name ??= "NULL";
          return ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => DevicePage(device: device),
            )),
            title: Text(device.name),
            leading: CircleAvatar(
              backgroundColor: Colors.purpleAccent.shade100,
              child: Text(device.name[0] +
                  (device.name.split(" ").length > 1
                      ? device.name.split(" ").elementAt(1)[0]
                      : "")),
            ),
            subtitle: Text(device.macAddress),
          );
        },
      );
}
