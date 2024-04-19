import 'dart:io';
import 'package:arenago/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddArenaView extends StatefulWidget {
  @override
  _AddArenaViewState createState() => _AddArenaViewState();
}

class _AddArenaViewState extends State<AddArenaView> {
  final _formKey = GlobalKey<FormState>();
  final _arenaNameController = TextEditingController();
  final _arenaPriceController = TextEditingController();
  final _arenaAddressController = TextEditingController();
  final _arenaContactController = TextEditingController();
  final _arenaTownController = TextEditingController();
  final _arenaCityController = TextEditingController();

  final List<String> _selectedDays = [];


  TimeOfDay? _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? _endTime = const TimeOfDay(hour: 20, minute: 0);
  List<File> _arenaImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dBackgroundColor,
      appBar: AppBar(
        title: const Text('Register Arena'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
  TextFormField(
  controller: _arenaNameController,
  decoration: const InputDecoration(
    labelText: 'Arena Name',
    contentPadding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20), // Adjust vertical padding
    labelStyle: TextStyle(
      fontSize: 22, // Adjust font size
      fontWeight: FontWeight.bold, // Make the text bold
      height: 2.0, // Adjust height
      fontStyle: FontStyle.italic, // Apply italic style
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter arena name';
    }
    return null;
  },
),



              const SizedBox(height: 16.0),
              TextFormField(
              controller: _arenaAddressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
            ),
            const SizedBox(height: 16.0),
                        TextFormField(
              controller: _arenaTownController,
              decoration: const InputDecoration(
                labelText: 'Town',
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Town name';
                  }
                  return null;
                },
            ),
            const SizedBox(height: 16.0),
                        TextFormField(
              controller: _arenaCityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter City name';
                  }
                  return null;
                },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _arenaContactController,
              decoration: const InputDecoration(
                labelText: 'Contact',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Contact info';
                  }
                  return null;
                },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _arenaPriceController,
              decoration: const InputDecoration(
                labelText: 'Price (Rs. per hour)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
            ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  const Text('Select Days: '),
                  const SizedBox(width: 8.0),
                  for (String day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
                    FilterChip(
                      label: Text(day),
                      selected: _selectedDays.contains(day),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
          Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Set the border color
                  width: 1.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(10.0), // Set border radius
              ),
              child: Row(
              // Arrange start and end time boxes inline responsively
              children: [
                Flexible(
                  child: ListTile(
                    title: const Text('Opening Time'),
                    subtitle: Text(_startTime?.format(context) ?? ''),
                    onTap: () => _selectStartTime(context),
                  ),
                ),
                
                Container(
                  color: Colors.black, // Set the color of the divider
                  height: 50, // Set the height of the divider
                  width: 1, // Set the thickness of the divider
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: ListTile(
                    title: const Text('Closing Time'),
                    subtitle: Text(_endTime?.format(context) ?? ''),
                    onTap: () => _selectEndTime(context),

                  ),
                ),
              ],
            ),
          ),

              const SizedBox(height: 16.0),
              const SizedBox(height: 8.0),
              Row(
              children: [
                const Text('Arena Images: '),
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate),
                  onPressed: _pickImages,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
              Center(  // Add this
  child: ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processing Data')),
        );
      }
    },
    child: const Text('Add Arena',
              style: TextStyle(
                        color:Colors.black,
                        decoration: TextDecoration.none, // Add underline for clickable effect
                      ),
  ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
    Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 20, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  void _addArena() {
    String arenaName = _arenaNameController.text.trim();
    String arenaPrice = _arenaPriceController.text.trim();
    // You can use _selectedDays, _startTime, _endTime, and _arenaImages to store arena data
    // Perform validation if needed

    // After adding, you can navigate back or perform any other action
    Navigator.pop(context);
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _arenaImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
    }

}
