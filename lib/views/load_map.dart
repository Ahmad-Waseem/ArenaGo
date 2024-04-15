import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LoadMap extends StatefulWidget {
  
  const LoadMap(Key? key): super(key: key);

  @override
  State<LoadMap> createState() => LoadMapState();
}

class LoadMapState extends State<LoadMap> 
{
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045,  74.329376),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}