import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/models/TaskModel.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:besmart/services/TaskService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {

  var deadlineDate = DateFormat('yyyy-MM-ddT00:00:00.000').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задачи на день'), automaticallyImplyLeading: false),
      drawer: BeSmartDrawer(),
      body: Column(
        children: <Widget>[
          Padding (
            padding: EdgeInsets.only(left: 16),
            child: DateTimeField(
              initialValue: DateTime.parse(deadlineDate),
              format: DateFormat('dd-MM-yyyy'),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  return DateTimeField.combine(date, null);

                } else {
                  return currentValue;
                }
              },
              resetIcon: null,
              decoration:
                InputDecoration(
                  labelText: 'Дата : ',
                  icon: Icon(Icons.calendar_today, ),
                  border: InputBorder.none,
                ),
              onChanged: (DateTime date) {
                setState(() {
                  deadlineDate =  date != null ? date.toIso8601String() : deadlineDate;
                });
              },
            ),
          ),
          Expanded (
            child: FutureBuilder<List<TaskModel>>(
              future: TaskService.db.getTasksByDeadlineDate(deadlineDate),
              builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> taskSnapshot) {
                if (taskSnapshot.hasData) {
                  return ListView.builder(
                      itemCount: taskSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        TaskModel item = taskSnapshot.data[index];
                        //Свайп
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container (
                            color: Colors.white,
                            child: ListTile (
                              title: Text(item.name, style: TextStyle(color: item.completedAt == "" ? Colors.black : Colors.grey)),
                              subtitle: item.projectId != null ? FutureBuilder (
                                  future: ProjectService.db.getById(item.projectId),
                                  builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>> projectSnapshot) {
                                    if (projectSnapshot.hasData) {
                                      return Text(projectSnapshot.data[0].name, style: TextStyle(color: item.completedAt == "" ? Colors.indigo : Colors.grey));
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
          ),
        ],
      ),
      bottomNavigationBar: BeSmartBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: () {
        Navigator.pushNamed(context, '/task-create');
      },),
    );
  }
}