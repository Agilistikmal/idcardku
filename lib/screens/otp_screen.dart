import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:idcardku/screens/home_screen.dart';

class OTPPage extends StatefulWidget {
  final User user;

  const OTPPage({super.key, required this.user});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final codeController = TextEditingController();

  String errorMessage = "";
  bool loading = false;

  Future<void> verify() async {
    setState(() {
      errorMessage = "";
      loading = true;
    });

    final rawResponse = await http.post(
      Uri.parse("https://mwsapi.safatanc.com/auth/otp"),
      body: jsonEncode(
        {"username": widget.user.username, "code": codeController.text},
      ),
    );

    final Map parseResponse = json.decode(rawResponse.body);

    final response = APIResponse.fromJson(parseResponse);

    if (response.code == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(user: widget.user),
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
        title: const Text(
          "Verify Account",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: Text(
                "Hi ${widget.user.fullName}, please check your WhatsApp (${widget.user.phone}) to get single use code.",
                textAlign: TextAlign.center,
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
                    hintText: "4 digit code",
                  ),
                  controller: codeController,
                  textAlign: TextAlign.center,
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
                  verify();
                },
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                child: Text(
                  loading == false ? "Verify" : "Loading...",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
