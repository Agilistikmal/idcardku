import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';
import 'package:idcardku/main.dart';
import 'package:idcardku/model/payment_model.dart';
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:idcardku/screens/payment_screen.dart';
import 'package:idcardku/service/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context)?.state;

    String errorMessage = "";
    bool loading = false;

    Future<void> upgrade() async {
      setState(() {
        errorMessage = "";
        loading = true;
      });

      final rawResponse = await http.post(
        Uri.parse("${AppConfig.apiUrl}/payment"),
        body: jsonEncode(
          {"username": appState!.username!},
        ),
      );

      final Map parseResponse = json.decode(rawResponse.body);

      final response = APIResponse.fromJson(parseResponse);

      if (response.code == 200) {
        final payment = Payment.fromJson(response.data);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                PaymentPage(user: appState.user!, payment: payment),
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

    Future<void> refresh() async {
      setState(() {
        errorMessage = "";
        loading = true;
      });

      User user = await findUser(appState!.username!);
      appState.user = user;

      setState(() {
        loading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              appState!.user!.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(appState.user!.phone),
            const SizedBox(
              height: 8,
            ),
            appState.user!.verified == true
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        "Verified Badge",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Text(
                            "Non Verified Badge",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Text("You can upgrade this account for Rp1.000"),
                    ],
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
            appState.user!.verified != true
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.green,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                        onPressed: () {
                          upgrade();
                        },
                        style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        child: Text(
                          loading == false
                              ? "Upgrade to get Verified Badge"
                              : "Loading...",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.green.shade50,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: TextButton(
                        onPressed: () {
                          refresh();
                        },
                        style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.green),
                        ),
                        child: Text(
                          loading == false ? "Refresh Data" : "Loading...",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24 * 2,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
