// To parse this JSON data, do
//
//     final devices = devicesFromJson(jsonString);

import 'dart:convert';

List<Devices> devicesFromJson(String str) =>
    List<Devices>.from(json.decode(str).map((x) => Devices.fromJson(x)));

String devicesToJson(List<Devices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Devices {
  Devices({
    this.id,
    this.macaddress,
    this.name,
    this.records,
  });

  int id;
  String macaddress;
  dynamic name;
  List<Record> records;

  factory Devices.fromJson(Map<String, dynamic> json) => Devices(
        id: json["id"],
        macaddress: json["macaddress"],
        name: json["name"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "macaddress": macaddress,
        "name": name,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Record {
  Record({
    this.id,
    this.timestamp,
    this.deviceId,
    this.reading,
  });

  int id;
  DateTime timestamp;
  int deviceId;
  int reading;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        timestamp: DateTime.parse(json["timestamp"]),
        deviceId: json["device_id"],
        reading: json["reading"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "timestamp": timestamp.toIso8601String(),
        "device_id": deviceId,
        "reading": reading,
      };
}
