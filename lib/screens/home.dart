import 'dart:convert';

import 'package:basic_app/screens/create.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  List items=[];
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title:const Text("Todos List"),
         centerTitle: true,
      ),
        body:Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodos,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                final item=items[index] as Map;
                final id=item['_id'] as String;
                return ListTile(
                  leading:CircleAvatar(child: Text('${index+1}'),),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (val){
                      if(val=='edit'){
                        navigateToEditTodoPage(item);
                      }
                      if(val=='delete'){
                        deleteTodo(id);
                      }
                    },
                    itemBuilder: (context){
                      return const [
                        PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit')
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete')
                      )
                      ];
                    },
                  ),
                );
              },
            ),
          ),
          child : const Center(child: CircularProgressIndicator()),

        ),
      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddTodoPage, label: const Text('+ Add Todo')),
    );
  }


  navigateToEditTodoPage(Map item){
    final route=MaterialPageRoute(builder: (context)=> AddTodo(todo: item));
    Navigator.push(context, route);
  }

  navigateToAddTodoPage(){
    final route=MaterialPageRoute(builder: (context)=>const AddTodo());
     Navigator.push(context, route);
  }


  Future<void> deleteTodo(String id)async{
    final url='https://api.nstack.in/v1/todos/$id';
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode == 200) {
      successAlert('Successfully deleted todo');
      fetchTodos();
    }
    else {
      errorAlert('Error occurred while deleting todo');
    }
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

  Future<void> fetchTodos()async {
    final uri = Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
     final json=jsonDecode(res.body) as Map;
     setState(() {
       items=json['items'] as List;
       isLoading=false;
     });

    }
    else {
      setState(() {
        isLoading=false;
      });
     //show error
    }
  }
}


