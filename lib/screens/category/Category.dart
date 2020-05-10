import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/models/TaskModel.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:besmart/services/TaskService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Класс - Виджет экран Category
class Category extends StatefulWidget {
  final String _id;

  Category({String id}) : _id = id;

  @override
  _CategoryState createState() => _CategoryState();
}

// Класс состояния класса Category
class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    final width = ( MediaQuery.of(context).size.width).floorToDouble();
    return DefaultTabController(
        length: 2,
        child: Scaffold (
          appBar: AppBar(
            title: Text('Категория'),
            bottom: TabBar (
              tabs: <Widget>[
                Tab (
                  text: 'Проекты',
                ),
                Tab (
                  text: 'Задачи',
                )
              ],
            ),
          ),
          body: TabBarView (
            children: <Widget>[
              FutureBuilder<List<ProjectModel>>(
                future: ProjectService.db.getProjectsByCategoryId(int.parse(widget._id)),
                builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        ProjectModel item = snapshot.data[index];
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25, //хз что за параметр
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(item.name),
                                  subtitle: Text('Дедлайн : ${DateFormat('dd.MM.yyyy в hh:mm').format(DateTime.parse(item.deadlineAt))}'),
                                  leading: CircleAvatar(child:Icon(Icons.accessible_forward), ),
                                  onTap: (){Navigator.pushNamed(context, '/project/${item.id}');},
                                  //onTap: (){Navigator.pushNamed(context, '/project-view');},
                                ),
                                new FutureBuilder(
                                    future: TaskService.db.getCompletedTasksPercentByProjectId(item.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return LinearPercentIndicator(
                                          width: width,
                                          lineHeight: 5.0,
                                          percent: snapshot.data,
                                          progressColor: Colors.indigo,
                                        );
                                      }
                                      else {
                                        return LinearPercentIndicator(
                                          width: width,
                                          lineHeight: 5.0,
                                          percent: 0.0,
                                        );
                                      }
                                    }
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            IconSlideAction (
                              caption: 'Редактировать',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () {
                                Navigator.pushNamed(context, '/project-update/${item.id}');
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
                                      title: Text('Удалить проект?'),
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
                                            await ProjectService.db.deleteById(item.id);
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
              FutureBuilder<List<TaskModel>>(
                future: TaskService.db.getTasksByCategoryId(int.parse(widget._id)),
                builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> taskSnapshot) {
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
                                subtitle: item.projectId != null ? FutureBuilder (
                                    future: ProjectService.db.getById(item.projectId),
                                    builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> projectSnapshot) {
                                      if (projectSnapshot.hasData) {
                                        return Text(projectSnapshot.data[0].name, style: TextStyle( color: item.completedAt == "" ? Colors.indigo : Colors.grey));
                                      } else {
                                        return Text('Загрузка ...');
                                      }
                                    }
                                ) : null,
                                leading: Checkbox (
                                  onChanged: (bool value) {
                                    setState(() {
                                      TaskService.db.checkOrUncheck(item);
                                    });
                                  },
                                  value: item.completedAt == '' ? false : true,
                                ),
                                trailing: item.isPrimary
                                    ? Text('⭐     до ' + item.deadlineTime, style: TextStyle(color: item.completedAt == "" ? Colors.black : Colors.grey))
                                    : Text('до ' + item.deadlineTime, style: TextStyle(color: item.completedAt == "" ? Colors.black : Colors.grey)),
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
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
    );
  }
}