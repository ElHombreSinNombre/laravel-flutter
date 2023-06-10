import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/endpoints/user.dart';
import 'dart:math';
import '../../models/user.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  late LatLng _center = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    getLocation();
    getMarkers();
  }

  Future<void> getMarkers() async {
    try {
      final List<UserModel> users = await UserService().getAll();
      setState(() {
        for (UserModel user in users) {
          _markers.add(Marker(
            markerId: MarkerId(user.id.toString()),
            position: LatLng(user.latitude!, user.longitude!),
            infoWindow: InfoWindow(
              title: user.name,
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  LatLngBounds getBounds(Set<Marker> markers) {
    final List<double> lngs =
        markers.map<double>((m) => m.position.longitude).toList();
    final List<double> lats =
        markers.map<double>((m) => m.position.latitude).toList();
    final double topMost = lngs.reduce(max);
    final double leftMost = lats.reduce(min);
    final double rightMost = lats.reduce(max);
    final double bottomMost = lngs.reduce(min);
    final LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );
    return bounds;
  }

  Future<void> getLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else {
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final position = await geolocator.getCurrentPosition();
        setState(() {
          _center = LatLng(
            position.latitude,
            position.longitude,
          );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final map = GoogleMap(
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            controller.animateCamera(
              CameraUpdate.newLatLngBounds(
                getBounds(_markers),
                50,
              ),
            );
          });
        });
      },
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 8.0,
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: _markers.isNotEmpty
            ? map
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
