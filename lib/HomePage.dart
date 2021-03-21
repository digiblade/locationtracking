import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

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
      // firebase
      //     .collection("location")
      //     .where("email", isEqualTo: "Ak@gmail.com")
      //     .get();
      // firebase.collection("location").add({
      //   "latitude": currentLocation.latitude,
      //   "longitude": currentLocation.longitude,
      //   "email": "Ak1@gmail.com",
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
      body: StreamBuilder(
          stream: firebase
              .collection('location')
              .where("email", isEqualTo: "Ak1@gmail.com")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              reverse: true,
              children: snapshot.data!.docs.map((document) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 6,
                    child: ListTile(
                      title: Text(document['email']),
                      subtitle: Wrap(
                        children: [
                          Text("latitude:" + document['latitude'].toString()),
                          SizedBox(
                            width: 8,
                          ),
                          Text("longitude:" + document['longitude'].toString())
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
