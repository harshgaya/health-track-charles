import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DailyStepCounter {
  late Stream<StepCount> _stepCountStream;
  int _dailyStartSteps = 0;
  int stepsToday = 0;
  String _currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // This map keeps track of each unique minute when a step was taken
  final Map<String, bool> _standMinutesMap = {};

  // Updated to include standMinutes
  Function(int steps, int standMinutes)? onStepUpdate;

  DailyStepCounter({this.onStepUpdate});

  Future<void> init() async {
    await _loadDailyBaseline();
    _startListening();
  }

  Future<void> _loadDailyBaseline() async {
    final prefs = await SharedPreferences.getInstance();
    _currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final storedDate = prefs.getString('step_date');
    final storedSteps = prefs.getInt('step_baseline');

    if (storedDate == _currentDate && storedSteps != null) {
      _dailyStartSteps = storedSteps;
    } else {
      _dailyStartSteps = 0;
      await prefs.setString('step_date', _currentDate);
    }
  }

  void _startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError((e) {
      print("Step count error: $e");
    });
  }

  Future<void> _onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // New day logic
    if (today != _currentDate) {
      _currentDate = today;
      _dailyStartSteps = event.steps;
      _standMinutesMap.clear(); // Clear previous day's stand minutes
      await prefs.setInt('step_baseline', _dailyStartSteps);
      await prefs.setString('step_date', _currentDate);
    }

    // First-time setup
    if (_dailyStartSteps == 0) {
      _dailyStartSteps = event.steps;
      await prefs.setInt('step_baseline', _dailyStartSteps);
    }

    stepsToday = event.steps - _dailyStartSteps;

    // Register unique minute as "standing"
    String currentMinute =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    _standMinutesMap[currentMinute] = true;

    if (onStepUpdate != null) {
      onStepUpdate!(stepsToday, _standMinutesMap.length);
    }
  }
}
