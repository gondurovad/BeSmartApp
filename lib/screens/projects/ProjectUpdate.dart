import 'package:besmart/models/CategoryModel.dart';
import 'package:besmart/models/ProjectModel.dart';
import 'package:besmart/services/CategoryService.dart';
import 'package:besmart/services/ProjectService.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

// Класс - Виджет экран ProjectUpdate
class ProjectUpdate extends StatefulWidget {

  final String _id;
  // Конструктор класса
  ProjectUpdate({String id}) : _id = id;

  @override
  _ProjectUpdateState createState() => _ProjectUpdateState();
}

// Класс состояния класса ProjectUpdate
class _ProjectUpdateState extends State<ProjectUpdate> {

  var project = new ProjectModel(id: null, name: null, deadlineAt: null);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование проекта'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ProjectModel>>(
          future: ProjectService.db.getById(int.parse(widget._id)),
          builder: (BuildContext context,
              AsyncSnapshot<List<ProjectModel>> projectSnapshot) {
            if (projectSnapshot.hasData) {
              project.id = projectSnapshot.data[0].id;
              return Form(
                key: _formKey,
                child: Container(
                  padding: new EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFormField(
                          initialValue: project.name = projectSnapshot.data[0].name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Введите название проекта';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            project.name = value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Название проекта',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          initialValue: project.description = projectSnapshot.data[0].description,
                          onChanged: (value) {
                            project.description = value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Описание проекта',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: DateTimeField(
                          initialValue: DateTime.parse(projectSnapshot.data[0].deadlineAt),
                          format: DateFormat('dd.MM.yyyy в hh:mm'),
                          validator: (value) {
                            if (value == null) {
                              return 'Выберите дату и время';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Дедлайн проекта',
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
                            project.deadlineAt = date.toIso8601String();
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
                                title: 'Выберите категорию',
                                onChange: (int value) {
                                  setState(() {
                                    if (project.categoryId == value) {
                                      project.categoryId = null;
                                    } else {
                                      project.categoryId = value;
                                    }
                                  });
                                },
                                value: project.categoryId,
                                modalType: SmartSelectModalType.bottomSheet,
                                choiceType: SmartSelectChoiceType.chips,
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
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
                await ProjectService.db.update(project);
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