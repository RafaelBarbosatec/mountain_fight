import 'package:flutter/cupertino.dart';

class Delay {
  final int time;

  Delay(this.time);
}

class Frame {
  final dynamic value;
  final DateTime time;
  DateTime timeRun;

  Frame(this.value, this.time);
}

class BufferDelay {
  final int delay;

  List<dynamic> _timeLine = List();

  ValueChanged<dynamic> _listen;

  int _currentIndex = 0;

  BufferDelay(this.delay);

  void add(dynamic value, DateTime time) {
    if (_timeLine.isEmpty) {
      _timeLine.add(Delay(delay));
      _timeLine.add(Frame(value, time));
      run();
    } else {
      Frame lastFrame = _timeLine.last;
      if (lastFrame.timeRun == null) {
        int delay = time.difference(lastFrame.time).inMilliseconds;
        _timeLine.add(Delay(delay));
        _timeLine.add(Frame(value, time));
      } else {
        int delayFrame = time.difference(lastFrame.time).inMilliseconds;
        int delayDone =
            DateTime.now().difference(lastFrame.timeRun).inMilliseconds;
        int delay = delayFrame - delayDone;
        if (delay > 0) {
          _timeLine.add(Delay(delay));
        }
        _timeLine.add(Frame(value, time));
        verifyNext();
      }
    }
  }

  void reset() {
    Frame f = _timeLine.where((element) => element is Frame).last;
    if (f.timeRun != null) {
      _timeLine.clear();
      _currentIndex = 0;
    }
  }

  void listen(ValueChanged<dynamic> listen) {
    _listen = listen;
  }

  void run() async {
    if (_currentIndex < _timeLine.length) {
      var value = _timeLine[_currentIndex];
      if (value is Delay) {
        await Future.delayed(Duration(milliseconds: value.time));
        verifyNext();
      } else if (value is Frame) {
        value.timeRun = DateTime.now();
        if (_listen != null) _listen(value.value);
        verifyNext();
      }
    }
  }

  void verifyNext() {
    if ((_currentIndex + 1) < _timeLine.length) {
      _currentIndex++;
      run();
    }
  }
}
