import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:besmart/services/TaskService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

// Класс - Виджет экран ProjectList
class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

// Класс состояния класса ProjectList
class _ProjectListState extends State<ProjectList> {


  @override
  Widget build(BuildContext context) {

    final width = ( MediaQuery.of(context).size.width).floorToDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text('Проекты'), automaticallyImplyLeading: false
      ),
      drawer: BeSmartDrawer(),
      body: FutureBuilder<List<ProjectModel>>(
        future: ProjectService.db.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ProjectModel item = snapshot.data[index];
                return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                color: Colors.white,
                child: Column(
                    children: [
                      ListTile(
                        title: Text(item.name),
                        subtitle: Text('Дедлайн : ${DateFormat('dd.MM.yyyy в hh:mm').format(DateTime.parse(item.deadlineAt))}'),
                        leading: CircleAvatar(child:Icon(Icons.book), ),
                        onTap: (){Navigator.pushNamed(context, '/project/${item.id}');},
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
      bottomNavigationBar: BeSmartBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: () {
        Navigator.pushNamed(context, '/project-create');
      },),
    );
  }
}