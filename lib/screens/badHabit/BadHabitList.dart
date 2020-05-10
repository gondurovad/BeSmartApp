import 'package:besmart/models/BadHabitModel.dart';
import 'package:besmart/services/BadHabitService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Класс - Виджет экран BadHabit
class BadHabitList extends StatefulWidget {
  @override
  _BadHabitListState createState() => _BadHabitListState();
}

// Класс состояния класса BadHabit
class _BadHabitListState extends State<BadHabitList> {

  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var badHabit = new BadHabitModel(id: null, name: null, startAt: null);

  // Получть даты между двумя
  List<DateTime> calculateDate(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Вредные привычки"), automaticallyImplyLeading: false),
      drawer: BeSmartDrawer(),
      body: FutureBuilder<List<BadHabitModel>>(
        future: BadHabitService.db.getAll(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BadHabitModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                BadHabitModel item = snapshot.data[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(item.name),
                      trailing: item.completedAt == ''
                          ? Text(
                              'Активна дней : ${calculateDate(DateTime.parse(item.startAt), DateTime.now()).length}')
                          : Text(
                              'Завершена : ${DateFormat('dd.MM.yyyy в hh:mm').format(DateTime.parse(item.completedAt))}'),
                      onTap: () {
                        Navigator.pushNamed(context, '/bad-habit/${item.id}');
                      },
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Редактировать',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Редактировать привычку"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                elevation: 20.0,
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('ОТМЕНА'),
                                    onPressed: () {
                                      setState(() {
                                        badHabit.name =
                                            nameController.text = '';
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                  FlatButton(
                                      child: Text('СОХРАНИТЬ'),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          badHabit.id = item.id;
                                          await BadHabitService.db
                                              .update(badHabit);
                                          setState(() {
                                            badHabit.id = null;
                                            badHabit.name =
                                                nameController.text = '';
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      })
                                ],
                                content: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    initialValue: badHabit.name = item.name,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Введите название привычки';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      badHabit.id = item.id;
                                      badHabit.name = value;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Название привчки',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(5.0))),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Удалить',
                      color: Colors.pink,
                      icon: Icons.delete,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text('Удалить привычку?'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                  elevation: 20.0,
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ОТМЕНА'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('УДАЛИТЬ'),
                                      onPressed: () async {
                                        await BadHabitService.db
                                            .deleteById(item.id);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ));
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Добавить привычку"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    elevation: 20.0,
                    actions: <Widget>[
                      FlatButton(
                        child: Text('ОТМЕНА'),
                        onPressed: () {
                          setState(() {
                            badHabit.name = nameController.text = '';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                          child: Text('ДОБАВИТЬ'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await BadHabitService.db.create(badHabit);
                              setState(() {
                                badHabit.name = nameController.text = '';
                              });
                              Navigator.of(context).pop();
                            }
                          })
                    ],
                    content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Введите название привычки';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Название привычки',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                controller: nameController,
                                onChanged: (value) {
                                  badHabit.name = nameController.text;
                                },
                              ),
                            ),
                            DateTimeField(
                              format: DateFormat('dd.MM.yyyy в HH:mm'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Выберите дату и время';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Последний инцидент',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.combine(date, time);
                                } else {
                                  return currentValue;
                                }
                              },
                              onChanged: (DateTime date) {
                                badHabit.startAt = date.toIso8601String();
                              },
                            ),
                          ],
                        )));
              });
        },
      ),
    );
  }
}