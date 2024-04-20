import 'package:arenago/views/gmaps/EditableMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:arenago/views/theme.dart';

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Edit Profile', style: Theme.of(context).textTheme.headline4),
        //backgroundColor: loginOutlinecolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // -- IMAGE with ICON

              Container(
                padding: const EdgeInsets.fromLTRB(100.0, 15.0, 100.0, 15.0),
                //color: loginOutlinecolor,
                decoration: BoxDecoration(
                  color:
                      loginOutlinecolor, // Set the color to blue for the border
                  borderRadius: BorderRadius.circular(
                      40), // Set the border radius for rounded corners
                ),
                //width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: secondaryColor, width: 4),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_image.jpg'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.add_location_alt_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200.0),
                                borderSide:
                                    const BorderSide(color: loginOutlinecolor),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 0),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.visibility_off),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //////////
                    const SizedBox(height: 20),

                    const Text(
                      'Drag the pointer to select location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius for rounded corners
                      child: SizedBox(
                        height: 200,
                        child: EditableMap(),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Divider(),

                    // -- Created Date and Delete Button
                    Container(
                      width: double
                          .infinity, // Make the container extend from edge to edge horizontally
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          elevation: 0,
                          disabledBackgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text('Delete Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
