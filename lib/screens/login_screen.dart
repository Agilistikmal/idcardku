import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';
import 'package:idcardku/main.dart';
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/screens/otp_screen.dart';
import 'package:idcardku/screens/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context)?.state;

    Future<void> login() async {
      setState(() {
        errorMessage = "";
        loading = true;
      });

      try {
        final rawResponse = await http
            .post(
              Uri.parse("${AppConfig.apiUrl}/auth/login"),
              body: jsonEncode(
                {
                  "username": usernameController.text,
                  "password": passwordController.text
                },
              ),
            )
            .timeout(
              const Duration(seconds: 10),
            );

        final Map parseResponse = json.decode(rawResponse.body);
        final response = APIResponse.fromJson(parseResponse);

        if (response.code == 200) {
          appState?.username = usernameController.text;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OTPPage(),
            ),
          );
        } else {
          setState(() {
            errorMessage = response.message;
            loading = false;
          });
        }
      } on TimeoutException {
        setState(() {
          errorMessage = "Login timeout, please try again.";
          loading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = "Failed to login, please try again";
          loading = false;
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
        title: const Center(
            child: Text(
          "Welcome",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
            Text(
              loading == true ? "Loading..." : "Login",
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
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Username",
                    ),
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username";
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Password",
                    ),
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
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
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
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
                      Navigator.pushReplacement(
                        context,
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
      ),
    );
  }
}
