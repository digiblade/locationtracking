import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final double? lat;
  final double? lon;
  MapsPage({
    Key? key,
    this.lat,
    this.lon,
  }) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(137.41554, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    setCustomMapPin();
  }

  BitmapDescriptor? pinLocationIcon;
  Set<Marker> _markers = {};
  void setCustomMapPin() async {
    // pinLocationIcon = BitmapDescriptor.defaultMarker;
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/marker.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(widget.lat!, widget.lon!);
    CameraPosition initialLocation =
        CameraPosition(target: LatLng(widget.lat!, widget.lon!));

    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        backgroundColor: Color(0xFFFC5C00),
      ),
      body: GoogleMap(
        // mapType: MapType.hybrid,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId("home"),
                position: pinPosition,
                icon: pinLocationIcon!));
          });
        },
      ),
    );
  }
}
