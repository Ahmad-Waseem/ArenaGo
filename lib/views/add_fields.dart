import 'package:arenago/views/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart'; // For generating unique arena IDs
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class AddFieldView extends StatefulWidget {
  //const AddFieldView({super.key});
  final String arenaId;

  const AddFieldView({Key? key, required this.arenaId}) : super(key: key);
  @override
  State<AddFieldView> createState() => _AddFieldViewState();
}

class _AddFieldViewState extends State<AddFieldView> {
  final _formKey = GlobalKey<FormState>();
  final _FieldPriceController = TextEditingController();
  final _FieldBasePriceController = TextEditingController();
  final _FieldPeakPriceController = TextEditingController();
  final _FieldTimeSlotsController = TextEditingController();
  final _AvailableMaterialController = TextEditingController();
  final _fieldLengthController = TextEditingController();
  final _fieldWidthController = TextEditingController();

  String? _selectedFieldType = 'indoor'; // Default value
  String? _selectedGroundType = 'Grass'; // Default value

  List<TimeSlot> _slots = [];
  List<File> _fieldImages = [];

  // Function to handle selecting start time
  void _selectStartTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _slots.add(TimeSlot(
          startTime: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        ));
      });
    }
  }

  // Function to handle selecting end time for a specific slot
  void _selectEndTime(int index) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _slots[index].endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  // Function to remove a time slot
  void _removeSlot(int index) {
    setState(() {
      _slots.removeAt(index);
    });
  }

  // Function to validate time slots (check for overlaps)
  bool _validateSlots() {
    for (int i = 0; i < _slots.length - 1; i++) {
      for (int j = i + 1; j < _slots.length; j++) {
        if (_slots[i].startTime == _slots[j].startTime) {
          return false;
        }
      }
    }
    return true;
  }

  final _arenaAddressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fields'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 15.0),
              DropdownButtonFormField(
                value: _selectedFieldType, // Current selected value
                hint: Text(
                    'Select Field Type'), // Hint displayed before selection
                items: [
                  DropdownMenuItem(
                    value: 'indoor', // Value associated with the option
                    child: Text('Indoor'), // Text displayed for the option
                  ),
                  DropdownMenuItem(
                    value: 'outdoor',
                    child: Text('Outdoor'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a field type';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFieldType =
                        newValue!; // Update state with new value
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Field Type',
                  prefixIcon: Icon(Icons.add_location_alt_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField(
                value: _selectedGroundType, // Current selected value
                hint: Text(
                    'Select Ground Type'), // Hint displayed before selection
                items: [
                  DropdownMenuItem(
                    value: 'Grass', // Value associated with the option
                    child: Text('Grass'), // Text displayed for the option
                  ),
                  DropdownMenuItem(
                    value: 'Mat',
                    child: Text('Mat'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a field type';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGroundType =
                        newValue!; // Update state with new value
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Field Type',
                  prefixIcon: Icon(Icons.add_location_alt_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Flexible(
                    // Allows proportional resizing of the length field
                    child: TextFormField(
                      controller: _fieldLengthController,
                      decoration: InputDecoration(
                        labelText: 'Length (m)', // Shortened label
                        prefixIcon: Icon(Icons.linear_scale_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter field length';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0), // Spacing between fields
                  Flexible(
                    // Allows proportional resizing of the width field
                    child: TextFormField(
                      controller: _fieldWidthController,
                      decoration: InputDecoration(
                        labelText: 'Width (m)', // Shortened label
                        prefixIcon: Icon(Icons.linear_scale_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(200.0),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter field width';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _AvailableMaterialController,
                decoration: InputDecoration(
                  labelText: 'Available Material (e.g Gloves, Bat)',
                  prefixIcon: Icon(Icons.location_city_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter City name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _FieldPriceController,
                decoration: InputDecoration(
                  labelText: 'Price (Rs. per hour)',
                  prefixIcon: Icon(Icons.price_change_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _FieldPeakPriceController,
                decoration: InputDecoration(
                  labelText: 'Peak Price (Rs. per hour)',
                  prefixIcon: Icon(Icons.price_change_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _FieldBasePriceController,
                decoration: InputDecoration(
                  labelText: 'Base Price (Rs. per hour)',
                  prefixIcon: Icon(Icons.price_change_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200.0),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10.0),
              // Add Time Slots section
              Text(
                'Time Slots:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,

                itemCount: _slots
                    .length, // This line retrieves the number of time slots
                itemBuilder: (context, index) => TimeSlotWidget(
                  slot: _slots[index],
                  onSelectEndTime: () => _selectEndTime(index),
                  onDelete: () => _removeSlot(index),
                ),
              ),
              const SizedBox(height: 10.0),
              // Button to add a new time slot
              TextButton.icon(
                onPressed: () => _selectStartTime(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Time Slot'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Field Images: '),
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: _pickImages,
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Container(
                height: 100.0, // Set a fixed height for the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _fieldImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Image.file(
                        _fieldImages[index],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20.0),
              Center(
                // Add this
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                    _addField(); 
                  },
                  child: const Text(
                    'Add Field',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration
                          .none, // Add underline for clickable effect
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

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _fieldImages =
          pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
  }
  Future<void> _addField() async {
    try {
      final fieldId = const Uuid().v4();
      final _fieldRef = FirebaseDatabase.instance.ref(
          'FieldInfo/$fieldId'); // Replace with your actual database reference

      // Prepare arena data
      final arenaId =
          widget.arenaId; // Assuming passed as a constructor argument

      final fieldData = {
        'fieldId': fieldId, // Add the field ID as the primary key
        'arenaId': arenaId,
        //'ownerId': FirebaseAuth.instance.currentUser!.uid, // Include the owner's user ID
        'fieldType': _selectedFieldType,
        'groundType': _selectedGroundType,
        'length': double.parse(_fieldLengthController
            .text), // Assuming length is a numerical value
        'width': double.parse(
            _fieldWidthController.text), // Assuming width is a numerical value
        'availableMaterial': _AvailableMaterialController.text,
        'price': double.parse(
            _FieldPriceController.text), // Assuming price is a numerical value
        'peakPrice': double.parse(_FieldPeakPriceController
            .text), // Assuming peakPrice is a numerical value
        'basePrice': double.parse(_FieldBasePriceController
            .text), // Assuming basePrice is a numerical value
        'timeSlots': _slots.map((slot) => slot.toJson()).toList(),
        'field_images': [], // Initialize empty field_images list

      };
      // Add field data to the database
      await _fieldRef.set(fieldData);
      if (_fieldImages.isNotEmpty) {
        final storageRef =
            FirebaseStorage.instance.ref().child('field_images').child(fieldId);
        final imageUploadTasks = _fieldImages.map((image) =>
            storageRef.child(image.path.split('/').last).putFile(image));
        await Future.wait(imageUploadTasks);

        // Obtain download URLs for the uploaded images
        final List<String> imageDownloadUrls = [];
        for (final uploadTask in imageUploadTasks) {
          final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
          imageDownloadUrls.add(imageUrl);
        }
        //After image uploads are complete, update field_images with image URLs
        await _fieldRef.update({
          'field_images': imageDownloadUrls,
        });
      }
      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Field added successfully!')),
      );
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      // Handle Firebase errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding field: ${error.message}')),
      );
    } catch (error) {
      // Handle other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${error.toString()}')),
      );
    }
  }
}

// Class to represent a time slot
class TimeSlot {
  DateTime? startTime;
  DateTime? endTime;

  TimeSlot({this.startTime, this.endTime});
  Map<String, dynamic> toJson() => {
        'startTime': startTime?.toString(),
        'endTime': endTime?.toString(),
      };
  // Function to check if this slot overlaps with another
  bool overlaps(TimeSlot other) {
    if (startTime == null ||
        endTime == null ||
        other.startTime == null ||
        other.endTime == null) {
      return false; // Don't consider incomplete slots for overlap
    }
    return startTime!.isBefore(other.endTime!) &&
        endTime!.isAfter(other.startTime!);
  }

  // Function to check if this slot overlaps with another
  // bool overlaps(TimeSlot other) {
  //   if (startTime == null ||
  //       endTime == null ||
  //       other.startTime == null ||
  //       other.endTime == null) {
  //     return false; // Don't consider incomplete slots for overlap
  //   }
  //   return startTime!.isBefore(other.endTime!) &&
  //       endTime!.isAfter(other.startTime!);
  // }
}

// Widget to display and manage a single time slot
class TimeSlotWidget extends StatelessWidget {
  final TimeSlot slot;
  final VoidCallback onSelectEndTime;
  final VoidCallback onDelete;

  const TimeSlotWidget({
    required this.slot,
    required this.onSelectEndTime,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm'); // Customize format as needed
    return Row(
      children: [
        Text(
          slot.startTime != null
              ? formatter.format(slot.startTime!)
              : 'Start Time',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(width: 10.0),
        Text(
          slot.endTime != null ? formatter.format(slot.endTime!) : 'End Time',
          style: TextStyle(fontSize: 16.0),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.access_time_rounded),
          onPressed: onSelectEndTime,
          tooltip: 'Set End Time',
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: onDelete,
          tooltip: 'Remove Slot',
        ),
      ],
    );
  }
}
