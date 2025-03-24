import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/colors.dart';
import '../../../main.dart';
import '../../../models/alarm_helper.dart';
import '../../../models/alarm_info.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmSet extends StatefulWidget {
  const AlarmSet({super.key});

  @override
  State<AlarmSet> createState() => _AlarmSetState();
}

class _AlarmSetState extends State<AlarmSet> {
  DateTime? _alarmTime;
  DateTime? bedTime;
  String _alarmTimeString = '';
  String bedTimeString = '';
  final mainController = Get.put(MainController());
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    mainController.getBedTime().then((value) {
      bedTimeString = value['bedTime']!;
      _alarmTimeString = value['alarmTime']!;
      setState(() {});
    });
    loadAlarms();

    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo,
      {required bool isRepeating}) async {
    try {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        channelDescription: 'Channel for Alarm notification',
        icon: 'timer_icon',
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        largeIcon: DrawableResourceAndroidBitmap('timer_icon'),
      );

      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      if (isRepeating)
        await flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          'Office',
          alarmInfo.title,
          Time(
            scheduledNotificationDateTime.hour,
            scheduledNotificationDateTime.minute,
            scheduledNotificationDateTime.second,
          ),
          platformChannelSpecifics,
        );
      else
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Office',
          alarmInfo.title,
          tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      print('alarm set');
    } catch (e) {
      print('error setting alarm $e');
    }
  }

  void onSaveAlarm(bool _isRepeating) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime!.add(const Duration(days: 1));

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: 0,
      title: 'alarm',
    );
    _alarmHelper.insertAlarm(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo,
          isRepeating: _isRepeating);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(AppColors.buttonBorderColorLightMode)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/home/bed.png',
                    height: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Bed time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/home/wake-up.png',
                    height: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Wake up',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bedTimeString,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                _alarmTimeString,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tonight',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                'Tomorrow',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: const Color(AppColors.lineColor),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text(
                                      'Bed Time',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () async {
                                        var selectedTime = await showTimePicker(
                                          context: context,
                                          initialTime: Utils.timeToDate(
                                              timeString: bedTimeString),
                                        );
                                        if (selectedTime != null) {
                                          final now = DateTime.now();
                                          var selectedDateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              selectedTime.hour,
                                              selectedTime.minute);
                                          bedTime = selectedDateTime;
                                          setModalState(() {
                                            bedTimeString = DateFormat('HH:mm')
                                                .format(selectedDateTime);
                                          });
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        bedTimeString,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Alarm Time',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () async {
                                        var selectedTime = await showTimePicker(
                                          context: context,
                                          initialTime: Utils.timeToDate(
                                              timeString: _alarmTimeString),
                                        );
                                        if (selectedTime != null) {
                                          final now = DateTime.now();
                                          var selectedDateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              selectedTime.hour,
                                              selectedTime.minute);
                                          _alarmTime = selectedDateTime;
                                          print('alarm time $_alarmTime');

                                          setModalState(() {
                                            _alarmTimeString =
                                                DateFormat('HH:mm')
                                                    .format(selectedDateTime);
                                          });
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        _alarmTimeString,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ),
                                  FloatingActionButton.extended(
                                    onPressed: () {
                                      setState(() {});
                                      mainController.saveBedTime(
                                          bedTime: bedTimeString,
                                          alarmTime: _alarmTimeString);
                                      onSaveAlarm(false);
                                    },
                                    icon: const Icon(Icons.alarm),
                                    label: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(AppColors.skyColor),
                    fontSize: 16,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
