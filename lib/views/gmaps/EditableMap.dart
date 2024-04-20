import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditableMap extends StatefulWidget {
  @override
  _EditableMapState createState() => _EditableMapState();
}

class _EditableMapState extends State<EditableMap> {
  GoogleMapController? _mapController;
  LatLng _userLocation = LatLng(31.582045, 74.329376); //...Fetch from Firebase


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMarkerDragEnd(LatLng newPosition) {
    setState(() {
      _userLocation = newPosition;
      
                                    //Update Firebase with the new user location



    });
  }
  

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _userLocation, zoom: 14),
        markers: {
          Marker(
            markerId: MarkerId('user_location'),
            position: _userLocation,
            draggable: true,
            onDragEnd: _onMarkerDragEnd,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        },


      ),
    );
  }
}
