// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:interview_user_project/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ClearButtonWidget extends StatelessWidget {
  const ClearButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            /// [AlterDialog - HomeScreen]
            return AlertDialog(
              title: const Text(
                  "Are you sure, you want to delete app data completely."),
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        await preferences.clear();

                        showSnackBar(context, "App Data Cleared");
                        Get.back();
                      } catch (e) {
                        showSnackBar(context,
                            "Something went wrong, while Clearing the data");
                        return;
                      }
                    },
                    child: const Text("Yes")),
                TextButton(onPressed: () => Get.back(), child: const Text("No"))
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.clear_all),
    );
  }
}
