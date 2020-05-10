import 'package:besmart/models/HabitModel.dart';
import 'package:besmart/services/HabitService.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

// Класс - Виджет экран Habit
class Habit extends StatefulWidget {
  final String _id;

  Habit({String id}) : _id = id;

  @override
  _HabitState createState() => _HabitState();
}

// Класс - Модель переодичность напоминаний
class RemindItems {
  // Кол-во секунд
  int frequency;
  // Описание
  String name;

  RemindItems({this.frequency, this.name});
}

// Класс состояния класса Habit
class _HabitState extends State<Habit> {

  var habit = new HabitModel(id: null, name: null, lifetime: null);

  List<RemindItems> remindItems = [
    RemindItems(frequency: 1800, name : '30 мин'),
    RemindItems(frequency: 3600, name : '1 час'),
    RemindItems(frequency: 7200, name : '2 часа'),
    RemindItems(frequency: 10800, name : '3 часа'),
    RemindItems(frequency: 18000, name : '5 часов'),
    RemindItems(frequency: 28800, name : '8 часов'),
    RemindItems(frequency: 36000, name : '10 часов'),
    RemindItems(frequency: 43200, name : '12 часов'),
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Создать привычку')),
      body: FutureBuilder (
        future: HabitService.db.getById(int.parse(widget._id)),
        builder: (BuildContext context, AsyncSnapshot<List<HabitModel>> habitSnapshot){
          if (habitSnapshot.hasData) {
            habit.id = habitSnapshot.data[0].id;
           return Form(
              key: _formKey,
              child: Container(
                padding: new EdgeInsets.only(left: 16, right: 16, top: 16),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: TextFormField(
                        initialValue: habit.name = habitSnapshot.data[0].name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Сформулируйте привычку';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          habit.name = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'Название привычки',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: DateTimeField(
                        initialValue: DateTime.parse(habit.lifetime = habitSnapshot.data[0].lifetime),
                        format: DateFormat('dd-MM-yyyy HH:mm'),
                        validator: (value) {
                          if (value == null) {
                            return 'Выберите дату и время';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Привычка активна до',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
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
                          habit.lifetime = DateFormat('yyyy-MM-dd HH:mm').format(date);
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: DateTimeField(
                          initialValue: DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + (habit.dawn = habitSnapshot.data[0].dawn)),
                          format: DateFormat('hh:mm'),
                          validator: (value) {
                            if (value==null) {
                              return 'Выберите время';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Уведомлять с ',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            if (time != null) {
                              return DateTimeField.combine(new DateTime.now(), time);
                            } else {
                              return currentValue;
                            }
                          },
                          onChanged: (DateTime date) {
                            habit.dawn = DateFormat('hh:mm').format(date);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: DateTimeField(
                          initialValue: DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + (habit.sunset = habitSnapshot.data[0].sunset)),
                          format: DateFormat('hh:mm'),
                          validator: (value) {
                            if (value==null) {
                              return 'Выберите время';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Уведомлять до',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            if (time != null) {
                              return DateTimeField.combine(new DateTime.now(), time);
                            } else {
                              return currentValue;
                            }
                          },
                          onChanged: (DateTime date) {
                            habit.sunset = DateFormat('hh:mm').format(date);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: SmartSelect<int>.single(
                          options: SmartSelectOption.listFrom<int, RemindItems>(
                            source: remindItems,
                            value: (index, item) => item.frequency,
                            title: (index, item) => item.name,
                          ),
                          title: 'Уведомлять каждые',
                          placeholder: '',
                          onChange: (int value) {
                            setState(() {
                              if (habit.frequency == value) {
                                habit.frequency = null;
                              } else {
                                habit.frequency = value;
                              }
                            });
                          },
                          modalType: SmartSelectModalType.bottomSheet,
                          choiceType: SmartSelectChoiceType.chips,
                          value: habit.frequency,
                        )
                    ),

                  ],
                ),
              ),
            );
          } else {
          return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child: MaterialButton(
            color: Colors.indigo,
            padding: EdgeInsets.all(5),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await HabitService.db.update(habit);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Сохранить',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}