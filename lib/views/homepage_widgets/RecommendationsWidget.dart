import 'package:arenago/views/arenaPage.dart';
import 'package:arenago/views/bookField.dart';
import 'package:arenago/views/homepage_widgets/recommendation_backend.dart';
import 'package:arenago/views/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class RecommendationsWidget extends StatefulWidget {
  const RecommendationsWidget({super.key});

  @override
  _RecommendationsWidgetState createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  final RecommendationsBackend _backend = RecommendationsBackend();
  List<Map<dynamic, dynamic>> _availableFields = [];
  List<String> _arenaNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvailableFields();
  }

  Future<void> _fetchAvailableFields() async {
    setState(() {
      _isLoading = true;
      
    });
    final fields = await _backend.getAvailableFields();
    final arenaNames = await _fetchArenaNames(fields);
    setState(() {
      _availableFields = fields;
      debugPrint("error is now here");
      _arenaNames = arenaNames;
      _isLoading = false;
    });
  }
  //=============================> use in search
  
Future<List<String>> _fetchArenaNames(List<Map<dynamic, dynamic>> fields) async {
  List<String> arenaNames = [];
  for (var field in fields) {
    final arenaId = field['arenaId'];
    debugPrint('-->$arenaId');
    final snapshot = await FirebaseDatabase.instance.ref('ArenaInfo/$arenaId').get();
    if (snapshot.value != null) {
      final arenaData = snapshot.value as Map<dynamic, dynamic>;
      arenaNames.add(arenaData['arena_name']);
      debugPrint("\n");
      debugPrint(arenaData['arena_name']);
    } else {
      arenaNames.add('Anonymous Arena'); //arena data is not available
    }
  }
  return arenaNames;
  }//?? 

  Future<void> _changeScreen(var field) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color:loginOutlinecolor),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    FieldInfo fieldInfo = await _backend.fetchFieldInfo(field); // Implement this method to fetch FieldInfo

    
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BookField(fieldData: fieldInfo,)),
    );
  }




  @override
  Widget build(BuildContext context) {
    return _isLoading
      ? const Center(
          child: Center(child: RefreshProgressIndicator(color: loginOutlinecolor),), // Show a progress indicator while loading
        )
      :Expanded(
      child: ListView.builder(
        itemCount: _availableFields.length,
        itemBuilder: (context, index) {
          final field = _availableFields[index];
          return InkWell(
            onTap: (){
              _changeScreen(field);
            },
            child: ListTile(
            tileColor: Color.fromARGB(255, 244, 249, 250),

            leading: SizedBox(
                  width: 110,
                  height: 160, 
                  child: Image.network(
                    field['field_images'][0],
                    fit: BoxFit.fill, //fill the container
                  ),
                ),
            title: Text(_arenaNames[index]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Field ID: ${field['fieldId']}'),
                const SizedBox(height: 0.5),
                Text('Avg Price: Rs.${field['price'].toStringAsFixed(2)} '),
              ],
            ),
            trailing: _buildFieldTypeEmojis(field['fieldType']),
            
          )
      );
        },
        
      ),
      
    );
  }

  Widget _buildFieldTypeEmojis(String fieldType) {
    // Implement the logic to display emojis based on the field type
    return const Text('🏏 ⚽');
    // switch (fieldType) {
      
    //   case 'cricket':
    //     return const Text('🏏');
    //   case 'football':
    //     return const Text('⚽');
    //   case 'tennis':
    //     return const Text('🎾');
    //   default:
    //     return const SizedBox.shrink();
    // }
  }
}