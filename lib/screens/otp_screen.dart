import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/model/response_model.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";

  Future<void> login() async {
    setState(() {
      errorMessage = "";
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
      // IMPLEMENT
    } else {
      setState(() {
        errorMessage = response.message;
      });
    }
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
          const Text(
            "Verify Account",
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
                    hintText: "4 digit code",
                  ),
                  controller: usernameController,
                ),
              ),
            ),
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
                child: const Text(
                  "OTP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
