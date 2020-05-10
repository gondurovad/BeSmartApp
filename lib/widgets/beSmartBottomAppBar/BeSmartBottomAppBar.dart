import 'package:flutter/material.dart';

// Класс - Виджет нижнее меню

class BeSmartBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
            IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.popAndPushNamed(context, '/')),
          ],
        ),
      );
  }
}
