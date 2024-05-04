import 'package:firebase_database/firebase_database.dart';
import 'package:arenago/views/ProfileScreen.dart';
import 'package:arenago/views/homepage.dart';
import 'package:arenago/views/search.dart';
import 'package:flutter/material.dart';
import 'package:arenago/views/theme.dart';


class PlayBuddiesPage extends StatefulWidget {
  const PlayBuddiesPage({super.key});

  @override
  _PlayBuddiesState createState() => _PlayBuddiesState();
}

class _PlayBuddiesState extends State<PlayBuddiesPage> {
  int _selectedIndex = 1;
  String searchText = "";
  List<String> friends = [];
  List<FriendRequest> friendRequests = [];
  List<User> nonFriends = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load friends
    FriendsService().getFriends('currentUserId').listen((friendIds) {
      setState(() {
        friends = friendIds;
      });
    });

    // Load friend requests
    FriendsService().getFriendRequests('currentUserId').listen((requests) {
      setState(() {
        friendRequests = requests;
      });
    });

    // Load non-friends
    FriendsService().searchUsers(searchText).listen((users) {
      setState(() {
        nonFriends = users
            .where((user) =>
                !friends.contains(user.id) &&
                !friendRequests.any((request) =>
                    request.fromUserId == user.id ||
                    request.toUserId == user.id))
            .toList();
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ));
    } else if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PlayBuddiesPage(),
      ));
    } else if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArenaGo'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              // Navigate to the friend requests page
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FriendRequestsPage(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 10.0,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    _loadData();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                if (friends.isNotEmpty) _buildFriendsList(friends),
                if (friendRequests.isNotEmpty)
                  _buildFriendRequestsList(friendRequests),
                if (nonFriends.isNotEmpty) _buildNonFriendsList(nonFriends),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: dBackgroundColor,
        unselectedItemColor: loginOutlinecolor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Arena',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildFriendsList(List<String> friendIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Friends',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: friendIds.length,
          itemBuilder: (context, index) {
            final friendId = friendIds[index];
            return FutureBuilder<User>(
              future: _getUserById(friendId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final friend = snapshot.data!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(friend.profilePic),
                    ),
                    title: Text(friend.username),
                    subtitle:
                        const Text('Some Cringy description for everyone'),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.green),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFriendRequestsList(List<FriendRequest> requests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Friend Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
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
                            _acceptFriendRequest(
                                request.id, request.fromUserId);
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
      ],
    );
  }

  Widget _buildNonFriendsList(List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'People You May Know',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              title: Text(user.username),
              subtitle: const Text('Some Cringy description for everyone'),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () {
                  _sendFriendRequest(user.id);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<User> _getUserById(String userId) async {
    // Fetch user data from the Realtime Database and return a User object
    final snapshot = await FirebaseDatabase.instance.ref('users/$userId').get();
    final userData = snapshot.value as Map<dynamic, dynamic>;
    return User(id: userId, username: userData['username'], profilePic: userData['profilePic']);
  }

  Future<void> _sendFriendRequest(String toUserId) async {
    await FriendsService().sendFriendRequest('currentUserId', toUserId);
  }

  Future<void> _acceptFriendRequest(String requestId, String fromUserId) async {
    await FriendsService()
        .acceptFriendRequest(requestId, 'currentUserId', fromUserId);
  }

  Future<void> _rejectFriendRequest(String requestId) async {
    await FriendsService().rejectFriendRequest(requestId);
  }
}

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
    FriendsService().getFriendRequests('currentUserId').listen((requests) {
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
    return User(id: userId, username: userData['username'], profilePic: userData['profilePic']);
  }

  Future<void> _acceptFriendRequest(String requestId, String fromUserId) async {
    await FriendsService()
        .acceptFriendRequest(requestId, 'currentUserId', fromUserId);
  }

  Future<void> _rejectFriendRequest(String requestId) async {
    await FriendsService().rejectFriendRequest(requestId);
  }
}

class FriendsService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Send a friend request
  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    final newRequestRef = _database.ref('friendRequests').push();
    await newRequestRef.set({
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Yes a friend request
  Future<void> acceptFriendRequest(
      String requestId, String userId, String friendId) async {
    // Yes, Yes, Yes
    await _database.ref('friends/$userId/$friendId').set(true);
    await _database.ref('friends/$friendId/$userId').set(true);

    // No more friend
    await _database.ref('friendRequests/$requestId').remove();
  }

  // decline a proposal
  Future<void> rejectFriendRequest(String requestId) async {
    await _database.ref('friendRequests/$requestId').remove();
  }

  // Friend Request List Getter
  Stream<List<FriendRequest>> getFriendRequests(String userId) {
    return _database
        .ref('friendRequests')
        .orderByChild('toUserId')
        .equalTo(userId)
        .onValue
        .map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries
            .map((entry) => FriendRequest(
                  id: entry.key,
                  fromUserId: entry.value['fromUserId'],
                  toUserId: entry.value['toUserId'],
                  timestamp: entry.value['timestamp'],
                ))
            .toList();
      }
      return [];
    });
  }

  // My friends getter
  Stream<List<String>> getFriends(String userId) {
    return _database.ref('friends/$userId').onValue.map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.keys.map((key) => key as String).toList();
      }
      return [];
    });
  }

  // Search for users
  Stream<List<User>> searchUsers(String query) {
    return _database
        .ref('users')
        .orderByChild('username')
        .startAt(query)
        .endAt('$query\uf8ff')
        .onValue
        .map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries
            .map((entry) => User(
                  id: entry.key,
                  username: entry.value['username'],
                  profilePic: entry.value['profilePic']
                ))
            .toList();
      }
      return [];
    });
  }
}

class FriendRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final int timestamp;

  FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.timestamp,
  });
}

class User {
  final String id;
  final String username;
  final String profilePic;

  User({
    required this.id,
    required this.username,
    required this.profilePic,
  });
}
