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

  Widget generateCard(SharedPreferences prefs, List<String> lines, int index) {
    return FutureBuilder(
        future: Times.fetchTime(lines[index], lines[index+1]),
        builder: (BuildContext context, AsyncSnapshot<Map<String, List<Times>>> snapshot) {
          Widget subTitle;
          String title = "Ligne ${lines[index*2]} : ${lines[index*2+1]}"; // Should be changed when data loaded
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
                title: Text(title),
                trailing: IconButton(
                    onPressed: () {
                      Storage.removeFromCluster(prefs, index);
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
            if(lines != null) {
              body = Center(
                  child: ListView.builder(
                      itemCount: (lines.length/2).round(),
                      itemBuilder: (context, index) {
                        return generateCard(prefs, lines, index);
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
