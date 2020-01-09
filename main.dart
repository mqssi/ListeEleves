import 'dart:async';
import 'package:http/http.dart' as http;


import 'dart:convert';
import 'package:flutter/material.dart';

const baseUrl = "https://api.myjson.com/bins/1awt3o";

class API {
  static Future getUsers() {
    var url = baseUrl;
    return http.get(url);
  }
}




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liste d\'appel',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}


class _HomeScreenState extends State {
  var users = List<User>();
  var usersAbsent = List<User>();

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("B1-G1"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {_pushAbsentLateScreen(usersAbsent);}
            )
          ],
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].nom + " " + users[index].prenom),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(
                          users[index].absent ? Icons.error_outline : Icons
                              .error_outline,
                          color: users[index].retard ? Colors.red : Colors
                              .green),
                      onPressed: () {
                        setState(() {
                          if (users[index].retard == true) {
                            users[index].retard = false;
                          } else {
                            users[index].retard = true;
                          }
                        });
                      },
                    ),

                  ]),
            );
          },
        ));
  }

  void _pushAbsentLateScreen(usersAbsent) {
    Navigator.push(context,
      new MaterialPageRoute(builder: (context) {
        return new AbsentLateScreen(usersAbsent, users);
      }),
    );
  }
}


class User {
  String nom;
  String prenom;
  bool absent;
  bool retard;

  Map toJson() {
    return {'nom': nom, 'prenom': prenom, 'absent': absent, 'retard': retard};
  }


  User.fromJson(Map json)
      : nom = json['nom'],
        prenom = json['prenom'],
        absent = false,
        retard = false;


  User(String nom, String prenom, bool absent, bool retard) {
    this.nom = nom;
    this.prenom = prenom;
    this.absent = absent;
    this.retard = retard;
  }


}

class AbsentLateScreen extends StatelessWidget {
  final usersAbsent;
  final users;
  AbsentLateScreen(this.usersAbsent, this.users);


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('élèves absents')),
      body: ListView.builder(
        itemCount: usersAbsent.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(usersAbsent[index].nom + " " + usersAbsent[index].prenom),
            trailing: Icon(Icons.cancel, color: Colors.red),
            onTap: () {      // Add 9 lines from here...
              users[index].absent = false;
              usersAbsent.remove(usersAbsent[index]);
            },
          );
        },
      ),
    );
  }
}