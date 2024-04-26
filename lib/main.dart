import 'package:flutter/material.dart';
import 'list.dart';
import 'modifyform.dart';
import 'read.dart';
import 'writeform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      initialRoute: "/list",
      routes: { // map
        '/read': (context) => ReadPage(), // 기본 홈 페이지
        '/list': (context) => ListPage(),
        '/write': (context) => WriteForm(),
        '/modify': (context) => ModifyForm(),

      },












    );
  }
}

