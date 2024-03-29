import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/src/providers/locationProvider.dart';
import 'package:seller_app/src/screens/shopInfo.dart';
import 'package:seller_app/src/screens/shopInfoForm.dart';
import 'package:seller_app/src/services/authService.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  var hasShop;
  var name;
  var address;
  var description;

  MapScreen({required this.hasShop, required this.name, required this.address, required this.description});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  String googleApikey = "AIzaSyDOJ2t5HwT4OHU10hT4Ing9OFtQGtwy150";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  String location = "Search Location";
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        mapController = controller;
      });
    }

    FirebaseFirestore.instance
        .collection('sellers')
        .get()
        .then((value) => value.docs.forEach((element) {
              var docRef = FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(AuthService().currentUser!.uid);
              docRef.update({'longitude': locationData.longitude});
              docRef.update({'latitude': locationData.latitude});
            }));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Shop Location',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ShopInfoScreen(
                hasShop: widget.hasShop,
                name: widget.name,
                address: widget.address,
                description: widget.description,
              ))),
        ),
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.476,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {},
            ),
            Center(
              child: Container(
                height: 35,
                margin: EdgeInsets.only(bottom: 40),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[600]),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ShopInfoFormScreen(
                              hasShop: widget.hasShop,
                              name: widget.name,
                              address: widget.address,
                              description: widget.description,
                            )));
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              child: InkWell(
                onTap: () async {
                  var place = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: googleApikey,
                      mode: Mode.overlay,
                      types: [],
                      strictbounds: false,
                      components: [Component(Component.country, 'sg')],
                      onError: (err) {
                        print(err);
                      });
                  if (place != null) {
                    setState(() {
                      location = place.description.toString();
                    });
                    final plist = GoogleMapsPlaces(
                      apiKey: googleApikey,
                      apiHeaders: await GoogleApiHeaders().getHeaders(),
                    );
                    String placeid = place.placeId ?? "0";
                    final detail = await plist.getDetailsByPlaceId(placeid);
                    final geometry = detail.result.geometry!;
                    final lat = geometry.location.lat;
                    final lang = geometry.location.lng;
                    var newlatlang = LatLng(lat, lang);
                    mapController?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: newlatlang, zoom: 17)));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        title: Text(
                          location,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.search),
                        dense: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
