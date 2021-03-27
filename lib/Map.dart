// import 'dart:async';
import 'dart:collection';

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
  // Completer<GoogleMapController> _controller = Completer();

  CameraPosition loctiondata = CameraPosition(
    target: LatLng(1.41554, -12.085749655962),
    zoom: 14.4746,
  );
  Set<Marker> _markers = HashSet<Marker>();
  // GoogleMapController? _mapController;
  BitmapDescriptor? _markerIcon;
  LatLng location = LatLng(37.77483, -122.41942);
  @override
  void initState() {
    super.initState();

    _setMarkerIcon();
    // location = LatLng(widget.lat!, widget.lon!);
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/marker.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    // _mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("0"),
          position: location,
          infoWindow: InfoWindow(
            title: "San Francsico",
            snippet: "An Interesting city",
          ),
          icon: _markerIcon!,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.lat);
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        backgroundColor: Color(0xFFFC5C00),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.77483, -122.41942),
          zoom: 32,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
