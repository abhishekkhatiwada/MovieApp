import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movieverse/providers/authprovider.dart';
import 'package:movieverse/providers/image_provider.dart';
import 'package:movieverse/providers/login_provider.dart';

class AuthScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Consumer(builder: (context, ref, child) {
        final isLogin = ref.watch(loginProvider);
        final image = ref.watch(imageProvider).image;
        final isLoad = ref.watch(loadingProvider);
        return Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              children: [
                Text(isLogin ? 'Login Form' : 'SignUp Form'),
                SizedBox(height: 70),
                if (isLogin == false)
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      // fillColor: Colors.white,
                      hintText: 'username',
                      //hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'PLEASE ENTER USERNAME';
                      } else if (value.length > 10) {
                        return 'Maximum 10 characters only';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: mailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'PLEASE ENTER VALID EMAIL ADDRESS';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PLEASE ENTER PASSWORD';
                    }
                    return null;
                  },
                ),
                if (isLogin) SizedBox(height: 30),
                if (isLogin == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: InkWell(
                      onTap: () {
                        ref.read(imageProvider).imagePicker();
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: image == null
                            ? Center(child: Text('Select an image'))
                            : Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                Container(
                  height: 38,
                  child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        _form.currentState!.save();
                        if (_form.currentState!.validate()) {
                          if (isLogin) {
                            ref.read(loadingProvider.notifier).toggle();
                            final response =
                                await ref.read(authProvider).userSignIn(
                                      email: mailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                            if (response != 'success') {
                              ref.read(loadingProvider.notifier).toggle();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      content: Text(response)));
                            }
                          } else {
                            if (image == null) {
                              Get.defaultDialog(
                                  content: Text('Image Required'),
                                  title: 'Please select an image',
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close')),
                                  ]);
                            } else {
                              ref.read(loadingProvider.notifier).toggle();
                              final response = await ref
                                  .read(authProvider)
                                  .userSignUp(
                                      username: nameController.text.trim(),
                                      email: mailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      file: image);
                              if (response != 'success') {
                                ref.read(loadingProvider.notifier).toggle();
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration: Duration(milliseconds: 1500),
                                        content: Text(response)));
                              }
                            }
                          }
                        }
                      },
                      child: isLoad
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Loading....'),
                                SizedBox(width: 15),
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : Text('Submit')),
                ),
                Row(
                  children: [
                    Text(isLogin
                        ? 'Don\'t have an account'
                        : 'Already have an account'),
                    TextButton(
                        onPressed: () {
                          ref.read(loginProvider.notifier).toggle();
                        },
                        child: Text(isLogin ? 'SignUp' : 'LogIn')),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
