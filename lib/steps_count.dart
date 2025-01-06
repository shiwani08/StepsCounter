import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepsCount extends StatefulWidget {
  const StepsCount({super.key});

  @override
  State<StepsCount> createState() => _StepsCountState();
}

class _StepsCountState extends State<StepsCount> {
  int _initialStepCount = 0;
  int _stepCount = 0;
  String _status = "";
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  @override
  void initState() {
    super.initState();
    initializePedometer();

    Future<void> requestPermission() async {
      if (await Permission.activityRecognition.isDenied) {
        await Permission.activityRecognition.request();
      }
    }

    Future.delayed(
      Duration.zero,
      () async {
        await requestPermission();
        initializePedometer();
      },
    );
  }

  void initializePedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

  void onStepCount(StepCount event) {
    setState(() {
      if (_initialStepCount == 0) {
        _initialStepCount = event.steps; // Store the starting step count.
      }

      _stepCount = event.steps - _initialStepCount; // Calculate relative steps.
      print('Step Count: $_stepCount');
    });
  }


  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
  }

  void onStepCountError(error) {
    print('Steps Count Error: $error');
    setState(() {
      _stepCount = 0;
    });
  }

  void onPedestrianStatusError(error) {
    print('Error in pedestrian status stream: $error');
    setState(() {
      _status = "Error";
    });
  }

  void resetSteps() {
    setState(() {
      _initialStepCount = _stepCount + _initialStepCount;
      _stepCount = 0;
    });
  }

  Future<void> initPlatformState() async {
    // Init streams
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _stepCountStream = await Pedometer.stepCountStream;

    // Listen to streams and handle errors
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Count Your Steps..',
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
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: resetSteps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )
                ),
              child: Text('Reset Counter',
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
