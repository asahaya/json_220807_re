import 'dart:convert';

import 'package:flutter/material.dart';

class MyHttpPage extends StatefulWidget {
  const MyHttpPage({Key? key}) : super(key: key);

  @override
  State<MyHttpPage> createState() => _MyHttpPageState();
}

class _MyHttpPageState extends State<MyHttpPage> {
  late Future<List<User>> usersFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usersFuture = getUsers(context);
  }

  static Future<List<User>> getUsers(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/user.json');

    final body = json.decode(data);
    return body.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON DATA'),
        centerTitle: true, //中央揃え
      ),
      body: Center(
          child: FutureBuilder<List<User>>(
              future: usersFuture,
              builder: (context, snapshot) {
                //読み込み
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                  //通信エラー表示
                } else if (snapshot.hasError) {
                  return Text("SORRY ${snapshot.error}");
                  //データがある場合
                } else if (snapshot.hasData) {
                  final users = snapshot.data!;

                  return buildUsers(users);
                  //データがない場合
                } else {
                  return const Text('No User DATA');
                }
              })),
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
