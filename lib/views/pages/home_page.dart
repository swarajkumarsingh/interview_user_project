/// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:interview_user_project/config.dart';
import 'package:interview_user_project/utils/utils.dart';
import 'package:interview_user_project/common/widgets/loader.dart';
import 'package:interview_user_project/views/pages/profile_page.dart';
import 'package:interview_user_project/controllers/user_controller.dart';
import 'package:interview_user_project/views/widgets/list_card_widget.dart';
import 'package:interview_user_project/views/widgets/clear_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// UserController
  UserController controller = Get.put(UserController());

  /// ForKey
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// TextEditingController
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getUsers();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    ageController.dispose();
    genderController.dispose();
  }

  /// User info submit dialog
  void openDialog(BuildContext context, String id, String name) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter you age & gender"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// [Age FormField]
                TextFormField(
                  autofocus: true,
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Enter your age";
                  },
                  decoration: const InputDecoration(hintText: "Enter your age"),
                ),

                /// [Gender FormField]
                TextFormField(
                  controller: genderController,
                  validator: (value) {
                    // *Form Validation*
                    if (value!.isNotEmpty &&
                        value.toString().toLowerCase() == "male" &&
                        value.toString().toLowerCase() == "female" &&
                        value.toString().toLowerCase() == "other") {
                      return null;
                    } else if (value.toString().toLowerCase() != "male" &&
                        value.toString().toLowerCase() != "female" &&
                        value.toString().toLowerCase() != "other") {
                      return "Please enter male or female or other";
                    } else if (value.isEmpty) {
                      return "Please Enter your gender";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Gender: male, female, other",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    /// Set Local-Data

                    final String age = ageController.text.toString();
                    final String gender = genderController.text.toString();

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setStringList(id, <String>[name, age, gender]);
                  } catch (e) {
                    showSnackBar(
                        context, "Error while setting the data, try again!");
                    return;
                  }

                  /// Close the pop-up and then navigate further.
                  Get.back();

                  /// Push [Profile Screen] with Data (id, name, age, gender)
                  Get.to(() => ProfilePage(
                        id: id,
                        name: name,
                        age: ageController.text.toString(),
                        gender: genderController.text.toString(),
                      ));
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// [AppBar]
      appBar: AppBar(
        title: Text(AppConfig.applicationName),
        elevation: 0,
        actions: const [ClearButtonWidget()],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Loader()
            : ListView.builder(
                itemCount: controller.usersList!.users!.length,
                itemBuilder: (BuildContext context, int index) {
                  /// [Home Screen Lists]
                  return ListCardWidget(
                    id: controller.usersList!.users![index].id.toString(),
                    name: controller.usersList!.users![index].name.toString(),
                    openDialog: () => openDialog(
                      context,
                      controller.usersList!.users![index].id.toString(),
                      controller.usersList!.users![index].name.toString(),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
