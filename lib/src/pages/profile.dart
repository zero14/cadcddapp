import 'dart:convert';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  final List<String> _list = ["Parque", "Iglesia"];
  File _image;
  List _items;
  String _name = "";
  String _lastName = "";
  String _email = "";
  String _dateBirthday = "";

  // TabController _tabController;
  // ScrollController _scrollViewController;

  TextEditingController _inputDateController = new TextEditingController();
  TextEditingController _inputNameController = new TextEditingController();
  TextEditingController _inputLastNameController = new TextEditingController();
  TextEditingController _inputEmailController = new TextEditingController();

  Offset _tapPosition;
  bool _editEnabled = false;

  @override
  void initState() {
    super.initState();

    // _tabController = TabController(length: 1, vsync: this);
    // _scrollViewController = ScrollController();
    _inputDateController.text = "01-03-1991";
    _inputNameController.text = "Joel";
    _inputLastNameController.text = "Pacheco";
    _inputEmailController.text = "joel@gmail.com";

    _items = _list.toList();
  }

  Future _imgFromGallery() async {
    final pickedImage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  Future _imgFromCamera() async {
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Galería de Fotos'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camara'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _createButtonSave() {
    if (!this._editEnabled) return Container();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ButtonTheme(
        height: 50.0,
        child: RaisedButton(
          textColor: Colors.white,
          color: Colors.green,
          child: Text("Guardar"),
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
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
        enabled: _editEnabled,
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
              onRemoved: !_editEnabled
                  ? null
                  : () {
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
                      children: [
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

  Widget _createImageProfile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(50.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: _editEnabled
            ? () {
                // _imgFromGallery();
                _showPicker(context);
              }
            : null,
        child: CircleAvatar(
          radius: 65,
          backgroundColor: Colors.green[200],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(_image,
                        width: 120, height: 120, fit: BoxFit.fitHeight),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 120,
                    height: 120,
                    child: Icon(Icons.camera_alt, color: Colors.grey[800]),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _createInputName() {
    return TextFormField(
      enabled: _editEnabled,
      controller: _inputNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: _editEnabled
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
            : null,
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
      enabled: _editEnabled,
      controller: _inputLastNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: _editEnabled
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
            : null,
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
      enabled: _editEnabled,
      controller: _inputEmailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: _editEnabled
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
            : null,
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
      enabled: _editEnabled,
      controller: _inputDateController,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        border: _editEnabled
            ? OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
            : null,
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

  Icon _showButtonEditOrCancel() {
    return _editEnabled
        ? Icon(Icons.close, color: Colors.white)
        : Icon(Icons.edit, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: _showButtonEditOrCancel(),
              onPressed: () {
                setState(() {
                  _editEnabled = !_editEnabled;
                });
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _createImageProfile()),
                  ],
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      _createInputName(),
                      _createInputLastName(),
                      _createInputEmail(),
                      _createInputDate(context),
                      ExpansionTile(
                        maintainState: _editEnabled,
                        initiallyExpanded: !_editEnabled,
                        title: Text("Preferencias"),
                        children: [_tag],
                      ),
                      _createButtonSave()
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
