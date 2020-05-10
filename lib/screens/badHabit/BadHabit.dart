import 'package:besmart/models/BadHabitModel.dart';
import 'package:besmart/models/IncidentModel.dart';
import 'package:besmart/services/BadHabitService.dart';
import 'package:besmart/services/IncidentService.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

// Класс - Виджет экран BadHabit
class BadHabit extends StatefulWidget {

  final String _id;
  BadHabit({String id}) : _id = id;

  @override
  _BadHabitState createState() => _BadHabitState();
}

// Класс состояния класса BadHabit
class _BadHabitState extends State<BadHabit> {

  var incident = new IncidentModel(id: null, incidentDate: null);
  var badHabit = new BadHabitModel(id: null, name: null, startAt: null);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вредная привычка'),),
      body: FutureBuilder<List<BadHabitModel>>(
          future: BadHabitService.db.getById(int.parse(widget._id)),
          builder: (BuildContext context, AsyncSnapshot<List<BadHabitModel>> badHabitSnapshot) {
            if (badHabitSnapshot.hasData) {
              return Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding (
                    padding: EdgeInsets.all(16),
                    child: Text(badHabitSnapshot.data[0].name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,)),
                  ),
                  Padding (
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text('Начало : ${DateFormat('dd.MM.yyyy в hh:mm').format(DateTime.parse(badHabitSnapshot.data[0].startAt))}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,)),
                  ),
                  Padding (
                    padding: EdgeInsets.all(16),
                    child: Text('Список инцидентов : ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,)),
                  ),
                  Expanded (
                    child: FutureBuilder<List<IncidentModel>>(
                        future: IncidentService.db.getIncidentsByBadHabitId(badHabitSnapshot.data[0].id),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<IncidentModel>> incidentSnapshot) {
                          if (incidentSnapshot.hasData) {
                            return ListView.builder(
                                itemCount: incidentSnapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  IncidentModel item = incidentSnapshot.data[index];
                                  return Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    child: Container (
                                      color: Colors.white,
                                      child: ListTile (
                                        leading: Text('${index+1}.',style: TextStyle(fontSize: 18, ) ) ,
                                        title: Text(DateFormat('dd.MM.yyyy в hh:mm').format(DateTime.parse(item.incidentDate))),
                                      ),
                                    ),
                                    secondaryActions: <Widget>[
                                      IconSlideAction (
                                        caption: 'Удалить',
                                        color: Colors.pink,
                                        icon: Icons.delete,
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog (
                                                title: Text('Удалить инцидент?'),
                                                shape: RoundedRectangleBorder (
                                                  borderRadius: BorderRadius.circular(3.0),
                                                ),
                                                elevation: 20.0,
                                                actions: <Widget>[
                                                  FlatButton (
                                                    child: Text('Отмена'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  FlatButton (
                                                    child: Text('Удалить'),
                                                    onPressed: () async {
                                                      await IncidentService.db.deleteById(item.id);
                                                      setState(()  {});
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
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Добавить инцидент"),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                    elevation: 20.0,
                    actions: <Widget>[
                      FlatButton(
                        child: Text('ОТМЕНА'),
                        onPressed: () {
                          setState(() {
                            incident.incidentDate = '';
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                          child: Text('ДОБАВИТЬ'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await IncidentService.db.create(incident);
                              setState(() {
                                incident.incidentDate = '';
                              });
                              Navigator.of(context).pop();
                            }
                          })
                    ],
                    content: Form(
                        key: _formKey,
                        child: Column (
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            DateTimeField(
                              format: DateFormat('dd.MM.yyyy в HH:mm'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Выберите дату и время';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Дата срыва',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.combine(date, time);
                                } else {
                                  return currentValue;
                                }
                              },
                              onChanged: (DateTime date) {
                                incident.badHabitId = int.parse(widget._id);
                                incident.incidentDate = date.toIso8601String();
                                print(incident.incidentDate);
                              },
                            ),
                          ],
                        )
                    ));
              });
        },

      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child: FutureBuilder<List<BadHabitModel>>(
              future: BadHabitService.db.getById(int.parse(widget._id)),
              builder: (BuildContext context, AsyncSnapshot<List<BadHabitModel>> badHabitSnapshot) {
                if (badHabitSnapshot.hasData) {
                  return MaterialButton(
                    color: Colors.indigo,
                    padding: EdgeInsets.all(5),
                    onPressed: () async {
                      badHabitSnapshot.data[0].completedAt =='' ?  BadHabitService.db.complete(badHabitSnapshot.data[0]) : BadHabitService.db.activate(badHabitSnapshot.data[0]);
                      Navigator.of(context).pop();
                    },
                    child: Text(badHabitSnapshot.data[0].completedAt =='' ? 'Завершить' : 'Активировать', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                } else return Center(child: CircularProgressIndicator());
              }
          ),
      ),
    );
  }
}