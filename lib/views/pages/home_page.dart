// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_user_project/common/widgets/loader.dart';
import 'package:interview_user_project/config.dart';
import 'package:interview_user_project/controllers/user_controller.dart';
import 'package:interview_user_project/utils/utils.dart';
import 'package:interview_user_project/views/pages/profile_page.dart';
import 'package:interview_user_project/views/widgets/list_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController controller = Get.put(UserController());

  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TextEditingController 
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool isMale = false;
  bool isFemale = false;
  bool isOther = false;

  @override
  void initState() {
    super.initState();
    controller.getUsers();
  }

  @override
  void dispose() {
    super.dispose();
    ageController.clear();
    genderController.clear();
  }

  void openDialog(BuildContext context, String id, String name) => showDialog(
        context: context,
        builder: (context) =>  AlertDialog(
              title: const Text("Enter you age & gender"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Enter your age";
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter your age"),
                    ),
                    TextFormField(
                      controller: genderController,
                      validator: (value) {
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
                      // Form is Valid

                      // Store Data in map (id,name, age, gender)

                      final prefs = await SharedPreferences.getInstance();

                      try {
                        await prefs.setStringList(id, <String>[
                          name,
                          ageController.text.toString(),
                          genderController.text.toString()
                        ]);
                      } catch (e) {
                        showSnackBar(context,
                            "Error while setting the data, try again!");
                        return;
                      }

                      // Push Profile Screen with Data (id, name, age, gender)

                      // Close the pop-up and then navigate further.
                      Get.back();

                      Get.to(ProfilePage(
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
      appBar: AppBar(
        title: Text(AppConfig.applicationName),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                        "Are you sure, you want to delete app data completely"),
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
                      TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("No"))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Loader()
            : ListView.builder(
                itemCount: controller.usersList!.users!.length,
                itemBuilder: (BuildContext context, int index) {
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
