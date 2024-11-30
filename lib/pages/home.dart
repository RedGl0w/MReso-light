import 'package:flutter/material.dart';
import 'choose_line.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Arrêts préférés")
      ),
      body: Center(
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                      title: Text("Ligne C"),
                    )
                );
              })
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (_, __, ___) => ChooseLine())
          );
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
