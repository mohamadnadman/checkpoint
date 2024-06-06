import 'package:checkpoint/screen.dart';
import 'package:checkpoint/src/features/Data/database_repository.dart';
import 'package:checkpoint/src/features/Data/mock_database.dart';
import 'package:flutter/material.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository = MockDatabase();
    return MaterialApp(
      home: TodoScreen(
        databaseRepository: databaseRepository,
      ),
    );
  }
}