import 'package:besmart/widgets/beSmartBottomAppBar/BeSmartBottomAppBar.dart';
import 'package:besmart/widgets/beSmartDrawer/BeSmartDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:besmart/screens/pomodoro/PomodoroTimer.dart';

// Класс - Виджет экран Pomodoro
class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

// Класс состояния класса Pomodoro
class _PomodoroState extends State<Pomodoro> {

  PomodoroTimer timer;
  double _currentSessionProgress = 0.0;

  @override
  void initState() {
    super.initState();
    timer = PomodoroTimer(_onTimerUpdate)
      ..currentTime = PomodoroTimer.SESSION_TIME;
  }

  _onTimerUpdate() => setState(() {
        _currentSessionProgress = double.parse(
            ((timer.startTime.inSeconds - timer.currentTime.inSeconds) /
                    timer.startTime.inSeconds)
                .toStringAsFixed(3));
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Помидорка'),
          automaticallyImplyLeading: false,
        ),
        drawer: BeSmartDrawer(),
        body: Container(
          alignment: Alignment(0.0, 0.0),
          child: Column (
            children: <Widget>[
              Padding (
                padding: EdgeInsets.all(16),
                child: Text('Метод «Помидора» — техника управления временем, которая предполагает разбиение задач на 25-минутные периоды, называемые «помидорами», сопровождаемые короткими 5-минутными перерывами.',),
              ),
              Padding (
                padding: EdgeInsets.only(left: 16, top: 48, right: 16),
                child: Text("${timer.formattedCurrentTime}", style: TextStyle(fontSize: 65.0, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        bottomNavigationBar: BeSmartBottomAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            child: timer.isRunning ? Icon(Icons.replay) : Icon(Icons.play_arrow),
            onPressed: timer.isRunning ? timer.reset : timer.start),
      );
}
