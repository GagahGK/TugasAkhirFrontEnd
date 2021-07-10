// To parse this JSON data, do
//
//     final devices = devicesFromJson(jsonString);

import 'dart:convert';

List<Record> recordsFromJson(String str) =>
    List<Record>.from(json.decode(str).map((x) => Record.fromJson(x)));

Device deviceFromJson(String str) => Device.fromJson(json.decode(str));

List<Device> devicesFromJson(String str) =>
    List<Device>.from(json.decode(str).map((x) => Device.fromJson(x)));

String devicesToJson(List<Device> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Device {
  Device({
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

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        macAddress: json["mac_address"],
        name: json["name"],
        power: json["power"],
        records: json['records'] ?? false
            ? List<Record>.from(json["records"].map((x) => Record.fromJson(x)))
            : [],
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
