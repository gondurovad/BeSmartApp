import 'package:besmart/models/CategoryModel.dart';
import 'package:besmart/services/CategoryService.dart';
import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var category = new CategoryModel(id: null, name: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Категории"), automaticallyImplyLeading: false),
      drawer: BeSmartDrawer(),
      body: FutureBuilder<List<CategoryModel>>(
        future: CategoryService.db.getAll(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                CategoryModel item = snapshot.data[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.bookmark),
                      ),
                      title: Text(item.name),
                      onTap: () {
                        Navigator.pushNamed(context, '/category/${item.id}');
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
                                title: Text("Редактировать категорию"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                elevation: 20.0,
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('ОТМЕНА'),
                                    onPressed: () {
                                      setState(() {
                                        category.name = nameController.text = '';
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                      child: Text('СОХРАНИТЬ'),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          category.id = item.id;
                                          await CategoryService.db.update(category);
                                          setState(() {
                                            category.id = null;
                                            category.name = nameController.text = '';
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      })
                                ],
                                content: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    initialValue: category.name = item.name,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Введите название категории';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      category.name = value;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Название категории',
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
                                  title: Text('Удалить категорию?'),
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
                                        await CategoryService.db
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
                    title: Text("Добавить категорию"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    elevation: 20.0,
                    actions: <Widget>[
                      FlatButton(
                        child: Text('ОТМЕНА'),
                        onPressed: () {
                          setState(() {
                            category.name = nameController.text = '';
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      FlatButton(
                          child: Text('ДОБАВИТЬ'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await CategoryService.db.create(category);
                              setState(() {
                                category.name = nameController.text = '';
                              });
                              Navigator.of(context).pop();
                            }
                          })
                    ],
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Введите название категории';
                          }
                          return null;
                        },
                        controller: nameController,
                        onChanged: (value) {
                          category.name = nameController.text;
                        },
                        decoration: InputDecoration(
                            labelText: 'Название категории',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(5.0))),
                      ),
                    ));
              });
        },
      ),
    );
  }
}
