import 'package:arenago/views/gmaps/LoadMap.dart';
import 'package:flutter/material.dart';


class TestingMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add any other widgets you want (e.g., buttons, labels)
            Text('Test the Map:'),
            SizedBox(height: 16),
            LoadMap(UniqueKey()), // Display the EditableMap widget
          ],
        ),
      ),
    );
  }
}
