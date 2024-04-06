import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final c = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: c.userC,
              autocorrect: false,
              decoration: const InputDecoration(
                  labelText: "Username", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            Obx(() => TextField(
                  controller: c.passC,
                  obscureText: c.isAuth.value,
                  autocorrect: false,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => c.isAuth.toggle(),
                        icon: c.isAuth.isTrue
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.remove_red_eye_outlined),
                      ),
                      labelText: "Password",
                      border: const OutlineInputBorder()),
                )),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => c.register(
                c.userC.text,
                c.passC.text,
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
