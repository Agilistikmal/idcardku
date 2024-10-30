import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:idcardku/screens/otp_screen.dart';
import 'package:idcardku/screens/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";
  bool loading = false;

  Future<void> login() async {
    setState(() {
      errorMessage = "";
      loading = true;
    });

    final rawResponse = await http.post(
      Uri.parse("https://mwsapi.safatanc.com/auth/login"),
      body: jsonEncode(
        {
          "username": usernameController.text,
          "password": passwordController.text
        },
      ),
    );

    final Map parseResponse = json.decode(rawResponse.body);
    final response = APIResponse.fromJson(parseResponse);

    if (response.code == 200) {
      final user = User.fromJson(response.data);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPPage(
            user: user,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Center(
            child: Text(
          "Welcome",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
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
            "Login",
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
                    hintText: "Password",
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.pink,
                    decoration: TextDecoration.underline,
                  ),
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
                  login();
                },
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: Text(
                  loading == false ? "Login" : "Loading...",
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
                const Text("Dont have an account yet?"),
                const SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Register here",
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
