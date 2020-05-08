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

  class TaskCreate extends StatefulWidget {
  @override
  _TaskCreateState createState() => _TaskCreateState();
  }

  class _TaskCreateState extends State<TaskCreate> {

  var task = new TaskModel(id: null, name: null, deadlineDate: null, deadlineTime: null);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Создать задачу')),
      body: Form(
        key: _formKey,
        child: Container(
          padding: new EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Введите название задачи';
                    }
                    return null;
                  },
                  controller: nameController,
                  onChanged: (value) {
                    task.name = nameController.text;
                  },
                  decoration: InputDecoration(
                      labelText: 'Название задачи',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) {
                    task.description = descriptionController.text;
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
                    format: DateFormat('hh:mm'),
                    validator: (value) {
                      if (value==null) {
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
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProjectModel>> snapshot) {
                    if (snapshot.hasData) {
                      return SmartSelect<int>.single(
                        options: SmartSelectOption.listFrom<int, ProjectModel>(
                          source: snapshot.data,
                          value: (index, item) => item.id,
                          title: (index, item) => item.name,
                        ),
                        title: '${task.categoryId != null ? 'Задача отнесена к категории' : 'Выбор проекта'}',
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
                        enabled: task.categoryId != null ? false: true,
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
                        options: SmartSelectOption.listFrom<int, CategoryModel>(
                          source: snapshot.data,
                          value: (index, item) => item.id,
                          title: (index, item) => item.name,
                        ),
                        title: '${task.projectId != null ? 'Задача отнесена к проекту' : 'Выбор категории'}',
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
                        enabled: task.projectId != null ? false: true,
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
                        task.isPrimary = value;
                      });
                    },
                    value: task.isPrimary ,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16),
          child: MaterialButton(
            color: Colors.indigo,
            padding: EdgeInsets.all(5),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await TaskService.db.create(task);
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
