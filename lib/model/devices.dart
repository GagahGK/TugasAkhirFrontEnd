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
    this.macAddress,
    this.name,
    this.power,
  });

  int id;
  String macAddress;
  String name;
  String power;

  factory Devices.fromJson(Map<String, dynamic> json) => Devices(
        id: json["id"],
        macAddress: json["mac_address"],
        name: json["name"],
        power: json["power"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mac_address": macAddress,
        "name": name,
        "power": power,
      };
}
