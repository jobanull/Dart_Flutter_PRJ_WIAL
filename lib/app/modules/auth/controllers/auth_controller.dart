import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isAuth = false.obs;

  late TextEditingController userC;
  late TextEditingController passC;

  @override
  void onInit() async {
    super.onInit();
    userC = TextEditingController();
    passC = TextEditingController();

    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("userReg");
    final pass = prefs.getString("passReg");

    print(user);
    print(pass);

    final box = GetStorage();
    if (box.read("datauser") != null) {
      userC.text = user!;
      passC.text = pass!;
    }
  }

  @override
  void onClose() {
    super.onClose();
    userC.dispose();
    passC.dispose();
  }

  void dialogError(String msg) {
    Get.defaultDialog(title: "Terjadi Kesalahan", middleText: msg);
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    isAuth.value = isLoggedIn;
  }

  void login(String user, String pass) async {
    final prefs = await SharedPreferences.getInstance();

    final isUser = prefs.getString("userReg");
    final isPass = prefs.getString("passReg");

    if (!GetUtils.isUsername(isUser!)) {
      dialogError("User Tidak Valid");
      return;
    }

    if (user.isEmpty || pass.isEmpty) {
      dialogError("Semua data input haris diisi");
      return;
    }

    if (user != isUser || pass != isPass) {
      dialogError("Data User Tidak Valid, Gunakan akun lainnya");
      return;
    }

    // Login Success

    prefs.setBool('isLoggedIn', true);
    isAuth.value = true;
  }

  void register(String user, String pass) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("userReg", user);
    await prefs.setString("passReg", pass);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    isAuth.value = false;
  }
}
