import 'dart:math';

import 'package:fasturista/src/models/Lugar.dart';
import 'package:flutter/material.dart';

class OptimalPath extends StatefulWidget {
  final List<Itinerario> itinerarios;

  OptimalPath({Key key, this.itinerarios}) : super(key: key);

  @override
  _OptimalPathState createState() => _OptimalPathState();
}

class _OptimalPathState extends State<OptimalPath> {
  List<Color> colors = [Colors.red, Colors.green, Colors.blue];
  bool _showDay = false;
  final random = new Random();

  Widget _routeOrLunch(String typePoint, double duration) {
    if (typePoint == 'route') {
      return Expanded(
        child: Container(
          height: 60.0,
          width: 300.0,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.green)],
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer),
              Text(
                  "Tiempo promedio de recorrido: ${duration.toStringAsFixed(2)} min."),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  Widget _getContainerDay(bool showDay, int day) {
    if (showDay) {
      int dayRandom = (random.nextInt(3) + 1);

      return Container(
        height: 200.0,
        width: 350.0,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage("assets/img/day_$dayRandom.png"),
          ),
          boxShadow: [BoxShadow(blurRadius: 10.0)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "DIA:$day",
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> _listItems() {
    final List<Widget> items = [];

    int index = 0;
    int indexColor = 0;
    int lastIndex = widget.itinerarios.length;

    widget.itinerarios.forEach((itinerario) {
      _showDay = true;
      index = 0;

      for (var lugar in itinerario.lugares) {
        print(lugar.type);

        if (lugar.type != "lunch") {
          final container = Container(
            child: Column(
              children: [
                lugar.type != "route" && lugar.type != "lunch"
                    ? _getContainerDay(_showDay, itinerario.day)
                    : Container(),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 2,
                          height: 50,
                          color: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: colors[(indexColor + 1) % 3],
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child:
                              Icon(Icons.directions_run, color: Colors.white),
                        ),
                        Container(
                          width: 2,
                          height: 50,
                          color:
                              lastIndex == index ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                    lugar.type != "route" && lugar.type != "lunch"
                        ? Expanded(
                            child: Container(
                              height: 100,
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                      width: 4, color: Colors.greenAccent),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10, color: Colors.black26),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          lugar.horario != null
                                              ? Text(
                                                  '${lugar.horario.inicio} - ${lugar.horario.fin}',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      Text(lugar.name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(lugar.formattedAddress,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : _routeOrLunch(lugar.type, lugar.duration)
                  ],
                ),
              ],
            ),
          );

          _showDay = false;

          indexColor++;

          items..add(container);
        }
      }
      index++;
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
