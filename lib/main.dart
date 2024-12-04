import 'package:flutter/material.dart';
import 'package:idcardku/model/user_model.dart';
import 'package:idcardku/screens/login_screen.dart';

void main() {
  final state = AppState(username: null, user: null);
  runApp(AppStateProvider(state: state, child: const MyApp()));
}

class AppState {
  String? username;
  User? user;

  AppState({this.username, this.user});
}

class AppStateProvider extends InheritedWidget {
  final AppState state;

  AppStateProvider({
    required this.state,
    required Widget child,
  }) : super(child: child);

  static AppStateProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDCardku',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
