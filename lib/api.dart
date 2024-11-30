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

