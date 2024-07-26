import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/models/todomodel.dart';
import 'package:todo_app/screens/todo_home_screen.dart';
import 'package:todo_app/service/todo_service.dart';

void main()async{


  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await TodoService().openBox();
  runApp(const myapp());

  
}
class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:TodoScreen() ,
      theme:ThemeData(primarySwatch: Colors.yellow),
    );
  }
}