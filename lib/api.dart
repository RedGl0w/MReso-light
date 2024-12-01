import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const urlBase = "https://data.mobilites-m.fr/api";

class Line {

  final String id;
  final String shortName;
  final String longName;
  final Color bg;
  final Color fg;
  final String type; // This should be enum


  const Line({
    required this.id,
    required this.shortName,
    required this.longName,
    required this.bg,
    required this.fg,
    required this.type,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      id: json['id'],
      shortName: json['shortName'],
      longName: json['longName'],
      bg: Color(int.parse(json['color'], radix: 16) + 0xFF000000),
      fg: Color(int.parse(json['textColor'], radix: 16) + 0xFF000000),
      type: json['type']
    );
  }

  static Future<List<Line>> fetchLines() async {
    final response = await http.get(Uri.parse('$urlBase/routers/default/index/routes'));
    if (response.statusCode == 200) {
      final data = (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      return data.map(Line.fromJson).toList();
    } else {
      throw Exception('Failed to fetch Lines');
    }
  }
}

class Cluster {

  final String id;
  final String name;
  final String code;

  const Cluster({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  static Future<List<Cluster>> fetchClusters(String lineId) async {
    final response = await http.get(Uri.parse('$urlBase/routers/default/index/routes/$lineId/clusters'));
    if (response.statusCode == 200) {
      final data = (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      return data.map(Cluster.fromJson).toList();
    } else {
      throw Exception('Failed to fetch Clusters');
    }
  }

}

class Times {

  final DateTime timeDeparture;

  const Times({
    required this.timeDeparture,
  });

  factory Times.fromJson(Map<String, dynamic> json) {
    int time = 0;
    if (json["realtime"]) {
      time = (json["realtimeDeparture"] * 1000) + (json["serviceDay"] * 1000);
    } else {
      time = (json["scheduledDeparture"] * 1000) + (json["serviceDay"] * 1000);
    }
    return Times(
        timeDeparture: DateTime.fromMillisecondsSinceEpoch(time)
    );
  }

  static Future<Map<String, List<Times>>> fetchTime(String lineId, String ClusterCode) async {
    final response = await http.get(
        Uri.parse('$urlBase/routers/default/index/clusters/$ClusterCode/stoptimes?route=$lineId'),
        headers: {
          "origin": "MReso_light"
        }
    );
    if (response.statusCode == 200) {
      Map<String, List<Times>> result = {};
      final data = (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      data.forEach((i) {
        result[i["pattern"]["desc"]] = [];
        i["times"].forEach((j) {
          result[i["pattern"]["desc"]]!.add(Times.fromJson(j));
        });
      });
      return result;
    } else {
      throw Exception('Failed to fetch Times ${response.statusCode}');
    }
  }
}

