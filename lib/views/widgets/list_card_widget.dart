// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_user_project/views/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCardWidget extends StatelessWidget {
  const ListCardWidget(
      {Key? key,
      required this.id,
      required this.name,
      required this.openDialog})
      : super(key: key);
  final String id;
  final String name;
  final VoidCallback openDialog;

  void onSignInPress() async {
    // check if user exists in the DB, if yes push profile screen with (id, name, age, gender) else show openDialog
    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String>? data = prefs.getStringList(id);

    if (data == null) {
      // Data not present - new user
      return openDialog();
    } else {
      printInfo(info: "User age ${data[1]}");
      // Data present - old user
      Get.to(
          ProfilePage(id: id, name: name, age: data[1], gender: data[2]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          "$id. ",
          style: const TextStyle(fontSize: 20),
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        trailing: ElevatedButton(
          onPressed: onSignInPress,
          child: const Text("Sign-in"),
        ),
      ),
    );
  }
}
