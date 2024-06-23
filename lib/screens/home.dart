import 'package:basic_app/screens/create.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title:const Text("My Todos")
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddTodoPage, label: const Text('+ Add Todo')),
    );
  }

  navigateToAddTodoPage(){
    final route=MaterialPageRoute(builder: (context)=>const AddTodo());
    Navigator.push(context, route);
  }
}


