import 'package:flutter/material.dart';

class BeSmartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('BeSmart',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
                Text(
                  'Time to Plan!',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Мой день',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text(
            'Задачи',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/task-list');
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text(
            'Проекты',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/project-list');
          },
        ),
        ListTile(
          leading: Icon(Icons.collections_bookmark),
          title: Text(
            'Категории',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/category-list');
          },
        ),
        ListTile(
          leading: Icon(Icons.line_weight),
          title: Text(
            'Заметки',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/note-list');
          },
        ),
        ListTile(
          leading: Icon(Icons.sentiment_satisfied),
          title: Text(
            'Привычки',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/habit-list');
          },
        ),
        ListTile(
          leading: Icon(Icons.sentiment_dissatisfied),
          title: Text(
            'Вредные привычки',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/bad-habit-list');
          },
        ),
        ListTile(
          leading: Icon(Icons.av_timer),
          title: Text(
            'Помодоро',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/pomodoro');
          },
        )
      ]),
    );
  }
}

/*
* Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'BeSmart',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Мой день'),
              onTap: () => setState(() {
                currentScreen = Dashboard();
                _scaffoldKey.currentState.openEndDrawer();
              }),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Задачи'),
              onTap: () => setState(() {
                currentScreen = TaskList();
                _scaffoldKey.currentState.openEndDrawer();
              }),
            ),
//            ListTile(
//              leading: Icon(Icons.view_list),
//              title: Text('Проекты'),
//              onTap: () => setState(() {
//                currentScreen = ProjectList();
//                _scaffoldKey.currentState.openEndDrawer();
//              }),
//            ),
//            ListTile(
//              leading: Icon(Icons.folder),
//              title: Text('Категории'),
//              onTap: () => setState(() {
//                currentScreen = Category();
//                _scaffoldKey.currentState.openEndDrawer();
//              }),
//            ),
//            ListTile(
//              leading: Icon(Icons.videogame_asset),
//              title: Text('Привычки'),
//              onTap: () => setState(() {
//                currentScreen = Habit();
//                _scaffoldKey.currentState.openEndDrawer();
//              }),
//            ),
          ],
        ),
      ),
* */
