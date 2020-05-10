import 'dart:async';
import 'package:intl/intl.dart';

// Класс реализующий таймер Pomodoro
class PomodoroTimer {
  // Время действия одной помидорки
  static const SESSION_TIME = Duration(minutes: 25);
  // Время перерыва между помидорками
  static const BREAK_TIME = Duration(minutes: 5);

  // Остановлен ли
  bool isBreak = false;
  // Когда таймер обновлен
  Function onTimerUpdate;
  // Продолжительность
  Duration _currentTime, startTime;
  // Секундомер
  final Stopwatch _stopwatch = Stopwatch();

  // Конструктор класса
  PomodoroTimer(this.onTimerUpdate);

  // Установить время запуска
  set currentTime(Duration time) {
    startTime = _currentTime = time;
  }
  // Получить актуальное время
  get currentTime => _currentTime;
  // Форматирование времени
  get formattedCurrentTime =>
      DateFormat('mm:ss').format(DateTime(DateTime.now().year, 0, 0, 0, 0, _currentTime.inSeconds));
  // Отсчет
  get isRunning => _stopwatch.isRunning;

  // Старт
  start() {
    isBreak = false;
    currentTime = PomodoroTimer.SESSION_TIME;
    _run();
  }
  // Запуск
  _run() {
    _stopwatch.reset(); _stopwatch.start();
    _timer();
  }
  // Сброс
  reset() {
    _stopwatch.stop(); _stopwatch.reset();
    _currentTime = startTime = SESSION_TIME;
  }
  // Таймер
  _timer() async{
    _currentTime = startTime - _stopwatch.elapsed;
    _currentTime.inSeconds > 0  && isRunning ? Timer(Duration(seconds: 1), _timer) : _stopwatch.stop();
    onTimerUpdate();
    if (startTime == SESSION_TIME && _currentTime.inSeconds == 0 && !isBreak) {
      await Future.delayed(Duration(seconds: 1));
      isBreak = true;
      currentTime = BREAK_TIME;
      _run();
    }
  }
}