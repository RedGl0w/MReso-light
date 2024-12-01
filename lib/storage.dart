import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Storage {
  static const key = 'lines';
  static addCluster(SharedPreferences prefs, String lineId, String clusterCode) {
    List<String>? lines = prefs.getStringList(key);
    lines ??= [];
    lines.add('$lineId,$clusterCode');
    prefs.setStringList(key, lines);
  }

  static removeFromCluster(SharedPreferences prefs, String s) {
    List<String> lines = prefs.getStringList(key)!;
    lines.remove(s);
    prefs.setStringList(key, lines);
  }

  static addLine(SharedPreferences prefs, String id, String shortName, Color bg, Color fg) {
    prefs.setString(id, '${bg.value},${fg.value},$shortName');
  }
}
