// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:interview_user_project/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:interview_user_project/views/pages/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(
      {Key? key,
      required this.id,
      required this.name,
      required this.age,
      required this.gender})
      : super(key: key);
  final String id;
  final String name;
  final String age;
  final String gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          /// [Home IconButton]
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.home)),

          /// [Logout IconButton]
          IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();

                await prefs.remove(id);
                Get.back();

                showSnackBar(context, "$name logged out");
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// [Name Text]
            Text(
              "Welcome, $name",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// [Divider]
            const SizedBox(height: 40),

            /// [Age Text]
            Text(
              "Age: $age",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// [Gender Text]
            Text(
              "Gender: $gender",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
