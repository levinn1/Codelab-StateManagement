import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Counter {
  int value;
  Color color;
  String label;

  Counter({this.value = 0, this.color = Colors.blue, this.label = 'Counter'});
}

class GlobalState extends ChangeNotifier {
  final List<Counter> _counters = [];

  List<Counter> get counters => List.unmodifiable(_counters);

  void updateCounterColor(int index, Color newColor) {
  if (index >= 0 && index < _counters.length) {
    _counters[index].color = newColor;
    notifyListeners();
  }
}

void updateCounterLabel(int index, String newLabel) {
  if (index >= 0 && index < _counters.length) {
    _counters[index].label = newLabel;
    notifyListeners();
  }
}

void reorderCounters(int oldIndex, int newIndex) {
  if (newIndex > oldIndex) newIndex--;
  final counter = _counters.removeAt(oldIndex);
  _counters.insert(newIndex, counter);
  notifyListeners();
}


  void addCounter() {
    _counters.add(Counter());
    notifyListeners();
  }

  void removeCounter(int index) {
    if (index >= 0 && index < _counters.length) {
      _counters.removeAt(index);
      notifyListeners();
    }
  }

  void incrementCounter(int index) {
    if (index >= 0 && index < _counters.length) {
      _counters[index].value++;
      notifyListeners();
    }
  }

  void decrementCounter(int index) {
    if (index >= 0 && index < _counters.length) {
      if (_counters[index].value > 0) {
        _counters[index].value--;
        notifyListeners();
      }
    }
  }
}
