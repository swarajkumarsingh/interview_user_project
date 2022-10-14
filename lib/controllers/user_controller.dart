// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:interview_user_project/models/user.dart';
import 'package:interview_user_project/constants/constants.dart';

class UserController extends GetxController {
  // Controller Global Variables
  User? usersList;
  var isLoading = false.obs;

  getUsers() async {
    try {
      isLoading.value = true;

      http.Response response =
          await http.get(Uri.tryParse(BASE_URI)!, headers: {});

      if (response.statusCode != 200) {
        return Get.snackbar("Error", "Something went wrong, Try again");
      }
      var result = json.decode(response.body);
      usersList = User.fromJson(result[0]);
    } catch (e) {
      return Get.snackbar("Error", "Something went wrong, Try again");
    } finally {
      isLoading.value = false;
    }
  }
}
