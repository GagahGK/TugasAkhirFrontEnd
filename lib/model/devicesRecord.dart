// To parse this JSON data, do
//
//     final Devices = DevicesFromJson(jsonString);

import 'dart:convert';

Devices DevicesFromJson(String str) => Devices.fromJson(json.decode(str));

String DevicesToJson(Devices data) => json.encode(data.toJson());

class Devices {
  Devices({
    this.id,
    this.macAddress,
    this.name,
    this.power,
    this.records,
  });

  int id;
  String macAddress;
  String name;
  String power;
  List<Record> records;

  factory Devices.fromJson(Map<String, dynamic> json) => Devices(
        id: json["id"],
        macAddress: json["mac_address"],
        name: json["name"],
        power: json["power"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mac_address": macAddress,
        "name": name,
        "power": power,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Record {
  Record({
    this.id,
    this.timestamp,
    this.deviceId,
    this.kwh,
  });

  int id;
  DateTime timestamp;
  int deviceId;
  double kwh;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        timestamp: DateTime.parse(json["timestamp"]),
        deviceId: json["device_id"],
        kwh: json["kwh"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "timestamp": timestamp.toIso8601String(),
        "device_id": deviceId,
        "kwh": kwh,
      };
}
