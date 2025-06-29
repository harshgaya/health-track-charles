import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../menstrual_cycle_widget.dart';
import '../widget_languages/languages.dart';
import 'calender_view/calender_view.dart';
import 'text_style/custom_text_style.dart';

class MenstrualCycleCalenderView extends StatefulWidget {
  final Color? daySelectedColor;
  final String? logPeriodText;
  final Color? themeColor;
  final Color? backgroundColorCode;
  final bool? hideInfoView;
  final bool? hideBottomBar;
  final bool? hideLogPeriodButton;
  final bool? isExpanded;
  final Function? onDateSelected;
  final Function? onDataChanged;

  const MenstrualCycleCalenderView(
      {super.key,
      this.daySelectedColor,
      this.themeColor = Colors.black,
      this.backgroundColorCode = Colors.white,
      this.logPeriodText,
      this.hideLogPeriodButton = false,
      this.hideBottomBar = false,
      this.onDateSelected,
      this.onDataChanged,
      this.isExpanded = false,
      this.hideInfoView = false});

  @override
  State<MenstrualCycleCalenderView> createState() =>
      _MenstrualCycleCalenderViewState();
}

class _MenstrualCycleCalenderViewState
    extends State<MenstrualCycleCalenderView> {
  List<DateTime>? selectedMonthsDays;
  List<DateTime>? selectedWeekDays;
  DateTime _selectedDateTime = DateTime.now();
  String? currentMonth;
  bool isExpanded = false;
  String displayMonth = "";
  String today = "";
  DateTime _selectedDate = DateTime.now();
  bool isExpandable = true;

  DateTime get selectedDateTime => _selectedDateTime;
  final _instance = MenstrualCycleWidget.instance!;

  List<String> futurePeriodDays = [];
  List<String> futureOvulationDays = [];
  List<String>? pastAllPeriodsDays = [];

  List<String> weekTitles = [];

  Color? selectedColor = Colors.grey;
  String _logPeriodText = WidgetBaseLanguage.logPeriodLabel;

  @override
  void initState() {
    super.initState();
    weekTitles = getWeekTitle();
    _selectedDateTime = DateTime.now();
    selectedMonthsDays = _daysInMonth(selectedDateTime);
    selectedWeekDays = CalenderDateUtils.daysInRange(
            _firstDayOfWeek(selectedDateTime), _lastDayOfWeek(selectedDateTime))
        .toList();
    initializeDateFormatting("en_US", null).then((_) => setState(() {
          var monthFormat = CalenderDateUtils.formatDayMonth(selectedDateTime);
          displayMonth =
              "${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}";
          var todayFormat = CalenderDateUtils.formatDay(selectedDateTime);
          today = todayFormat;
        }));

    if (widget.logPeriodText != null && widget.logPeriodText!.isNotEmpty) {
      _logPeriodText = widget.logPeriodText!;
    }
    init();
  }

  getWeekTitle() {
    return [
      WidgetBaseLanguage.weekTitlesSun,
      WidgetBaseLanguage.weekTitlesMon,
      WidgetBaseLanguage.weekTitlesTue,
      WidgetBaseLanguage.weekTitlesWed,
      WidgetBaseLanguage.weekTitlesThu,
      WidgetBaseLanguage.weekTitlesFri,
      WidgetBaseLanguage.weekTitlesSat,
    ];
  }

  init() async {
    selectedColor = (widget.daySelectedColor != null)
        ? widget.daySelectedColor
        : Colors.grey;
    _instance.calculateLastPeriodDate();
    pastAllPeriodsDays = _instance.pastAllPeriodDays;
    futurePeriodDays = await initFuturePeriodDay();
    futureOvulationDays = await initFutureOvulationDay();
    setState(() {});
  }

  Widget calendarGridView() {
    return SimpleGestureDetector(
      onSwipeUp: _onSwipeUp,
      onSwipeDown: _onSwipeDown,
      onSwipeLeft: _onSwipeLeft,
      onSwipeRight: _onSwipeRight,
      swipeConfig: const SimpleSwipeConfig(
        verticalThreshold: 10.0,
        horizontalThreshold: 40.0,
        swipeDetectionMoment: SwipeDetectionMoment.onUpdate,
      ),
      child: Column(children: <Widget>[
        GridView.count(
          childAspectRatio: 1.5,
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 7,
          padding: const EdgeInsets.only(bottom: 0.0),
          children: calendarBuilder(),
        ),
      ]),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];

    // Add weekday headers
    _addWeekdayHeaders(dayWidgets);

    // Generate calendar days
    _addCalendarDays(dayWidgets);

    return dayWidgets;
  }

// Helper method to add weekday headers
//   void _addWeekdayHeaders(List<Widget> dayWidgets) {
//     for (var day in weekTitles) {
//       dayWidgets.add(
//         CalendarCell(
//           themeColor: widget.themeColor!,
//           selectedColor: selectedColor,
//           todayColor: defaultMenstruationColor,
//           isDayOfWeek: true,
//           dayOfWeek: day,
//           multipleDateSelectionCallBack: () {},
//           dayOfWeekStyle: TextStyle(
//             fontFamily: getFontFamily(),
//             color: Color(AppColors.pinkColor),
//             fontWeight: FontWeight.w800,
//             fontSize: 11,
//           ),
//         ),
//       );
//     }
//   }

  void _addWeekdayHeaders(List<Widget> dayWidgets) {
    DateTime today = _normalizeDay(DateTime.now());

    List<String> weekdayNames = List.generate(7, (index) {
      DateTime date = today.add(Duration(days: index - 3));
      return _getWeekdayLabel(date);
    });

    for (var day in weekdayNames) {
      dayWidgets.add(
        CalendarCell(
          themeColor: widget.themeColor!,
          selectedColor: selectedColor,
          todayColor: defaultMenstruationColor,
          isDayOfWeek: true,
          dayOfWeek: day,
          multipleDateSelectionCallBack: () {},
          dayOfWeekStyle: TextStyle(
            fontFamily: getFontFamily(),
            color: Color(AppColors.pinkColor),
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      );
    }
  }

  String _getWeekdayLabel(DateTime date) {
    const weekTitles = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekTitles[date.weekday % 7]; // Sunday=0
  }

  void _addCalendarDays(List<Widget> dayWidgets) {
    // Today's date
    DateTime today = _normalizeDay(DateTime.now());

    // Create list of 7 days: 3 before today, today, 3 after
    List<DateTime> calendarDays = List.generate(7, (index) {
      int offset = index - 3; // -3 to +3
      return _normalizeDay(today.add(Duration(days: offset)));
    });

    for (var day in calendarDays) {
      bool isToday = CalenderDateUtils.isSameDay(day, today);

      dayWidgets.add(
        CalendarCell(
          themeColor: widget.themeColor!,
          selectedColor: selectedColor,
          todayColor: defaultMenstruationColor,
          onDateSelected: () => handleSelectedDateCallback(day),
          currentDay: day,
          multipleDateSelectionCallBack: () {},
          previousPeriodDate: _instance.getPreviousPeriodDay(),
          pastAllPeriodsDays: pastAllPeriodsDays,
          futurePeriodDays: futurePeriodDays,
          futureOvulationDays: futureOvulationDays,
          cycleLength: _instance.getCycleLength(),
          periodDuration: _instance.getPeriodDuration(),
          dateStyles: configureDateStyle(false, false),
          isSelected: CalenderDateUtils.isSameDay(_selectedDate, day),
        ),
      );
    }
  }

// Helper method to add calendar days
//   void _addCalendarDays(List<Widget> dayWidgets) {
//     List<DateTime>? calendarDays =
//         isExpanded ? selectedMonthsDays : selectedWeekDays;
//
//     bool monthStarted = false;
//     bool monthEnded = false;
//
//     for (var day in calendarDays!) {
//       day = CalenderDateUtils.getDay(day);
//
//       // Normalize time to the start of the day
//       day = _normalizeDay(day);
//
//       // Update month boundary flags
//       if (monthStarted && day.day == 1) {
//         monthEnded = true;
//       }
//       if (CalenderDateUtils.isFirstDayOfMonth(day)) {
//         monthStarted = true;
//       }
//
//       dayWidgets.add(
//         CalendarCell(
//           themeColor: widget.themeColor!,
//           selectedColor: selectedColor,
//           todayColor: defaultMenstruationColor,
//           onDateSelected: () => handleSelectedDateCallback(day),
//           currentDay: day,
//           multipleDateSelectionCallBack: () {},
//           previousPeriodDate: _instance.getPreviousPeriodDay(),
//           pastAllPeriodsDays: pastAllPeriodsDays,
//           futurePeriodDays: futurePeriodDays,
//           futureOvulationDays: futureOvulationDays,
//           cycleLength: _instance.getCycleLength(),
//           periodDuration: _instance.getPeriodDuration(),
//           dateStyles: configureDateStyle(monthStarted, monthEnded),
//           isSelected: CalenderDateUtils.isSameDay(_selectedDate, day),
//         ),
//       );
//     }
//   }

// Helper to normalize day to the start of the day
  DateTime _normalizeDay(DateTime day) {
    if (day.hour > 0) {
      day = day.toLocal();
      day = day.subtract(Duration(hours: day.hour));
    }
    return day;
  }

  /*List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime>? calendarDays =
        isExpanded ? selectedMonthsDays : selectedWeekDays;

    for (var day in weekTitles) {
      dayWidgets.add(
        CalendarCell(
          themeColor: widget.themeColor!,
          selectedColor: selectedColor,
          todayColor: defaultMenstruationColor,
          isDayOfWeek: true,
          dayOfWeek: day,
          multipleDateSelectionCallBack: () {},
          dayOfWeekStyle: TextStyle(
              color: widget.themeColor,
              fontWeight: FontWeight.w800,
              fontSize: 11),
        ),
      );
    }

    bool monthStarted = false;
    bool monthEnded = false;

    for (var day in calendarDays!) {
      day = CalenderDateUtils.getDay(day);
      if (day.hour > 0) {
        day = day.toLocal();
        day = day.subtract(Duration(hours: day.hour));
      }

      if (monthStarted && day.day == 01) {
        monthEnded = true;
      }

      if (CalenderDateUtils.isFirstDayOfMonth(day)) {
        monthStarted = true;
      }

      dayWidgets.add(
        CalendarCell(
          themeColor: widget.themeColor!,
          selectedColor: selectedColor,
          todayColor: defaultMenstruationColor,
          onDateSelected: () => handleSelectedDateCallback(day),
          currentDay: day,
          multipleDateSelectionCallBack: () {},
          previousPeriodDate: _instance.getPreviousPeriodDay(),
          pastAllPeriodsDays: pastAllPeriodsDays,
          futurePeriodDays: futurePeriodDays,
          futureOvulationDays: futureOvulationDays,
          cycleLength: _instance.getCycleLength(),
          periodDuration: _instance.getPeriodDuration(),
          dateStyles: configureDateStyle(monthStarted, monthEnded),
          isSelected: CalenderDateUtils.isSameDay(_selectedDate, day),
        ),
      );
    }
    return dayWidgets;
  }*/

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle? dateStyles;
    TextStyle normalTextStyle = TextStyle(
      color: widget.themeColor,
      fontWeight: FontWeight.normal,
      fontFamily: getFontFamily(),
    );

    if (isExpanded) {
      final TextStyle body1StyleDisabled =
          normalTextStyle.copyWith(color: Colors.grey);
      dateStyles =
          monthStarted && !monthEnded ? normalTextStyle : body1StyleDisabled;
    } else {
      dateStyles = normalTextStyle;
    }
    return dateStyles;
  }

  Widget bottomView() {
    if (isExpandable) {
      return GestureDetector(
        onTap: toggleExpanded,
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: widget.backgroundColorCode ?? Colors.black12,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (widget.hideLogPeriodButton!)
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MenstrualCycleMonthlyCalenderView(
                              themeColor: widget.themeColor,
                              hideInfoView: widget.hideInfoView!,
                              isShowCloseIcon: true,
                              onDataChanged: (value) {},
                            ),
                          ),
                        )
                            .then((value) {
                          if (value) {
                            //printLogs(("onDataChanged from calender---- 2");
                            init();
                          }
                          widget.onDataChanged!.call(value);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: 1.0, color: widget.themeColor!),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            _logPeriodText,
                            style: TextStyle(
                              color: widget.themeColor!,
                              fontSize: 8,
                              fontFamily: getFontFamily(),
                            ),
                          ),
                        ),
                      ),
                    ),
              Text(
                CalenderDateUtils.fullFormat.format(selectedDateTime),
                style: TextStyle(
                  fontSize: 13,
                  color: widget.themeColor!,
                  fontFamily: getFontFamily(),
                ),
              ),
              IconButton(
                onPressed: toggleExpanded,
                iconSize: 25.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                icon: isExpanded
                    ? Icon(
                        Icons.arrow_drop_up,
                        color: widget.themeColor!,
                      )
                    : Icon(
                        Icons.arrow_drop_down,
                        color: widget.themeColor!,
                      ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return Directionality(
      textDirection:
          (isArabicLanguage()) ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: widget.backgroundColorCode,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ExpansionCrossFade(
                collapsed: calendarGridView(),
                expanded: calendarGridView(),
                isExpanded: isExpanded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetToToday() {
    _selectedDateTime = DateTime.now();
    var firstDayOfCurrentWeek = _firstDayOfWeek(selectedDateTime);
    var lastDayOfCurrentWeek = _lastDayOfWeek(selectedDateTime);

    setState(() {
      selectedWeekDays = CalenderDateUtils.daysInRange(
              firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      selectedMonthsDays = _daysInMonth(selectedDateTime);
      var monthFormat = CalenderDateUtils.formatDayMonth(selectedDateTime);

      displayMonth =
          "${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}";
      var todayFormat = CalenderDateUtils.formatDay(selectedDateTime);

      today = todayFormat;
    });

    // _launchDateSelectionCallback(selectedDateTime);
  }

  void nextMonth() {
    setState(() {
      _selectedDateTime = CalenderDateUtils.nextMonth(selectedDateTime);
      var firstDateOfNewMonth =
          CalenderDateUtils.firstDayOfMonth(selectedDateTime);
      var lastDateOfNewMonth =
          CalenderDateUtils.lastDayOfMonth(selectedDateTime);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = _daysInMonth(selectedDateTime);
      var monthFormat = CalenderDateUtils.formatMonth(selectedDateTime);
      displayMonth =
          "${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}";
    });
    // _launchDateSelectionCallback(selectedDateTime);
  }

  void previousMonth() {
    setState(() {
      _selectedDateTime = CalenderDateUtils.previousMonth(selectedDateTime);
      var firstDateOfNewMonth =
          CalenderDateUtils.firstDayOfMonth(selectedDateTime);
      var lastDateOfNewMonth =
          CalenderDateUtils.lastDayOfMonth(selectedDateTime);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = _daysInMonth(selectedDateTime);
      var monthFormat = CalenderDateUtils.formatMonth(selectedDateTime);

      displayMonth =
          "${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}";
    });
    // _launchDateSelectionCallback(selectedDateTime);
  }

  void nextWeek() {
    setState(() {
      _selectedDateTime = CalenderDateUtils.nextWeek(selectedDateTime);
      var firstDayOfCurrentWeek = _firstDayOfWeek(selectedDateTime);
      var lastDayOfCurrentWeek = _lastDayOfWeek(selectedDateTime);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeekDays = CalenderDateUtils.daysInRange(
              firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      var monthFormat = CalenderDateUtils.formatMonth(selectedDateTime);

      displayMonth =
          "${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}";
    });
    // _launchDateSelectionCallback(selectedDateTime);
  }

  void previousWeek() {
    setState(() {
      _selectedDateTime = CalenderDateUtils.previousWeek(selectedDateTime);
      var firstDayOfCurrentWeek = _firstDayOfWeek(selectedDateTime);
      var lastDayOfCurrentWeek = _lastDayOfWeek(selectedDateTime);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeekDays = CalenderDateUtils.daysInRange(
              firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      var monthFormat = CalenderDateUtils.formatMonth(selectedDateTime);

      displayMonth =
          "${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}";
    });
    //  _launchDateSelectionCallback(selectedDateTime);
  }

  void updateSelectedRange(DateTime start, DateTime end) {}

  void _onSwipeUp() {
    if (isExpanded) toggleExpanded();
  }

  void _onSwipeDown() {
    if (!isExpanded) toggleExpanded();
  }

  void _onSwipeRight() {
    if (isExpanded) {
      //previousMonth();
    } else {
      //previousWeek();
    }
  }

  void _onSwipeLeft() {
    if (isExpanded) {
      //nextMonth();
    } else {
      //nextWeek();
    }
  }

  void toggleExpanded() {
    if (isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateCallback(DateTime day) {
    var firstDayOfCurrentWeek = _firstDayOfWeek(day);
    var lastDayOfCurrentWeek = _lastDayOfWeek(day);
    if (selectedDateTime.month > day.month) {
      previousMonth();
    }
    if (selectedDateTime.month < day.month) {
      nextMonth();
    }
    setState(() {
      _selectedDate = day;
      selectedWeekDays = CalenderDateUtils.daysInRange(
              firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      selectedMonthsDays = _daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(day);
    }
    /* if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(day);
    }*/
  }

  _firstDayOfWeek(DateTime date) {
    var day = DateTime.utc(selectedDateTime.year, selectedDateTime.month,
        selectedDateTime.day, 12);
    return day.subtract(Duration(days: day.weekday));
  }

  _lastDayOfWeek(DateTime date) {
    return _firstDayOfWeek(date).add(const Duration(days: 7));
  }

  List<DateTime> _daysInMonth(DateTime month) {
    var first = CalenderDateUtils.firstDayOfMonth(month);
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(Duration(days: daysBefore));
    var last = CalenderDateUtils.lastDayOfMonth(month);

    var daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(Duration(days: daysAfter));
    return CalenderDateUtils.daysInRange(firstToDisplay, lastToDisplay)
        .toList();
  }
}
