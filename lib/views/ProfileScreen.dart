import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';
import 'package:arenago/views/UpdateProfileView.dart';
import 'package:arenago/views/gmaps/LoadMap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  //light color scheme
  final Color primaryColor = Colors.blue; // Replace kprimary color
  final Color darkColor = Colors.black; // Text color, dbg button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// profile

              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage('assets/logo.png')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: primaryColor,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              //Text(tProfileHeading, style: Theme.of(context).textTheme.headline4),
              //Text(tProfileSubHeading, style: Theme.of(context).textTheme.bodyText2),

              const SizedBox(height: 20),

              /// -- BUTTON

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileView()));
                  },
            
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, side: BorderSide.none, shape: const StadiumBorder()),
                  child: Text("Edit Profile", style: TextStyle(color: darkColor)),
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 10),



              const SizedBox(height: 10),
// -- MENU

ListTile(
  leading: Icon(Icons.settings),
  title: Text("Settings"),
  onTap: () {},
),

ListTile(
  leading: Icon(Icons.payment),
  title: Text("Billing Details"),
  onTap: () {},
),

//THIS WILl bE USED in OWNERS COPY
// ListTile(
//   leading: Icon(Icons.supervised_user_circle),
//   title: Text("User Management"),
//   onTap: () {},
// ),

Divider(),


ListTile(
  leading: Icon(Icons.location_on),
  title: Text('My Location'),
  trailing: Container(
    height: 200,
    child: LoadMap(UniqueKey()),
  ),
),

const SizedBox(height: 10),

      ListTile(
        leading: Icon(Icons.info),
        title: Text("Info"),
        onTap: () {},
      ),

      ListTile(
        leading: Icon(Icons.logout),
        title: Text("Logout"),
        textColor: Colors.red,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("LOGOUT", style: TextStyle(fontSize: 20)),
                content: Text("Are you sure, you want to Logout?"),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),//onPressed: ,//() //=> //logout(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                    child: Text("Yes"),
                  ),
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: Text("No")),
                ],
              );
            },
          );
        },
      ),            
    ],
          ),
        ),
      ),
    );
  }
}
