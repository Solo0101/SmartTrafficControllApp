import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:smart_traffic_control_app/models/user.dart';
// import 'package:frontend/services/api_service.dart';

class HiveService {
  late final Box<User> userBox;
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  Future<void> initHive() async {
    Hive.registerAdapter(UserAdapter());
    userBox = await Hive.openBox('user');
  }

  User? getUser() {
    User? currentUser = userBox.get('user');
    return currentUser?.getValue();
  }

  Future upsertUserInBox(User newUser) async {
    return await _instance.userBox.put('user', newUser.getValue());
  }

  Future clearBoxes() async {
    userBox.clear();
  }

  Future<void> logoutUser() async {
    await clearBoxes();
    // Perform any additional cleanup if needed
    // For example, you might want to reset any in-memory user data or state
  }
}
