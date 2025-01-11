import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_traffic_control_app/models/user.dart' as local_user;
import 'package:smart_traffic_control_app/pages/home_page.dart';
import 'package:smart_traffic_control_app/pages/login_page.dart';
import 'package:smart_traffic_control_app/services/hive_service.dart';

import '../constants/style_constants.dart';

String snackText = '';

enum AuthResponse { success, invalidCredentials, badRequest, randomError }

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<AuthResponse> login(
      String email, String password, var context) async {
    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => const Center(
              child: CircularProgressIndicator(color: placeholderTextColor)));

      var user = local_user.User(
          id: credential.user!.uid,
          email: credential.user!.email!,
          name: '',
          phoneNumber: '',
          country: '',
          countyOrState: '',
          city: '');

      if (credential.user != null && credential.user?.email != null) {
        saveUserData(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackText = 'No user found for that email!';
        if (kDebugMode) {
          print('No user found for that email!');
        }
        return AuthResponse.badRequest;
      } else if (e.code == 'invalid-email') {
        snackText = 'Invalid email!';
        if (kDebugMode) {
          print('Invalid email!');
        }
        return AuthResponse.invalidCredentials;
      } else if (e.code == 'wrong-password') {
        snackText = 'Wrong password provided for that user!';
        if (kDebugMode) {
          print('Wrong password provided for that user!');
        }
        return AuthResponse.invalidCredentials;
      } else if (e.code == 'invalid-credential') {
        snackText = 'Invalid credentials!';
        Navigator.pop(context);
        if (kDebugMode) {
          print('Invalid credentials!');
        }
        return AuthResponse.badRequest;
      } else {
        if (kDebugMode) {
          print(e.code);
          snackText = e.code;
          return AuthResponse.badRequest;
        }
      }
    }
    snackText = 'Logged in!';
    if (kDebugMode) {
      print('Logged in!');
    }
    return AuthResponse.success;
  }

  static Future<AuthResponse> register(String email, String password,
      String confirmPassword, var context) async {
    if (password != confirmPassword) {
      snackText = 'Passwords do not match!';
      if (kDebugMode) {
        print('Passwords do not match!');
      }
      return Future.value(AuthResponse.badRequest);
    }

    try {
      var credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = local_user.User(
          id: credential.user!.uid,
          email: credential.user!.email!,
          name: '',
          phoneNumber: '',
          country: '',
          countyOrState: '',
          city: '');
      if (user.id == '') {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
                child: CircularProgressIndicator(color: placeholderTextColor)));
      }
      if (credential.user != null && credential.user?.email != null) {
        saveUserData(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackText = 'Password is to weak.';
        if (kDebugMode) {
          print('Password is to weak.');
        }
        return Future.value(AuthResponse.badRequest);
      } else if (e.code == 'email-already-in-use') {
        snackText = 'The account already exists for that email.';
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        return Future.value(AuthResponse.badRequest);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    snackText = 'Registered successfully!';
    if (kDebugMode) {
      print('Registered successfully!');
    }
    return Future.value(AuthResponse.success);
  }

  static void saveUserData(local_user.User user) async {
    HiveService().upsertUserInBox(user);
  }

  static Future<void> signOutUser(var context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
            child: CircularProgressIndicator(color: placeholderTextColor)));
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> changePassword(
      String email, String password, String newPassword, var context) async {
    final user = _auth.currentUser!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
            child: CircularProgressIndicator(color: placeholderTextColor)));
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        snackText = 'Wrong password provided for that user.';
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        return;
      }
    }
    if (password == newPassword) {
      snackText = 'The new password has to be different from the old password!';
      if (kDebugMode) {
        print('The new password has to be different from the old password!');
      }
    } else {
      user.updatePassword(newPassword).then((_) {
        if (kDebugMode) {
          print("Successfully changed password");
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("Password can't be changed$error");
        }
      });
      snackText = 'Password changed successfully!';
      if (kDebugMode) {
        print('Password changed successfully!');
      }
    }
  }

  static Future<void> deleteAccount(var context) async {
    final user = _auth.currentUser!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
            child: CircularProgressIndicator(color: placeholderTextColor)));
    try {
      user.delete();
      signOutUser(context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    snackText = 'Account successfully deleted!';
    if (kDebugMode) {
      print('Account successfully deleted!');
    }
  }

  static Widget initialRouting(WidgetRef ref) {
    var user = HiveService().getUser();
    if (user == null) {
      return LoginPage();
    } else {
      return const HomePage();
      //}
    }
  }
}
