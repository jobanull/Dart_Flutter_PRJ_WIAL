import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    if (email.isNotEmpty && password.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<void> registerUser(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    if (email.isNotEmpty && password.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    isLoggedIn.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (email != null &&
        password != null &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }
}
