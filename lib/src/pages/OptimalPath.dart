import 'package:fasturista/src/models/Lugar.dart';
import 'package:flutter/material.dart';

class OptimalPath extends StatefulWidget {
  final List<Lugar> lugares;

  OptimalPath({Key key, this.lugares}) : super(key: key);

  @override
  _OptimalPathState createState() => _OptimalPathState();
}

class _OptimalPathState extends State<OptimalPath> {
  List<Widget> _listItems() {
    final List<Widget> items = [];
    int day = 0;
    widget.lugares.forEach((lugar) {
      final card = Card(
        elevation: 15.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                lugar.name,
              ),
              subtitle: Text(lugar.formattedAddress),
              leading: Icon(Icons.directions_run),
            ),
          ],
        ),
      );

      if (day != lugar.dayNumber) {
        final cardDay = Card(
          elevation: 15.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/img/day_${lugar.dayNumber}.png",
                  width: 300.0,
                  height: 100.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Center(
                    child: Text(
                      "DIA:${lugar.dayNumber}",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        day = lugar.dayNumber;
        items.add(cardDay);
      }

      items..add(card);
      // items..add(card)..add(Divider());
      // items..add(card)..add(SizedBox(height: 5.0));
    });

    return items;
  }

  Widget _listView() {
    return ListView(
      children: _listItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camino sugerido"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Center(child: _listView()),
        ],
      ),
    );
  }
}
