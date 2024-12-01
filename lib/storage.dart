import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const key = 'lines';
  static addCluster(SharedPreferences prefs, String lineId, String clusterCode) {
    List<String>? lines = prefs.getStringList(key);
    lines ??= [];
    lines.add(lineId);
    lines.add(clusterCode);
    prefs.setStringList(key, lines);
  }

  static removeFromCluster(SharedPreferences prefs, int index) {
    List<String> lines = prefs.getStringList(key)!;
    lines.removeAt(index);
    lines.removeAt(index);
    prefs.setStringList(key, lines);
  }
}
