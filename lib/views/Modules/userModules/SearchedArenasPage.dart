
import 'package:arenago/views/auxilaryPages/homepage.dart';
import 'package:arenago/views/signin_signup/login_view.dart';
import 'package:arenago/views/Modules/userModules/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/Modules/userModules/UpdateProfileView.dart';
import 'package:arenago/views/gmaps/LoadMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:arenago/views/login_helpers/forgot_pw.dart';
import 'package:arenago/views/Modules/userModules/play_buddies/friendlist.dart';

class SearchedArenasPage extends StatefulWidget {
  const SearchedArenasPage({super.key});

  @override
  _SearchedArenasPageState createState() => _SearchedArenasPageState();
}

class _SearchedArenasPageState extends State<SearchedArenasPage> {


  @override
  void initState() {
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

