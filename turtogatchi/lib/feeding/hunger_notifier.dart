import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HungerNotifier extends StateNotifier<int> {
  HungerNotifier(int level) : super(level) {
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(minutes: 3), (_) {
      decreaseHunger();
    });
  }

  void decreaseHunger() {
    state--;
  }

  void feed() {
    state += 2;
  }
}
