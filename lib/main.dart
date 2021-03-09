import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Location location = new Location();
  late bool serviceEnabled;
  late PermissionStatus permissionStatus;
  late LocationData locationData;
  final firebase = FirebaseFirestore.instance;
  checkService() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
  }

  checkPermission() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  getLocation() async {
    locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      print(currentLocation.longitude);
      firebase
          .collection("location")
          .where("email", isEqualTo: "Ak@gmail.com")
          .get();
      // firebase.collection("location").add({
      //   "latitude": currentLocation.latitude,
      //   "longitude": currentLocation.longitude,
      //   "email": "Ak@gmail.com",
      // });
    });
  }

  @override
  void initState() {
    super.initState();
    checkService();
    checkPermission();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            getLocation();
          },
          child: Text("Location"),
        ),
      ),
    );
  }
}
