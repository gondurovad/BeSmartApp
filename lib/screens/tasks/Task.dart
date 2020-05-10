import 'package:besmart/models/CategoryModel.dart';
import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/models/TaskModel.dart';
import 'package:besmart/services/CategoryService.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:besmart/services/TaskService.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

// Класс - Виджет экран Task
class Task extends StatefulWidget {

  final String _id;
  // Конструктор класса
  Task({String id}) : _id = id;

  @override
  _Task createState() => _Task();
}

// Класс состояния класса Task
class _Task extends State<Task> {

  var task = new TaskModel(id: null, name: null, deadlineDate: null, deadlineTime: null);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Просмотр задачи'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<TaskModel>>(
          future: TaskService.db.getById(int.parse(widget._id)),
          builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> taskSnapshot) {
            if (taskSnapshot.hasData) {
              task.id = taskSnapshot.data[0].id;
              return Form(
                key: _formKey,
                child: Container(
                  padding: new EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFormField(
                          initialValue: task.name = taskSnapshot.data[0].name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Введите название задачи';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            task.name = value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Название задачи',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          initialValue: task.description = taskSnapshot.data[0].description,
                          onChanged: (value) {
                            task.description = value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Описание задачи',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: DateTimeField(
                          initialValue: DateTime.parse(task.deadlineDate = taskSnapshot.data[0].deadlineDate),
                          format: DateFormat('dd.MM.yyyy'),
                          validator: (value) {
                            if (value == null) {
                              return 'Выберите дату';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Дата выполнения',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
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
                          onChanged: (DateTime date) {
                            task.deadlineDate = date.toIso8601String();
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: DateTimeField(
                            initialValue: DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + (task.deadlineTime = taskSnapshot.data[0].deadlineTime)),
                            format: DateFormat('hh:mm'),
                            validator: (value) {
                              if (value == null) {
                                return 'Выберите время';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Время выполнения',
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
                              task.deadlineTime = DateFormat('hh:mm').format(date);
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: FutureBuilder(
                          future: ProjectService.db.getAll(),
                          builder: (BuildContext context, AsyncSnapshot<List<ProjectModel>>projectSnapshot) {
                            if (projectSnapshot.hasData) {
                              return SmartSelect<int>.single(
                                options: SmartSelectOption.listFrom<int, ProjectModel>(
                                  source: projectSnapshot.data,
                                  value: (index, item) => item.id,
                                  title: (index, item) => item.name,
                                ),
                                title:
                                    '${task.categoryId != null ? 'Задача отнесена к категории' : 'Выбор проекта'}',
                                placeholder: '',
                                onChange: (int value) {
                                  setState(() {
                                    if (task.projectId == value) {
                                      task.projectId = null;
                                    } else {
                                      task.projectId = value;
                                    }
                                  });
                                },
                                value: task.projectId,
                                modalType: SmartSelectModalType.bottomSheet,
                                choiceType: SmartSelectChoiceType.chips,
                              );
                            } else {
                              return Text('Проекты отсутствуют');
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: FutureBuilder(
                          future: CategoryService.db.getAll(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CategoryModel>> snapshot) {
                            if (snapshot.hasData) {
                              return SmartSelect<int>.single(
                                options: SmartSelectOption.listFrom<int,
                                    CategoryModel>(
                                  source: snapshot.data,
                                  value: (index, item) => item.id,
                                  title: (index, item) => item.name,
                                ),
                                title:
                                    '${task.projectId != null ? 'Задача отнесена к проекту' : 'Выбор категории'}',
                                placeholder: '',
                                onChange: (int value) {
                                  setState(() {
                                    if (task.categoryId == value) {
                                      task.categoryId = null;
                                    } else {
                                      task.categoryId = value;
                                    }
                                  });
                                },
                                value: task.categoryId,
                                modalType: SmartSelectModalType.bottomSheet,
                                choiceType: SmartSelectChoiceType.chips,
                                enabled: task.projectId != null ? false : true,
                              );
                            } else {
                              return Text('Категории отсутствуют');
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text('Главный приоритет'),
                          trailing: Checkbox(
                            onChanged: (bool value) {
                              setState(() {
                                task.isPrimary = !task.isPrimary;
                              });
                            },
                            value: task.isPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child: MaterialButton(
            color: Colors.indigo,
            padding: EdgeInsets.all(5),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await TaskService.db.update(task);
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
