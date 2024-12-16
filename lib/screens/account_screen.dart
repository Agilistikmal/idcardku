import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/config.dart';
import 'package:idcardku/main.dart';
import 'package:idcardku/model/payment_model.dart';
import 'package:idcardku/model/response_model.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:idcardku/screens/home_screen.dart';
import 'package:idcardku/screens/payment_screen.dart';
import 'package:idcardku/service/user_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  String errorMessage = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context)?.state;

    Future<User> userFuture = findUser(appState!.user!.username);

    Future<void> upgrade(String username) async {
      setState(() {
        errorMessage = "";
        loading = true;
      });

      final rawResponse = await http.post(
        Uri.parse("${AppConfig.apiUrl}/payment"),
        body: jsonEncode(
          {"username": username},
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
      body: FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final user = snapshot.data;

            appState.user = user;

            usernameController.text = user!.username;
            fullNameController.text = user.fullName;
            phoneController.text = user.phone;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, ${user.fullName}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  user.verified == true
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: Text(
                              "Greenmark",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Text(
                                  "Standard User",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  upgrade(user.username);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.new_label_rounded,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      "Upgrade Greenmark",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  ],
                                ))
                          ],
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Change Your Info",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade200,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Username",
                              hintText: "Input Username",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter username";
                              }
                              if (value.length < 3) {
                                return "Minimum value is 3";
                              }
                              return null;
                            },
                            controller: usernameController,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade200,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Full Name",
                              hintText: "Input Full Name",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter full name";
                              }
                              if (value.length < 3) {
                                return "Minimum value is 3";
                              }
                              return null;
                            },
                            controller: fullNameController,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade200,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Phone",
                              hintText: "Input Phone number (+628xxx)",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter phone number";
                              }
                              if (!value.startsWith("+")) {
                                return "Phone number should start with '+'";
                              }
                              return null;
                            },
                            controller: phoneController,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Creating Post..."),
                                  ),
                                );

                                try {
                                  await updateUser(
                                      user.username,
                                      usernameController.text,
                                      fullNameController.text,
                                      phoneController.text);
                                } catch (err) {
                                  setState(() {
                                    errorMessage = err.toString();
                                  });
                                }

                                userFuture = findUser(usernameController.text);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Save",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Text("No user found.");
          }
        },
      ),
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
