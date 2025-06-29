import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../helpers/colors.dart';
import 'dart:io';

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

  @override
  void initState() {
    _alarmTime = DateTime.now();
    mainController.getBedTime().then((value) {
      bedTimeString = value['bedTime']!;
      _alarmTimeString = value['alarmTime']!;
      setState(() {});
    });

    super.initState();
  }

  void setAlarm() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final res = await Permission.notification.request();
    }
    DateTime now = DateTime.now();
    DateTime alarmTime = _alarmTime!;
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }
    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: _alarmTime!,
      assetAudioPath: 'assets/marimba.mp3',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: Duration(seconds: 5),
        volumeEnforced: true,
      ),
      notificationSettings: const NotificationSettings(
        title: 'Wake Up',
        body: 'Make your health',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
        iconColor: Color(0xff862778),
      ),
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  void deleteAlarm() {
    Alarm.stop(42).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0xFFEEEEEE)
              : Colors.black),
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
                  Text(
                    'Bed time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
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
                  Text(
                    'Wake up',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
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
                Utils.convertToAmPm(bedTimeString),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              Text(
                Utils.convertToAmPm(_alarmTimeString),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tonight',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              Text(
                'Tomorrow',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : const Color(AppColors.lineColor),
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
                                      setAlarm();
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.alarm),
                                    label: const Text('Save'),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                      onPressed: deleteAlarm,
                                      child: Text(
                                        'Delete Alarm',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Color(AppColors.appButtonColorDarkMode)
                        : Color(AppColors.skyColor),
                    fontSize: 16,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
