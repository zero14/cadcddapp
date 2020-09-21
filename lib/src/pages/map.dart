import 'package:fasturista/src/models/Lugar.dart';
import 'package:fasturista/src/models/PageAnimate.dart';
import 'package:fasturista/src/models/PinData.dart';
import 'package:fasturista/src/pages/OptimalPath.dart';
import 'package:fasturista/src/providers/LugarProvider.dart';
import 'package:fasturista/src/providers/MenuProvider.dart';
import 'package:fasturista/src/routes/router.dart';
import 'package:fasturista/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTourist extends StatefulWidget {
  @override
  State<MapTourist> createState() => MapTouristState();
}

class MapTouristState extends State<MapTourist> {
  GoogleMapController _mapController;

  List<Itinerario> itinerarios;

  BitmapDescriptor pinLocationIcon;

  LatLng _defaultPosition = LatLng(-12.032654973289382, -77.07533940490184);

  Position _currentPosition;
  int indice = 0;

  Set<Marker> _markers = {};

  // LatLng _lastMapPosition = LatLng(-12.032654973289382, -77.07533940490184);

  bool _isSearchText = false;

  MapType _currentMapType = MapType.normal;

  bool _isLoading = false;

  double _pinPillPosition = -100;

  PinData _currentPinData = PinData(
      showLocation: false,
      pinPath: null,
      pinPathLocal: null,
      avatarPath: null,
      avatarPathLocal: null,
      location: LatLng(0, 0),
      locationName: '',
      locationAddress: "",
      labelColor: Colors.grey);

  double _verticalButtonMyPosition = 15.0;
  double _horizontalButtonMyPosition = 25.0;

