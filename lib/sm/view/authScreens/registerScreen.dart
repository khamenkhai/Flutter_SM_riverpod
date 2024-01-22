import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sm_project/sm/controllers/authController.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/commonWidgets/circleCameraButton.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  Uint8List? _profileImage;

  bool isObscure = true;

  _pickProfileImage(bool isCamera) async {
    _profileImage = await pickImage(isCamera);
    setState(() {});
  }

  navigateBackToLogin(BuildContext context) {
    Navigator.pop(context);
  }

  signUp(WidgetRef ref) {
    if (_profileImage == null) {
      showMessageSnackBar(
          message: "You have to choose profile picture!", context: context);
    } else {
      ref.read(authControllerProvider.notifier).createNewAccount(
            email: _email.text,
            password: _password.text,
            context: context,
            name: _username.text,
            profileFile: _profileImage!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Create new account"),
          leading: IconButton(
              onPressed: () {
                navigateBackToLogin(context);
              },
              icon: Icon(Icons.clear))),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),

                ///profile image selection
                Column(
                  children: [
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        _profileImage != null
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade200, width: 3),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(_profileImage!),
                                  radius: 64,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade200, width: 3),
                                ),
                                child: CircleAvatar(
                                  child: Icon(IconlyBold.profile, size: 50),
                                  radius: 64,
                                ),
                              ),

                        //camerabutton
                        Positioned(
                            bottom: 1,
                            right: 3,
                            child: CircleCameraButton(
                              onPressed: () {
                                _pickProfileImage(false);
                              },
                            )),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 35),
                Text("SocialPulse",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 60),

                ///username form field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    controller: _username,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == "") {
                        return "Username is required!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Username",
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.only(left: 35),
                    ),
                  ),
                ),

                ///email form field
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == "") {
                        return "Email is required!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.only(left: 35),
                    ),
                  ),
                ),

                ///password form field
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    controller: _password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == "") {
                        return "Password is required!";
                      }
                      return null;
                    },
                    obscureText: isObscure,
                    decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        suffixIcon: GestureDetector(
                            child: Icon(isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onTap: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            }),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.only(left: 35)),
                  ),
                ),

                ///login
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ///sign up here
                      if (_formKey.currentState!.validate()) {
                        signUp(ref);
                      }
                    },
                    child: Text("Signup"),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
