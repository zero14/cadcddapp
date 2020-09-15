import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String _name = "";
  String _lastName = "";
  String _email = "";
  String _dateBirthday = "";

  TabController _tabController;
  ScrollController _scrollViewController;

  final List<String> _list = ["Parque", "Museo", "Playa", "Iglesia"];

  List _items;

  TextEditingController _inputDateController = new TextEditingController();

  Offset _tapPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 1, vsync: this);
    _scrollViewController = ScrollController();
    _inputDateController.text = "01/03/1991";

    _items = _list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
          backgroundColor: Colors.green,
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: [
                _createInputName(),
                _createInputLastName(),
                _createInputEmail(),
                _createInputDate(context),
                ExpansionTile(
                  title: Text("Preferencias"),
                  children: [_tag],
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ButtonTheme(
                      height: 50.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text("Guardar"),
                        onPressed: () {},
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }

  Widget get _tag {
    //popup Menu
    final RenderBox overlay = Overlay.of(context).context?.findRenderObject();

    return Tags(
      key: Key("2"),
      columns: 0,
      heightHorizontalScroll: 60 * (14 / 14),
      textField: TagsTextField(
        autofocus: false,
        textStyle: TextStyle(
          fontSize: 14,
          //height: 1
        ),
        enabled: true,
        constraintSuggestion: true,
        onSubmitted: (String str) {
          setState(() {
            _items.add(str);
          });
        },
      ),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return GestureDetector(
          child: ItemTags(
            key: Key(index.toString()),
            index: index,
            title: item,
            pressEnabled: false,
            activeColor: Colors.green[400],
            removeButton: ItemTagsRemoveButton(
              backgroundColor: Colors.green[900],
              onRemoved: () {
                setState(() {
                  _items.removeAt(index);
                });
                return true;
              },
            ),
            textScaleFactor:
                utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
            textStyle: TextStyle(
              fontSize: 14,
            ),
          ),
          onTapDown: (details) => _tapPosition = details.globalPosition,
          onLongPress: () {
            showMenu(
                    //semanticLabel: item,
                    items: <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text(item, style: TextStyle(color: Colors.blueGrey)),
                    enabled: false,
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.content_copy),
                        Text("Copy text"),
                      ],
                    ),
                  ),
                ],
                    context: context,
                    position: RelativeRect.fromRect(
                        _tapPosition & Size(40, 40),
                        Offset.zero &
                            overlay
                                .size) // & RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
                    )
                .then((value) {
              if (value == 1) Clipboard.setData(ClipboardData(text: item));
            });
          },
        );
      },
    );
  }

  Widget _createInputName() {
    return TextFormField(
      controller: TextEditingController(text: "Joel"),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Nombre",
        helperText: "",
        prefixIcon: Icon(Icons.person),
      ),
      onChanged: (value) {
        setState(() {
          _name = value;
        });
      },
    );
  }

  Widget _createInputLastName() {
    return TextFormField(
      controller: TextEditingController(text: "Pacheco"),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Apellido",
        helperText: "",
        prefixIcon: Icon(Icons.person),
      ),
      onChanged: (value) {
        setState(() {
          _lastName = value;
        });
      },
    );
  }

  Widget _createInputEmail() {
    return TextFormField(
      controller: TextEditingController(text: "joel@gmail.com"),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Correo electrónico",
        helperText: "",
        prefixIcon: Icon(Icons.email),
      ),
      onChanged: (value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget _createInputDate(context) {
    return TextFormField(
      controller: _inputDateController,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: "Fecha de Nacimiento",
        helperText: "",
        prefixIcon: Icon(Icons.date_range),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _getSelectDate(context);
      },
    );
  }

  _getSelectDate(BuildContext context) async {
    final dateInitial = new DateTime.now().year;

    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(dateInitial - 80),
      firstDate: new DateTime(dateInitial - 80),
      lastDate: new DateTime(dateInitial - 15),
      locale: Locale("es", "ES"),
    );

    if (picked != null) {
      setState(() {
        _dateBirthday = picked.toString();
        _inputDateController.text = new DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }
}
