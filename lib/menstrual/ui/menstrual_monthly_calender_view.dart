import 'package:flutter/material.dart';

import '../menstrual_cycle_widget_base.dart';
import '../utils/menstrual_cycle_utils.dart';
import 'calender_view/calender_view.dart';

class MenstrualCycleMonthlyCalenderView extends StatefulWidget {
  final Color? themeColor;
  final Color? daySelectedColor;
  final bool hideInfoView;
  final bool isShowCloseIcon;
  final Function? onDataChanged;

  const MenstrualCycleMonthlyCalenderView(
      {super.key,
      this.themeColor = Colors.black,
      this.daySelectedColor,
      this.isShowCloseIcon = false,
      this.onDataChanged,
      this.hideInfoView = false});

  @override
  State<MenstrualCycleMonthlyCalenderView> createState() =>
      _MenstrualCycleMonthlyCalenderViewState();
}

class _MenstrualCycleMonthlyCalenderViewState
    extends State<MenstrualCycleMonthlyCalenderView> {
  final _instance = MenstrualCycleWidget.instance!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          (isArabicLanguage()) ? TextDirection.rtl : TextDirection.ltr,
      child: CalenderMonthlyView(
          themeColor: widget.themeColor!,
          selectedColor: (widget.daySelectedColor != null)
              ? widget.daySelectedColor
              : Colors.grey,
          cycleLength: _instance.getCycleLength(),
          periodLength: _instance.getPeriodDuration(),
          isFromCalender: widget.isShowCloseIcon,
          onDataChanged: (value) {
            widget.onDataChanged!.call(value);
          },
          hideInfoView: widget.hideInfoView),
    );
  }
}
