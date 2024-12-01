import 'package:flutter/material.dart';
import 'package:mreso_light/api.dart';
import 'package:mreso_light/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChooseCluster extends StatefulWidget {
  final Line selectionnedLine;
  const ChooseCluster({Key? key, required this.selectionnedLine}) : super(key: key);

  @override
  State<ChooseCluster> createState() => _ChooseCluster();
}

class _ChooseCluster extends State<ChooseCluster> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          Cluster.fetchClusters(widget.selectionnedLine.id),
          SharedPreferences.getInstance()
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget body;
          if(snapshot.hasData) {
            List<Cluster> data = snapshot.data![0]!;
            final SharedPreferences prefs = snapshot.data![1];
            Line l = widget.selectionnedLine;
            Storage.addLine(prefs, l.id, l.shortName, l.bg, l.fg);
            body = ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Storage.addCluster(prefs, widget.selectionnedLine.id, data[index].code);
                      prefs.setString(data[index].code, data[index].name);
                    },
                    child: Card(
                        child: ListTile(
                            title: Text(data[index].name)
                        )
                    )
                  );
                }
            );
          } else if(snapshot.hasError) {
            body = Text("Failed to fetch : ${snapshot.error}");
          } else {
            body = Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
                title: Text("Selection de l'arrêt")
            ),
            body: body,
          );
        }
        );
  }
}