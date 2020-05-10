import 'package:besmart/models/HabitModel.dart';
import 'package:besmart/services/HabitService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

// Класс - Виджет экран HabitList
class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

// Класс состояния класса HabitList
class _HabitListState extends State<HabitList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Полезные привычки'), automaticallyImplyLeading: false, ),
      drawer: BeSmartDrawer(),
      body: FutureBuilder<List<HabitModel>>(
        future: HabitService.db.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<HabitModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                HabitModel item = snapshot.data[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(item.name),
                        trailing: Text('до ${DateFormat('dd.MM.yyyy - hh:mm').format(DateTime.parse(item.lifetime))}'),
                      )
                  ),
                  actions: <Widget>[
                    IconSlideAction (
                      caption: 'Редактировать',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.pushNamed(context, '/habit/${item.id}');
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction (
                      caption: 'Удалить',
                      color: Colors.pink,
                      icon: Icons.delete,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog (
                              title: Text('Удалить привычку?'),
                              shape: RoundedRectangleBorder (
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              elevation: 20.0,
                              actions: <Widget>[
                                FlatButton (
                                  child: Text('ОТМЕНА'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton (
                                  child: Text('УДАЛИТЬ'),
                                  onPressed: () async {
                                    await HabitService.db.deleteById(item.id);
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            )
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BeSmartBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: () {
        Navigator.pushNamed(context, '/habit-create');
      },),
    );
  }
}





















//import 'dart:math' as math;
//
//
//import 'package:besmart/models/HabitModel.dart';
//import 'package:besmart/services/HabitService.dart';
//import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
//import 'package:flutter/material.dart';
//
//class HabitList extends StatefulWidget {
//  @override
//  _HabitListState createState() => _HabitListState();
//}
//
//class _HabitListState extends State<HabitList> {
//
//  List<HabitModel> testHabit = [
//    HabitModel(id: 1,name: "Habit 1", lifetime: DateTime.now().toIso8601String(), userId: 1, createdAt: DateTime.now().toIso8601String(), updatedAt: null, deletedAt: null),
//    HabitModel(id: 2, name: "Habit 2",lifetime: DateTime.now().toIso8601String()),
//  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Привычки'),
//      ),
//      drawer: BeSmartDrawer(),
//      body: FutureBuilder<List<HabitModel>>(
//        future: HabitService.db.getAll(),
//        builder: (BuildContext context, AsyncSnapshot<List<HabitModel>> snapshot) {
//          if (snapshot.hasData) {
//            return ListView.builder(
//              itemCount: snapshot.data.length,
//              itemBuilder: (BuildContext context, int index) {
//                HabitModel item = snapshot.data[index];
//                return Dismissible(
//                  key: UniqueKey(),
//                  background: Container(color: Colors.pink),
//                  onDismissed: (direction) {
//                    HabitService.db.deleteById(item.id);
//                  },
//                  child: ListTile(
//                      title: Text(item.name),
//                      subtitle: Text(item.lifetime),
//                      leading: CircleAvatar()
//                  ),
//                );
//              },
//            );
//          } else {
//            return Center(child: CircularProgressIndicator());
//          }
//        },
//      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () async {
//          HabitModel rnd = testHabit[math.Random().nextInt(testHabit.length)];
//          await HabitService.db.create(rnd);
//          setState(() {});
//        },
//        /*
//        onPressed: () {
//          Navigator.pushNamed(context, '/task-create');
//        },
//        */
//      ),
//    );
//  }
//}
