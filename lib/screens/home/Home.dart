import 'package:besmart/models/CategoryModel.dart';
import 'package:besmart/models/NoteModel.dart';
import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/models/TaskModel.dart';
import 'package:besmart/services/CategoryService.dart';
import 'package:besmart/services/NoteService.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:besmart/services/TaskService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var deadlineDate = DateFormat('yyyy-MM-ddT00:00:00.000').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BeSmart'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column (
          children: <Widget>[
            Card(
              color: Colors.indigo,
              child: FutureBuilder(
                future: TaskService.db.getTasksByDeadlineDate(deadlineDate),
                builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      leading: Icon(Icons.assignment, color: Colors.white,),
                      title: Text('Мои задачи', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
                      subtitle: Text('Активно: ${snapshot.data.length}', style: TextStyle(color: Colors.white),),
                      onTap: () {Navigator.pushNamed(context, '/task-list');},
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
            ),
            Card(
              color: Colors.deepPurple[500],
              child: FutureBuilder(
                  future: ProjectService.db.getAll(),
                  builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        leading: Icon(Icons.book, color: Colors.white,),
                        title: Text('Проекты', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                        subtitle: Text('Всего : ${snapshot.data.length}', style: TextStyle(color: Colors.white) ),
                        onTap: () {Navigator.pushNamed(context, '/project-list');},
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ),
            Card(
              color: Colors.purple[400],
              child: FutureBuilder(
                  future: CategoryService.db.getAll(),
                  builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        leading: Icon(Icons.collections_bookmark, color: Colors.white,),
                        title: Text('Категории', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                        subtitle: Text('Всего : ${snapshot.data.length}', style: TextStyle(color: Colors.white) ),
                        onTap: () {Navigator.pushNamed(context, '/category-list');},
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ),
            Card(
              color: Colors.blue,
              child: FutureBuilder(
                  future: NoteService.db.getAll(),
                  builder: (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        leading: Icon(Icons.line_weight, color: Colors.white,),
                        title: Text('Заметки', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                        subtitle: Text('Всего : ${snapshot.data.length}', style: TextStyle(color: Colors.white) ),
                        onTap: () {Navigator.pushNamed(context, '/note-list');},
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ),
//            Card(
//              color: Colors.indigoAccent,
//              child: FutureBuilder(
//                  future: HabitService.db.getAll(),
//                  builder: (BuildContext context, AsyncSnapshot<List<HabitModel>> snapshot) {
//                    if (snapshot.hasData) {
//                      return ListTile(
//                        leading: Icon(Icons.sentiment_satisfied, color: Colors.white,),
//                        title: Text('Полезные привычки', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
//                        subtitle: Text('Всего : ${snapshot.data.length}', style: TextStyle(color: Colors.white) ),
//                        onTap: () {Navigator.pushNamed(context, '/habit-list');},
//                      );
//                    } else {
//                      return Center(child: CircularProgressIndicator());
//                    }
//                  }
//              ),
//            ),
//            Card(
//              color: Colors.indigoAccent,
//              child: FutureBuilder(
//                  future: BadHabitService.db.getAll(),
//                  builder: (BuildContext context, AsyncSnapshot<List<BadHabitModel>> snapshot) {
//                    if (snapshot.hasData) {
//                      return ListTile(
//                        leading: Icon(Icons.sentiment_dissatisfied, color: Colors.white,),
//                        title: Text('Вредные привычки', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
//                        subtitle: Text('Всего : ${snapshot.data.length}', style: TextStyle(color: Colors.white) ),
//                        onTap: () {Navigator.pushNamed(context, '/bad-habit-list');},
//                      );
//                    } else {
//                      return Center(child: CircularProgressIndicator());
//                    }
//                  }
//              ),
//            ),
//            Card(
//              color: Colors.teal,
//              child: ListTile(
//                leading: Icon(Icons.av_timer, color: Colors.white,),
//                title: Text('Помодоро', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
//                onTap: () {Navigator.pushNamed(context, '/pomodoro');},
//              ),
//            ),
          ],
        ),
      ),
      drawer: BeSmartDrawer(),
      bottomNavigationBar: BeSmartBottomAppBar(),
    );
  }
}