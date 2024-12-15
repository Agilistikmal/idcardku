import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';
import 'package:idcardku/main.dart';
import 'package:idcardku/model/payment_model.dart';
import 'package:idcardku/model/post_model.dart';
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/screens/home_screen.dart';
import 'package:idcardku/screens/payment_screen.dart';
import 'package:idcardku/service/post_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<List<Post>> postsFuture = findPosts();

  final _formKey = GlobalKey<FormState>();

  String errorMessage = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context)?.state;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: const Text("Account Dashboard"),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
        currentIndex: 2,
        onTap: (value) {
          if (value == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
          } else if (value == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AccountPage(),
            ));
          } else if (value == 2) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AccountPage(),
            ));
          }
        },
      ),
    );
  }
}
