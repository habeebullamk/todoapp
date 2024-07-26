


import 'package:hive/hive.dart';

import '../models/todomodel.dart';

class TodoService{

  Box<Todo>?_todoBox;


  Future<void>openBox()async{
    _todoBox=await Hive.openBox<Todo>('todos');
  }


  Future<void> closeBox()async{
    await _todoBox!.close();
  }

  Future<void>AddTodo(Todo todo)async{
    if(_todoBox==null){
      await openBox();
      
    }
      
      print(todo);
    await _todoBox!.add(todo);

  }

  Future<List<Todo>>getTodos() async{

    if(_todoBox==null){
      await openBox();
    }
    return _todoBox!.values.toList();
  }
Future<void>updateTodo(int index, Todo todo)async{
  if(_todoBox==null){
    await openBox();
  }
  await _todoBox!.putAt(index, todo);
}

Future<void> DeleteTodo(int index)async
{
    if(_todoBox==null){
      await openBox();
    }
    await _todoBox!.deleteAt(index);
  

}

}