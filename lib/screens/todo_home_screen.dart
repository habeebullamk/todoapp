import 'package:flutter/material.dart';
import 'package:todo_app/models/todomodel.dart';
import 'package:todo_app/service/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titlecon = TextEditingController();
  final TextEditingController desccon = TextEditingController();
  final TodoService _todoService = TodoService();

  List<Todo> todos = [];

  Future<void> loadTodos() async {
    todos = await _todoService.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: todos.isEmpty
              ? Center(
                  child: Text("No Tasks Added"),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (cnxt, number) {
                    final todo = todos[number];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text("${number + 1}"),
                        ),
                        onTap: () {
                          _showEditDialog(todo, number);
                        },
                        title: Text('${todo.title}'),
                        subtitle: Text('${todo.description}'),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              Checkbox(
                                value: todo.completed,
                                onChanged: (value) {
                                  setState(() {
                                    todo.completed = value!;
                                    _todoService.updateTodo(number, todo);
                                    setState(() {});
                                  });
                                },
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await _todoService.DeleteTodo(number);
                                    loadTodos();
                                  },
                                  icon: Icon(Icons.delete_outline))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _AddBox();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _AddBox() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add New Task'),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Title'),
                    controller: titlecon,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: desccon,
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(onPressed: () {}, child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    final newTodo = Todo(
                        title: titlecon.text,
                        description: desccon.text,
                        createdat: DateTime.now(),
                        completed: false);

                    await _todoService.AddTodo(newTodo);
                    titlecon.clear();
                    desccon.clear();

                    Navigator.pop(context);
                    loadTodos();
                  },
                  child: Text('Add'))
            ],
          );
        });
  }

  Future<void> _showEditDialog(Todo todo, int index) async {
    titlecon.text = todo.title;
    desccon.text = todo.description;
    {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: 'Title'),
                      controller: titlecon,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: desccon,
                      decoration: InputDecoration(hintText: 'Description'),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(onPressed: () {}, child: Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      todo.title = titlecon.text;
                      todo.description = desccon.text;
                      todo.createdat = DateTime.now();

                      if (todo.completed == true) {
                        todo.completed = false;
                      }
                      _todoService.updateTodo(index, todo);
                      titlecon.clear();
                      desccon.clear();

                      Navigator.pop(context);
                      loadTodos();
                    },
                    child: Text('Edit'))
              ],
            );
          });
    }
  }
}
