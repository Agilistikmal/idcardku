import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';
import 'package:idcardku/main.dart';
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/screens/otp_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorMessage = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context)?.state;

    final usernameController = TextEditingController();
    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> register() async {
      setState(() {
        errorMessage = "";
        loading = true;
      });

      final rawResponse = await http.post(
        Uri.parse("${AppConfig.apiUrl}/auth/register"),
        body: jsonEncode(
          {
            "username": usernameController.text,
            "password": passwordController.text,
            "full_name": fullNameController.text,
            "phone": phoneController.text
          },
        ),
      );

      final Map parseResponse = json.decode(rawResponse.body);
      final response = APIResponse.fromJson(parseResponse);

      if (response.code == 200) {
        appState?.username = usernameController.text;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const OTPPage(),
          ),
        );
      } else {
        setState(() {
          errorMessage = response.message;
        });
      }

      setState(() {
        loading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const Center(
            child: Image(
              image: AssetImage("assets/logo.png"),
              height: 100,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            "Register",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black12,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Username",
                  ),
                  controller: usernameController,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black12,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Full Name",
                  ),
                  controller: fullNameController,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black12,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Phone",
                  ),
                  controller: phoneController,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black12,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Password",
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: errorMessage != ""
                ? Text(
                    "Error: $errorMessage",
                    style: const TextStyle(color: Colors.pink),
                  )
                : const SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.green,
              ),
              width: MediaQuery.sizeOf(context).width,
              child: TextButton(
                onPressed: () {
                  register();
                },
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: Text(
                  loading == true ? "Loading..." : "Register",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                const SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Login here",
                    style: TextStyle(
                      color: Colors.pink,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
