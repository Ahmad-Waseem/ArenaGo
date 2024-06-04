
import 'package:arenago/views/Modules/userModules/play_buddies/friendlist.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<FriendRequest> friendRequests = [];

  @override
  void initState() {
    super.initState();
    _loadFriendRequests();
  }

  void _loadFriendRequests() {
    FriendsService().getFriendRequests(currentUserId).listen((requests) {
      setState(() {
        friendRequests = requests;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          final request = friendRequests[index];
          return FutureBuilder<User>(
            future: _getUserById(request.fromUserId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                  title: Text(user.username),
                  subtitle: const Text('Sent you a friend request'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _acceptFriendRequest(request.id, request.fromUserId);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _rejectFriendRequest(request.id);
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Future<User> _getUserById(String userId) async {
    // Fetch user data from the Realtime Database and return a User object
    final snapshot = await FirebaseDatabase.instance.ref('users/$userId').get();
    final userData = snapshot.value as Map<dynamic, dynamic>;
    return User(
        id: userId,
        username: userData['username'],
        profilePic: userData['profilePic']);
  }

  Future<void> _acceptFriendRequest(String requestId, String fromUserId) async {
    await FriendsService()
        .acceptFriendRequest(requestId, currentUserId, fromUserId);
    debugPrint("=================================================accepted req");
  }

  Future<void> _rejectFriendRequest(String requestId) async {
    await FriendsService().rejectFriendRequest(requestId);
  }
}