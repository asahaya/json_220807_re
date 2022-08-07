---
title: "Jsonを使ってListViewを作ってみよう"
emoji: "📘"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: []
published: true
---


xxxxxxxxxxxxx
![](/images/json_build.jpg)

---
-JSONデータを直接dartファイルに打ち込む場合

```dart:main.dart
import 'package:flutter/material.dart';
import 'package:json_220807_re/home_http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHttpPage(),
    );
  }
}
```



```dart:home_page.dart
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

```

---



```dart:http_page.dart

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

```

 ```json:user.json
    
    [
    { 
        "username": "inio",
        "email": "inio@gmail.com",
        "urlAvatar":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Inio_Asano_at_TCAF_2018.jpg/1200px-Inio_Asano_at_TCAF_2018.jpg"
      },
      {
        "username": "tadanobu",
        "email": "tadanobu@gmail.com",
        "urlAvatar":
            "http://www.anore.co.jp/tadanobu_asano/images/photo_01.jpg"
      }
    ]



```
```dart:

```