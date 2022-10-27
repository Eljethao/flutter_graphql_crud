import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_graphql_crud/add_user.dart';
import 'package:flutter_graphql_crud/edit_user.dart';
import 'package:flutter_graphql_crud/services/delete_user.dart';
import 'package:flutter_graphql_crud/services/get_all_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int userTotal = 0;
  var userData = {};
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    try {
      var _allUser = await getAllUsers();
      debugPrint("allUser: $_allUser");
      setState(() {
        userTotal = int.parse(_allUser['total'].toString());
        userData = _allUser;
      });
      debugPrint("userTotal: $userTotal");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _deleteUser(String? id) async {
    try {
      var _res = await deleteUser(id);
      if(_res['id'] != null || _res['id'] != ''){
        Fluttertoast.showToast(
            msg: "Delete User Success!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        _getUserData();
      }else {
        debugPrint("Delete User Failed");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        itemCount: userTotal,
        itemBuilder: (context, index) => SingleChildScrollView(
          child: Column(
            children: [
              itemCard(index),
              const Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Container itemCard(int index) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                size: 50,
                color: Colors.blue,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${userData['data'][index]['firstName']}'),
                  Text('${userData['data'][index]['lastName']}'),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Birthday: ${DateTime.tryParse(userData['data'][index]['birthday'])!.toIso8601String().split('T').first}'),
                  Text(
                      'RegisterDate: ${DateTime.tryParse(userData['data'][index]['createdAt'])!.toIso8601String().split('T').first}'),
                ],
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUser(
                        data: userData['data'][index],
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  _deleteUser(userData['data'][index]['id']);
                },
                child: Icon(Icons.delete, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }
}
