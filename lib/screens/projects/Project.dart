import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/models/TaskModel.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:besmart/services/TaskService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';

// Класс - Виджет экран Project
class Project extends StatefulWidget {

  final String _id;
  Project({String id}) : _id = id;

  @override
  _ProjectState createState() => _ProjectState();
}

// Класс состояния класса Project
class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Проект'),),
      body: FutureBuilder<List<ProjectModel>>(
          future: ProjectService.db.getById(int.parse(widget._id)),
          builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
            if (snapshot.hasData) {
              return Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding (
                    padding: EdgeInsets.all(16),
                    child: Text(snapshot.data[0].name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,)),
                  ),
                  snapshot.data[0].description != '' ?
                  Padding (
                    padding: EdgeInsets.only( left: 16, right: 16, bottom: 16),
                    child: Text(snapshot.data[0].description, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.blueGrey)),
                  ) :
                  Padding (padding: EdgeInsets.all(0),),
                  Padding (
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text('Дедлайн : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot.data[0].deadlineAt))} в ${DateFormat('hh:mm').format(DateTime.parse(snapshot.data[0].deadlineAt))}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,)),
                  ),
                  Padding (
                    padding: EdgeInsets.all(16),
                    child: Text('Список задач : ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,)),
                  ),
                  Expanded (
                    child: FutureBuilder<List<TaskModel>>(
                        future: TaskService.db.getTasksByProjectId(int.parse(widget._id)),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TaskModel>> taskSnapshot) {
                          if (taskSnapshot.hasData) {
                            return ListView.builder(
                                itemCount: taskSnapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  TaskModel item = taskSnapshot.data[index];
                                  return Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    child: Container (
                                      color: Colors.white,
                                      child: ListTile (
                                        title: Text(item.name, style: TextStyle( color: item.completedAt == "" ? Colors.black : Colors.grey)),
                                        leading: Checkbox (
                                          onChanged: (bool value) {
                                            setState(() {
                                              TaskService.db.checkOrUncheck(item);
                                            });
                                          },
                                          value: item.completedAt == '' ? false : true,
                                        ),
                                        trailing: item.isPrimary
                                            ? Text('⭐     до ' + DateFormat('dd.MM.yyyy').format(DateTime.parse(item.deadlineDate)) + ' - ' + item.deadlineTime, style: TextStyle(color: item.completedAt == "" ? Colors.black : Colors.grey))
                                            : Text('до ' + DateFormat('dd.MM.yyyy').format(DateTime.parse(item.deadlineDate)) + ' - ' + item.deadlineTime, style: TextStyle(color: item.completedAt == "" ? Colors.black : Colors.grey)),
                                        onTap: () {
                                          Navigator.pushNamed(context, '/task/${item.id}');
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                      IconSlideAction (
                                        caption: 'Редактировать',
                                        color: Colors.blue,
                                        icon: Icons.edit,
                                        onTap: () {
                                          Navigator.pushNamed(context, '/task/${item.id}');
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
                                                title: Text('Удалить задачу?'),
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
                                                      await TaskService.db.deleteById(item.id);
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
                                }
                            );
                          } else return Center(child: CircularProgressIndicator());
                        }
                    ),
                  )
                ],
              );
            } else return Center(child: CircularProgressIndicator());
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()  {Navigator.pushNamed(context, '/task-create');},
      ),
    );
  }
}



