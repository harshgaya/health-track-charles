import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../main.dart';
import '../../../models/alarm_helper.dart';
import '../../../models/alarm_info.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  bool _isRepeatSelected = false;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Screen size
    final isSmallScreen = size.width < 600; // Adaptive check

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08, vertical: size.height * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Alarm',
              style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700,
                color: Colors.blue,
                fontSize: isSmallScreen ? 20 : 24, // Adaptive font size
              ),
            ),
            SizedBox(height: size.height * 0.02), // Adaptive spacing
            DottedBorder(
              strokeWidth: 2,
              color: Colors.red,
              borderType: BorderType.RRect,
              radius: Radius.circular(24),
              dashPattern: [5, 4],
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02), // Adaptive padding
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: MaterialButton(
                  onPressed: () {
                    _alarmTimeString =
                        DateFormat('HH:mm').format(DateTime.now());
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Padding(
                              padding: EdgeInsets.all(
                                  size.width * 0.05), // Adaptive padding
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      var selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (selectedTime != null) {
                                        final now = DateTime.now();
                                        var selectedDateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );
                                        _alarmTime = selectedDateTime;
                                        setModalState(() {
                                          _alarmTimeString = DateFormat('HH:mm')
                                              .format(selectedDateTime);
                                        });
                                      }
                                    },
                                    child: Text(
                                      _alarmTimeString,
                                      style: TextStyle(
                                          fontSize: isSmallScreen
                                              ? 24
                                              : 32), // Adaptive font size
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.02),
                                  FloatingActionButton.extended(
                                    onPressed: () {},
                                    icon: Icon(Icons.alarm),
                                    label: Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/add_alarm.png',
                        scale:
                            isSmallScreen ? 2 : 1.5, // Adaptive image scaling
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'Add Alarm',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontFamily: 'avenir'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
