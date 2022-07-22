import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieverse/providers/authprovider.dart';
import 'package:movieverse/screens/auth_screen.dart';
import 'package:movieverse/screens/home_screen.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      final userStream = ref.watch(authScreen);
      return userStream.when(
        data: (data) {
          if (data == null) {
            return AuthScreen();
          } else {
            return HomeScreen();
          }
        },
        error: ((error, stackTrace) => Scaffold(
              body: Center(
                child: Text('$error'),
              ),
            )),
        loading: () => Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }));
  }
}
