import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LoadMap extends StatefulWidget {
  const LoadMap(Key? key) : super(key: key);

  @override
  State<LoadMap> createState() => LoadMapState();
}

class LoadMapState extends State<LoadMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  //default initial position (you can change this)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(31.582045, 74.329376), // Default coordinates
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update the camera position with the user's location
      final CameraPosition userPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(userPosition));
    } catch (e) 
    {
      // Handle location permission denied or other errors
      print('Error getting user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {
        //marker for the user's location
        const Marker(
          markerId: MarkerId('user_location'),
          position: LatLng(31.582045, 74.329376), // Default coordinates
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      },
    );
  }
}
