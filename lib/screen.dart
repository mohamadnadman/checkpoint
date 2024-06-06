import 'package:checkpoint/src/features/Data/database_repository.dart';
import 'package:checkpoint/todo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key, required DatabaseRepository databaseRepository});
  @override
  // ignore: library_private_types_in_public_api
  _TodoScreenState createState() => _TodoScreenState();
}
class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences _prefs;
  late List<Todo> _todos;
  String _lastTodo = '';
  @override
  void initState() {
    super.initState();
    _loadTodos();
  }
  void _loadTodos() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _todos = (_prefs.getStringList('todos') ?? []).map((item) {
        return Todo.fromJson(json.decode(item));
      }).toList();
      _lastTodo = _prefs.getString('lastTodo') ?? '';
    });
  }
  void _saveTodos() {
    _prefs.setStringList('todos', _todos.map((item) {
      return json.encode(item.toJson());
    }).toList());
    _prefs.setString('lastTodo', _lastTodo);
  }
  void _addTodo() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _lastTodo = _controller.text;
        _todos.add(Todo(
          title: _controller.text,
        ));
        _controller.clear();
        _saveTodos();
      }
    });
  }
  void _removeTodoAt(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTodos();
    });
  }
  void _showLastTodo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Letzter eingegebener Name: $_lastTodo')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Add New ToDo'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _addTodo,
              child: const Text('Add'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showLastTodo,
              child: const Text('Show Last ToDo'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeTodoAt(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}