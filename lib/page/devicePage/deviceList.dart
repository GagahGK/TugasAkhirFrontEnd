import 'package:flutter/material.dart';
import 'package:futurebuilder_example/api/apiHelper.dart';
import 'package:futurebuilder_example/model/clusterCount.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/model/cluster.dart';
import 'package:futurebuilder_example/page/devicePage/devicePageGraph.dart';
import 'package:tuple/tuple.dart';
// import 'package:futurebuilder_example/page/deviceDetail.dart';

class DeviceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<Tuple2<List<Device>, List<Cluster>>>(
          future: getDeviceWithCluster(),
          builder: (context, snapshot) {
            final deviceWithCluster = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('error ${snapshot.error}'));
                } else {
                  // FutureBuilder<List<Cluster>>(
                  //   future: ClusterAPI.getCluster(deviceId),
                  // );
                  return buildDevicesList(deviceWithCluster?.item1 ?? [],
                      deviceWithCluster?.item2 ?? []);
                }
            }
          },
        ),
      );

  Widget buildDevicesList(List<Device?> devices, List<Cluster?> clusters) =>
      ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          final cluster = (clusters.length > index) ? clusters[index] : null;
          device?.name ??= "NULL";
          return ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => DevicePage(device: device!),
            )),
            title: Text(device?.name ?? "Building name not assigned"),
            trailing: clusterName(cluster),
            leading: CircleAvatar(
              backgroundColor: Colors.purpleAccent.shade100,
              child: Text((device?.name?[0] ?? "") +
                  (((device?.name?.split(" ").length ?? 0) > 1)
                      ? device!.name!.split(" ").elementAt(1).substring(0, 1)
                      : "")),
            ),
            subtitle: Text(device?.macAddress ?? "MAC Address not available"),
          );
        },
      );

  static Future<Tuple2<List<Device>, List<Cluster>>>
      getDeviceWithCluster() async {
    List<Cluster> cluster = [];
    var devices = DeviceApi.getDevices();
    try {
      cluster = await ClusterAPI.getDevicesCluster();
    } catch (e) {
      print(e);
    }

    return Tuple2(await devices, cluster);
  }

  Widget clusterName(Cluster? clusterData) {
    if (clusterData?.cluster == 2) {
      return Text(
          ((clusterData?.cluster ?? -1) < 0)
              ? "Cluster NA"
              : ClusterCount.clusterCategoryName[clusterData!.cluster!] +
                  " : " +
                  clusterData.powerConsumption.toString() +
                  " Kwh",
          style: TextStyle(color: Colors.red));
    } else
      return Text(((clusterData?.cluster ?? -1) < 0)
          ? "Cluster NA"
          : ClusterCount.clusterCategoryName[clusterData!.cluster!] +
              " : " +
              clusterData.powerConsumption.toString() +
              " Kwh");
  }
}
