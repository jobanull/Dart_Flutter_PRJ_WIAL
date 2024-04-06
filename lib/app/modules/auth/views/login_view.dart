import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'register_view.dart';

class AuthView extends StatelessWidget {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: authC.userC,
              autocorrect: false,
              decoration: const InputDecoration(
                  labelText: "Username", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            Obx(() => TextField(
                  controller: authC.passC,
                  obscureText: authC.isAuth.value,
                  autocorrect: false,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => authC.isAuth.toggle(),
                        icon: authC.isAuth.isTrue
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.remove_red_eye_outlined),
                      ),
                      labelText: "Password",
                      border: const OutlineInputBorder()),
                )),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => authC.login(
                authC.userC.text,
                authC.passC.text,
              ),
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(RegisterView());
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
