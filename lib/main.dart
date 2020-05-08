import 'package:besmart/screens/badHabit/BadHabit.dart';
import 'package:besmart/screens/badHabit/BadHabitList.dart';
import 'package:besmart/screens/category/Category.dart';
import 'package:besmart/screens/category/CategoryList.dart';
import 'package:besmart/screens/habit/Habit.dart';
import 'package:besmart/screens/habit/HabitCreate.dart';
import 'package:besmart/screens/habit/HabitList.dart';
import 'package:besmart/screens/home/Home.dart';
import 'package:besmart/screens/notes/NoteList.dart';
import 'package:besmart/screens/pomodoro/Pomodoro.dart';
import 'package:besmart/screens/projects/Project.dart';
import 'package:besmart/screens/projects/ProjectCreate.dart';
import 'package:besmart/screens/projects/ProjectList.dart';
import 'package:besmart/screens/projects/ProjectUpdate.dart';
import 'package:besmart/screens/tasks/Task.dart';
import 'package:besmart/screens/tasks/TaskCreate.dart';
import 'package:besmart/screens/tasks/TaskList.dart';
import 'package:besmart/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  runApp(new BeSmart());
}

class BeSmart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/task-list': (context) => TaskList(),
        '/task-create': (context) => TaskCreate(),
        '/project-list': (context) => ProjectList(),
        '/project-create': (context) => ProjectCreate(),
        '/category-list': (context) => CategoryList(),
        '/habit-list': (context) => HabitList(),
        '/habit-create': (context) => HabitCreate(),
        '/bad-habit-list': (context) => BadHabitList(),
        '/pomodoro': (context) => Pomodoro(),
        '/note-list': (context) => NoteList(),
      },
      // ignore: missing_return
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.split('/');
        switch (path[1]) {
          case 'task' :
            return new MaterialPageRoute(builder: (context) => new Task(id: path[2]), settings: routeSettings);
          case 'project' :
            return new MaterialPageRoute(builder: (context) => new Project(id: path[2]), settings: routeSettings);
          case 'project-update' :
            return new MaterialPageRoute(builder: (context) => new ProjectUpdate(id: path[2]), settings: routeSettings);
          case 'category' :
            return new MaterialPageRoute(builder: (context) => new Category(id: path[2]), settings: routeSettings);
          case 'habit' :
            return new MaterialPageRoute(builder: (context) => new Habit(id: path[2]), settings: routeSettings);
          case 'bad-habit' :
            return new MaterialPageRoute(builder: (context) => new BadHabit(id: path[2]), settings: routeSettings);
        }
      },

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}