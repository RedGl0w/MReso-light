import 'package:flutter/material.dart';
import 'choose_line.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mreso_light/storage.dart';
import 'package:mreso_light/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget generateCard(SharedPreferences prefs, String s) {
    String lineId = s.split(',')[0];
    String clusterCode = s.split(',')[1];
    return FutureBuilder(
        future: Times.fetchTime(lineId, clusterCode),
        builder: (BuildContext context, AsyncSnapshot<Map<String, List<Times>>> snapshot) {
          Widget subTitle;

          List<String> lineDetails = prefs.getString(lineId)!.split(",");
          Color bg = Color(int.parse(lineDetails[0]));
          Color fg = Color(int.parse(lineDetails[1]));
          String shortName = lineDetails[2];
          String clusterName = prefs.getString(clusterCode)!;

          Widget title = Row(children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
              ),
              child: Text(
                shortName,
                style: TextStyle(color: fg),
              ),),
            const SizedBox(width: 10),
            Text(clusterName)
          ]);
          if (snapshot.hasData) {
            String out = "";
            snapshot.data!.keys.forEach((destination) {
              out += "$destination : ";
              snapshot.data![destination]!.forEach((departure) {
                out += "${departure.timeDeparture.difference(DateTime.now()).inMinutes}mn,";
              });
              out += "\n";
            });
            subTitle = Text(out);
          } else if(snapshot.hasError) {
            subTitle = Text("Error ${snapshot.error}");
            print(snapshot.error);
          } else {
            subTitle = Text("Loading");
          }
          return Card(
              child: ListTile(
                title: title,
                trailing: IconButton(
                    onPressed: () {
                      Storage.removeFromCluster(prefs, s);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete)
                ),
                subtitle: subTitle,
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          Widget body;
          if (snapshot.hasData) {
            final SharedPreferences prefs = snapshot.data!;
            List<String>? lines = prefs.getStringList(Storage.key);
            if(lines != null && lines!.length != 0) {
              body = Center(
                  child: ListView.builder(
                      itemCount: lines!.length,
                      itemBuilder: (context, index) {
                        return generateCard(prefs, lines[index]);
                      })
              );
            } else {
              body = Text("Ajouter une ligne !");
            }
          } else if(snapshot.hasError) {
            body = Text("Failed to fetch : ${snapshot.error}");
          } else {
            body = Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(
                title: Text("Arrêts préférés")
            ),
            body: body,
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => ChooseLine())
                ).then((_) => setState(() {}));
              },
              child: new Icon(Icons.add),
            ),
          );
        }
    );
  }
}
