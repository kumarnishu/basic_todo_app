import 'package:flutter/material.dart';
import 'package:basic_app/screens/home.dart';

void main()=>runApp(const app());

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const HomePage()
    );
  }
}
