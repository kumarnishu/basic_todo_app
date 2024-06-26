import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key,this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool isEdit=false;

  @override
  void initState(){
    super.initState();

    final todo=widget.todo;
    if(todo!=null)
      {
        isEdit=true;
        title.text=todo['title'];
        description.text=todo['description'];
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEdit?'Edit Todo':'Add Todo'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: 'Title'),
              minLines: 2,
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: description,
              decoration: const InputDecoration(hintText: 'Description'),
              minLines: 5,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: submit, child:Text(isEdit?'Edit Edit':'Submit'),)
          ],
        )
    );
  }

  successAlert(String message) {
    final snack =SnackBar(content: Text(
        message));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  errorAlert(String message) {
    final snack = SnackBar(content: Text(
        message, style: const TextStyle(color: Colors.red)));
    ScaffoldMessenger.of(context).showSnackBar(snack);
}


  Future<void> submit()async {
    final titleValue = title.text;
    final descValue = description.text;
    final todo=widget.todo;
    final body = {
      "title": titleValue,
      "description": descValue,
      "is_completed": false
    };
    if(isEdit && todo!=null){
      final uri = Uri.parse('https://api.nstack.in/v1/todos/${todo['_id']}');
      final res = await http.put(uri, body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        successAlert('Successfully updated todo');
      }
      else {
        errorAlert('Error occurred while updating todo');
      }
    }
    else{
      final uri = Uri.parse('https://api.nstack.in/v1/todos');
      final res = await http.post(uri, body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 201) {
        successAlert('Successfully created todo');
        title.text="";
        description.text="";
      }
      else {
        errorAlert('Error occurred while creating todo');
      }
    }

  }
}

