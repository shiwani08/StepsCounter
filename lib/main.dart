import 'package:flutter/material.dart';
import 'package:steps_counter/steps_count.dart';

void main() {
  runApp(StepsCounterApp());
}

class StepsCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Count your steps',
        home: StepsCount(),);
  }
}
