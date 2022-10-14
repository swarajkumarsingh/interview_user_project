// ignore_for_file: unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:interview_user_project/views/pages/profile_page.dart';

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

  /// *Check if Data is present if not, then show dialog else push profile page
  void onSignInPress() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data = prefs.getStringList(id);

    if (data == null) {
      // Data not present - new user
      return openDialog();
    } else {
      printInfo(info: "User age ${data[1]}");
      // Data present - old user

      /// * User-Data
      final String name = data[0];
      final String age = data[1];
      final String gender = data[2];
      Get.to(() => ProfilePage(id: id, name: name, age: age, gender: gender));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        /// [ID Text]
        leading: Text(
          "$id. ",
          style: const TextStyle(fontSize: 20),
        ),

        /// [Name Text]
        title: Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),

        /// [Sign-In Button]
        trailing: ElevatedButton(
          onPressed: onSignInPress,
          child: const Text("Sign-in"),
        ),
      ),
    );
  }
}
