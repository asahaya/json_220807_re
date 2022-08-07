import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = getUsers();
  static List<User> getUsers() {
    const data = [
      //jsonの書き方
      {
        "username": "inio",
        "email": "inio@gmail.com",
        "urlAvatar":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Inio_Asano_at_TCAF_2018.jpg/1200px-Inio_Asano_at_TCAF_2018.jpg",
      },
      {
        "username": "tadanobu",
        "email": "tadanobu@gmail.com",
        "urlAvatar":
            "http://www.anore.co.jp/tadanobu_asano/images/photo_01.jpg",
      },
    ];

    return data.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON DATA'),
        centerTitle: true, //中央揃え
      ),
      body: Center(child: buildUsers(users)),
    );
  }

  Widget buildUsers(List<User> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final userDB = users[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(userDB.urlAvatar),
              ),
              title: Text(userDB.username),
              subtitle: Text(userDB.email),
            ),
          );
        });
  }
}

class User {
  final String username;
  final String email;
  final String urlAvatar;

  const User({
    required this.username,
    required this.email,
    required this.urlAvatar,
  });
  static User fromJson(jsondata) => User(
        username: jsondata['username'],
        email: jsondata['email'],
        urlAvatar: jsondata['urlAvatar'],
      );
}
