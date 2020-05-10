import 'package:besmart/models/NoteModel.dart';
import 'package:besmart/services/NoteService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Класс - Виджет экран NoteList
class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

// Класс состояния класса NoteList
class _NoteListState extends State<NoteList> {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var note = new NoteModel(id: null, name: null);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Заметки"), automaticallyImplyLeading: false),
      drawer: BeSmartDrawer(),
      body: FutureBuilder<List<NoteModel>>(
        future: NoteService.db.getAll(),
        builder: (BuildContext context,
            AsyncSnapshot<List<NoteModel>> noteSnapshot) {
          if (noteSnapshot.hasData) {
            return ListView.builder(
              itemCount: noteSnapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                NoteModel item = noteSnapshot.data[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
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
                                title: Text("Редактировать заметку"),
                                shape: RoundedRectangleBorder (
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                elevation: 20.0,
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('ОТМЕНА'),
                                    onPressed: () {
                                      setState(() {
                                        note.name = nameController.text = '';
                                        note.description = descriptionController.text = '';
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                  FlatButton(
                                      child: Text('СОХРАНИТЬ'),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          note.id = item.id;
                                          await NoteService.db.update(note);
                                          setState(() {
                                            note.id = null;
                                            note.name = nameController.text = '';
                                            note.description = descriptionController.text = '';
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
                                      Padding (
                                        padding: EdgeInsets.only(bottom: 16),
                                        child : TextFormField(
                                          initialValue: note.name = item.name,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Введите название заметки';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Название заметки',
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                          onChanged: (value) {
                                            note.name = value;
                                          },
                                        ),
                                      ),
                                      Padding (
                                        padding: EdgeInsets.only(bottom: 16),
                                        child : TextFormField(
                                          initialValue: note.description = item.description,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Введите описание заметки';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Описание заметки',
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                          onChanged: (value) {
                                            note.description = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
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
                              title: Text('Удалить заметку?'),
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
                                    await NoteService.db.deleteById(item.id);
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                    elevation: 20.0,
                    actions: <Widget>[
                      FlatButton(
                        child: Text('ОТМЕНА'),
                        onPressed: () {
                          setState(() {
                            note.name = nameController.text = '';
                            note.description = descriptionController.text = '';
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                          child: Text('ДОБАВИТЬ'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await NoteService.db.create(note);
                              setState(() {
                                note.name = nameController.text = '';
                                note.description = descriptionController.text = '';
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
                            Padding (
                              padding: EdgeInsets.only(bottom: 16),
                              child : TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Введите название заметки';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Название заметки',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                controller: nameController,
                                onChanged: (value) {
                                  note.name = nameController.text;
                                },
                              ),
                            ),
                            Padding (
                              padding: EdgeInsets.only(bottom: 16),
                              child : TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Введите описание заметки';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Описание заметки',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                controller: descriptionController,
                                onChanged: (value) {
                                  note.description = descriptionController.text;
                                },
                              ),
                            ),
                          ],
                        )
                    ));
              });
        },
      ),
    );
  }
}

