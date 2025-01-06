import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class StepsCount extends StatefulWidget {
  const StepsCount({super.key});

  @override
  State<StepsCount> createState() => _StepsCountState();
}

class _StepsCountState extends State<StepsCount> {
  int _stepCount = 0;
  late Stream<StepCount> _stepCountSream;

  @override
  void initState() {
    super.initState();
    initializePedometer();
  }

  void initializePedometer() {
    _stepCountSream = Pedometer.stepCountStream;
    _stepCountSream.listen(onStepCount).onError(onStepCountError);
  }

  void onStepCount(StepCount event) {
    setState(() {
      _stepCount = event.steps;
    });
  }

  void onStepCountError(error) {
    print('Steps Count Error: $error');
    setState(() {
      _stepCount = 0;
    });
  }

  void resetSteps() {
    setState(() {
      _stepCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Count Your Steps123',
          style: TextStyle(
            fontSize: 25,
            // fontFamily: DancingScript,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Steps Taken:',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '$_stepCount',
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: resetSteps,
                child: Text('Reset Counter'),),
          ],
        ),
      ),
    );
  }
}