  String _imageDefault = "assets/img/sinfoto.png";

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _setIconCurrentLocation();
  }

  void _getCurrentPosition() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    _isLoading = true;

    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _isLoading = false;

    _addMarkerPositionInitial();
  }

  void _setIconCurrentLocation() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/img/turista_varon.png');
  }

  void _onCameraMove(CameraPosition position) {
    // _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // _setMapPins();
  }

  void _centerPosition() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 14.0),
      ),
    );
  }

  void _addMarkerPositionInitial() {
    setState(() {
      if (indice == 0) {
        _markers.add(
          Marker(
              markerId: MarkerId("pinicial"),
              icon: pinLocationIcon,
              position:
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
              infoWindow: InfoWindow(
                title: "Mi posición",
                snippet: "Posición actual",
              ),
              onTap: () {
                setState(() {
                  _currentPinData = PinData(
                      showLocation: true,
                      pinPath: null,
                      avatarPath: null,
                      pinPathLocal: 'assets/img/turista_varon.png',
                      locationName: "Mi posición",
                      locationAddress: null,
                      location: _currentPosition != null
                          ? LatLng(_currentPosition.latitude,
                              _currentPosition.longitude)
                          : _defaultPosition,
                      avatarPathLocal: "assets/img/profile1.jpg",
                      labelColor: Colors.blue);
                  _pinPillPosition = 0;
                  _verticalButtonMyPosition = 100.0;
                });
              }),
        );
      }
    });

    if (_currentPosition != null) {
      print(
          "Latitud:${_currentPosition.latitude.toString()}, Longitud:${_currentPosition.longitude.toString()}");
    }
    _centerPosition();
  }

  Future<void> _buscarPuntoInteres(String textSearch) async {
    final lugarProvider = LugarProvider();

    _isLoading = true;
    int index = 0;

    itinerarios = await lugarProvider.getItinerario(
        _currentPosition.latitude, _currentPosition.longitude, textSearch);

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
            markerId: MarkerId("Mi posición"),
            icon: pinLocationIcon,
            position:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            infoWindow: InfoWindow(
              title: "Mi posición",
              snippet: "Posición actual",
            ),
            onTap: () {
              setState(() {
                // _currentPinData = _sourcePinInfo;
                _currentPinData = PinData(
                    showLocation: true,
                    pinPath: null,
                    pinPathLocal: 'assets/img/turista_varon.png',
                    locationName: "Mi posición",
                    locationAddress: null,
                    location: _currentPosition != null
                        ? LatLng(_currentPosition.latitude,
                            _currentPosition.longitude)
                        : _defaultPosition,
                    avatarPathLocal: "assets/img/profile1.jpg",
                    avatarPath: null,
                    labelColor: Colors.blue);
                _pinPillPosition = 0;
                _verticalButtonMyPosition = 100.0;
              });
            }),
      );

      for (final item in itinerarios) {
        for (var lugar in item.lugares) {
          index++;

          _markers.add(
            Marker(
                markerId: MarkerId("markeid$index"),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(lugar.lat, lugar.lng),
                infoWindow: InfoWindow(
                  title: lugar.name,
                ),
                onTap: () {
                  setState(() {
                    // _currentPinData = _sourcePinInfo;
                    _currentPinData = PinData(
                      showLocation: false,
                      // pinPath: 'assets/img/turista_varon.png',
                      pinPath: null,
                      pinPathLocal: 'assets/img/marker.png',
                      locationName: lugar.name,
                      locationAddress: lugar.formattedAddress != null
                          ? lugar.formattedAddress
                          : "",
                      location: LatLng(lugar.lat, lugar.lng),
                      avatarPath: lugar.icon,
                      avatarPathLocal: null,
                      labelColor: Colors.blue,
                    );
                    _pinPillPosition = 0;
                    _verticalButtonMyPosition = 100.0;
                  });
                }),
          );
        }
      }

      _isLoading = false;
    });
  }

  List<Widget> _listItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    opciones..add(_menuUserInfo());

    data.forEach((item) {
      final widgetItem = ListTile(
        title: Text(item["name"]),
        leading: getIcon(item["icon"]),
        onTap: () {
          Navigator.push(
            context,
            PageAnimated(page: getRoutePage(item["path"]))
                .slideRightTransition(),
          );
        },
      );

      opciones..add(widgetItem)..add(Divider());
    });

    return opciones;
  }

  Widget _crearLoading() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // children: <Widget>[CircularProgressIndicator()],
            children: [
              Container(
                height: 160.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80.0),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2.0)],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/img/loading_walk_man.gif",
                      scale: 4.5,
                    ),
                    Text("Cargando...")
                  ],
                ),
              )
              // CircularProgressIndicator()
            ],
          ),
          SizedBox(height: 15.0)
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _menuProfile() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // place the logout at the end of the drawer
        children: [
          Flexible(child: _listaMenu()),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            dense: true,
            leading: Icon(Icons.subdirectory_arrow_left),
            title: Text("Cerrar sesión"),
            trailing: Text(
              "Version 1.0",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaMenu() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (context, snapshot) => ListView(
        shrinkWrap: true,
        children: _listItems(snapshot.data, context),
      ),
    );
  }

  Widget _menuUserInfo() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      accountName: Padding(
        child: Row(
          children: <Widget>[
            Text("Joel Pacheco"),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.green,
              ),
              onPressed: () {},
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 10),
      ),
      accountEmail: Text("joel.pacheco@gmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
            ? Colors.green
            : Colors.green,
        backgroundImage: const AssetImage("assets/img/profile1.jpg"),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      zoomControlsEnabled: false,
      onMapCreated: _onMapCreated,
      //myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
            : _defaultPosition,
        zoom: 8.0,
      ),
      mapType: _currentMapType,
      markers: _markers.toSet(),
      onCameraMove: _onCameraMove,
      onTap: (LatLng location) {
        setState(() {
          _pinPillPosition = -100;
          _verticalButtonMyPosition = 15.0;
        });
      },
    );
  }

  Widget _rowSearchAppBar() {
    if (_isSearchText) {
      return _searchText();
    } else {
      return _defaultSearch();
    }
  }

  Widget _defaultSearch() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "fasturista",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _isSearchText = true;
            });
          },
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _searchText() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Buscar",
              focusColor: Colors.white,
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(1.0),
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchText = false;
                      });
                    }),
              ),
            ),
            onSubmitted: (text) async {
              setState(() {
                _buscarPuntoInteres(text);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getButtonPath(BuildContext context) {
    if (_markers != null && _markers.length > 2) {
      return Padding(
        // padding: const EdgeInsets.all(15.0),
        padding: EdgeInsets.symmetric(
          vertical: _verticalButtonMyPosition,
          horizontal: 10.0,
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: "optimalpath",
            onPressed: () {
              Navigator.push(
                  context,
                  PageAnimated(
                      page: OptimalPath(
                    itinerarios: itinerarios,
                  )).slideTransition());
            },
            child: Text("Ruta"),
            backgroundColor: Colors.green,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildAvatar() {
    if (_currentPinData.avatarPath != null) {
      return Container(
        margin: const EdgeInsets.only(left: 10),
        width: 50,
        height: 50,
        child: ClipOval(child: Image.network(_currentPinData.avatarPath)),
      );
    } else if (_currentPinData.avatarPathLocal != null) {
      return Container(
        margin: const EdgeInsets.only(left: 10),
        width: 50,
        height: 50,
        child: ClipOval(child: Image.asset(_currentPinData.avatarPathLocal)),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 10),
        width: 50,
        height: 50,
        child: ClipOval(child: Image.asset(_imageDefault)),
      );
    }
  }

  Widget _buildLocationInfo(BuildContext context) {
    if (_currentPinData.showLocation != null && _currentPinData.showLocation) {
      return Expanded(
        child: Container(
          // margin: EdgeInsets.only(left: 0.0),
          child: Column(
            children: [
              Text(
                _currentPinData.locationName,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                "Latitud:${_currentPinData.location.latitude}",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(
                "Longitud:${_currentPinData.location.longitude}",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        // margin: EdgeInsets.only(left: 0.0),
        child: Column(
          children: [
            Text(
              _currentPinData.locationName,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              _currentPinData.locationAddress,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkerType() {
    if (_currentPinData.pinPath != null) {
      return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.network(
            _currentPinData.pinPath,
            width: 30,
            height: 35,
          ));
    } else if (_currentPinData.pinPathLocal != null) {
      return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            _currentPinData.pinPathLocal,
            width: 30,
            height: 35,
          ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _rowSearchAppBar(),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          _googleMaps(),
          _crearLoading(),
          AnimatedPositioned(
            bottom: _pinPillPosition,
            right: 0,
            left: 0,
            duration: const Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 20,
                        offset: Offset.zero,
                        color: Colors.grey.withOpacity(0.5),
                      )
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAvatar(),
                    _buildLocationInfo(context),
                    _buildMarkerType()
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _getButtonPath(context),
              Padding(
                // padding: const EdgeInsets.all(15.0),
                padding: EdgeInsets.symmetric(
                  vertical: _verticalButtonMyPosition,
                  horizontal: _horizontalButtonMyPosition,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: _addMarkerPositionInitial,
                    child: Icon(Icons.my_location),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      drawer: _menuProfile(),
    );
  }
}
