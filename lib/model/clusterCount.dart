import 'package:flutter/material.dart';

class ClusterCount {
  ClusterCount({this.clusterCategory, this.value});

  static const clusterCategoryName = ['Rendah', 'Sedang', 'Tinggi'];
  static final color = {
    'Rendah': Colors.blue.shade400,
    'Sedang': Colors.orange.shade300,
    'Tinggi': Colors.red.shade300,
    'No Cluster': Colors.grey
  };
  String? clusterCategory;
  int? value;
}
