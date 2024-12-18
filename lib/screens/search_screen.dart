import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idcardku/main.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:idcardku/screens/account_screen.dart';
import 'package:idcardku/screens/home_screen.dart';
import 'package:idcardku/service/post_service.dart';
import 'package:idcardku/service/user_service.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<User>> usersFuture = findUsers();

  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  String errorMessage = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context)?.state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          "Search",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText:
                                    "Search by username, full name, or phone number",
                                labelText: "Search",
                                contentPadding: EdgeInsets.all(0),
                              ),
                              controller: searchController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter post title";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FutureBuilder(
                  future: usersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final users = snapshot.data!;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      user.username,
                                    ),
                                    Text(
                                      user.phone,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(user.createdAt != user.updatedAt
                                        ? "Updated"
                                        : "Created"),
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat(
                                            DateFormat.YEAR_MONTH_DAY,
                                          ).format(
                                            DateTime.parse(user.createdAt),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          DateFormat(
                                            DateFormat.HOUR24_MINUTE_SECOND,
                                          ).format(
                                            DateTime.parse(user.createdAt),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text("No user found.");
                    }
                  },
                ),
              ),
            )
          ],
        ),
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
        currentIndex: 1,
        onTap: (value) {
          if (value == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
          } else if (value == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SearchPage(),
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
