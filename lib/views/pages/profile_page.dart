// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_user_project/utils/utils.dart';
import 'package:interview_user_project/views/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.home)),
          IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();

                await prefs.remove(id);
                Get.offAll(() => const HomePage());

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
            Text(
              "Welcome, $name",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Age: $age",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
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
