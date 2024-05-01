import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditableMap extends StatefulWidget {
  
  final LatLng initialLocation;
  final Function(LatLng) onLocationChanged;

  EditableMap({required this.initialLocation, required this.onLocationChanged});

  @override
  _EditableMapState createState() => _EditableMapState();
}

class _EditableMapState extends State<EditableMap> {
  GoogleMapController? _mapController;
  late LatLng _userLocation; //...default, overright if passed
  
  @override
  void initState() {
    super.initState();
    _userLocation = widget.initialLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMarkerDragEnd(LatLng newPosition) {
    setState(() {
      _userLocation = newPosition;
      widget.onLocationChanged(_userLocation);
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

        
        // Allow only panning gestures
        gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
      ),
    );
  }
}
