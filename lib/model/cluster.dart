// To parse this JSON data, do
//
//     final cluster = clusterFromJson(jsonString);

import 'dart:convert';

List<Cluster> clustersFromJson(String str) =>
    List<Cluster>.from(json.decode(str).map((x) => Cluster.fromJson(x)));

String clusterToJson(List<Cluster> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cluster {
  Cluster({
    this.id,
    this.timestamp,
    this.deviceId,
    this.kwh,
    this.powerConsumption,
    this.cluster,
  });

  int id;
  DateTime timestamp;
  int deviceId;
  double kwh;
  double powerConsumption;
  int cluster;

  factory Cluster.fromJson(Map<String, dynamic> json) => Cluster(
        id: json["id"],
        timestamp: DateTime.parse(json["timestamp"]),
        deviceId: json["device_id"].toInt(),
        kwh: json["kwh"].toDouble(),
        powerConsumption: json["power_consumption"].toDouble(),
        cluster: json["cluster"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "timestamp": timestamp.toIso8601String(),
        "device_id": deviceId,
        "kwh": kwh,
        "power_consumption": powerConsumption,
        "cluster": cluster,
      };
}
