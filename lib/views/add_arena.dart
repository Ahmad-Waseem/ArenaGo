import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddArenaView extends StatefulWidget {
  const AddArenaView({super.key});

  @override
  _AddArenaViewState createState() => _AddArenaViewState();
}

class _AddArenaViewState extends State<AddArenaView> {
  final TextEditingController _arenaNameController = TextEditingController();
  final TextEditingController _arenaPriceController = TextEditingController();
  final List<String> _selectedDays = [];
  TimeOfDay? _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? _endTime = const TimeOfDay(hour: 20, minute: 0);
  List<File> _arenaImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Arena'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _arenaNameController,
              decoration: const InputDecoration(
                labelText: 'Arena Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _arenaPriceController,
              decoration: const InputDecoration(
                labelText: 'Arena Price',
              ),
              keyboardType: TextInputType.number,
            ),
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
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(_startTime?.format(context) ?? ''),
              onTap: () => _selectStartTime(context),
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(_endTime?.format(context) ?? ''),
              onTap: () => _selectEndTime(context),
            ),
            const SizedBox(height: 16.0),
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
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _arenaImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      _arenaImages[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addArena();
              },
              child: const Text('Add Arena'),
            ),
          ],
        ),
      ),
    );
  }

  void _addArena() {
    String arenaName = _arenaNameController.text.trim();
    String arenaPrice = _arenaPriceController.text.trim();
    // You can use _selectedDays, _startTime, _endTime, and _arenaImages to store arena data
    // Perform validation if needed

    // After adding, you can navigate back or perform any other action
    Navigator.pop(context);
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

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _arenaImages = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
    }
}
