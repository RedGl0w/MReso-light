import 'package:flutter/material.dart';
import 'package:mreso_light/api.dart';
import 'choose_cluster.dart';

class ChooseLine extends StatefulWidget {
  const ChooseLine({Key? key}) : super(key: key);

  @override
  State<ChooseLine> createState() => _ChooseLineState();
}

class _ChooseLineState extends State<ChooseLine> {
  Widget layoutLines(List<Line> lines, BuildContext context) {
    return Wrap(
      spacing: 6,
      children: lines.map((l) {
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(pageBuilder: (_, __, ___) => ChooseCluster(selectionnedLine: l))
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: l.bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            l.shortName,
            style: TextStyle(color: l.fg),
          ),
        );
      }).toList(),
    );
  }

  static final categories = [
    {"humanName": 'Tramways', "apiName": 'TRAM'},
    {"humanName": 'Bus chrono', "apiName": 'CHRONO'},
    {"humanName": "Bus proximo", "apiName": 'PROXIMO'}
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Line.fetchLines(),
        builder: (BuildContext context, AsyncSnapshot<List<Line>> snapshot) {
          Widget body;
          if(snapshot.hasData) {
            List<Line> data = snapshot.data!;
            body = ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            categories[index]["humanName"]!
                        ),
                      ),
                      layoutLines(data.where((j) {return j.type == categories[index]["apiName"]!;}).toList(), context)
                    ],
                  );
                });
            // body = Text("Loaded ! ${data[0].longName}");
          } else if(snapshot.hasError) {
            body = Text("Failed to fetch : ${snapshot.error}");
          } else {
            body = Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(title: Text("Selection de la ligne")),
            body: body,
          );
        });
  }
}