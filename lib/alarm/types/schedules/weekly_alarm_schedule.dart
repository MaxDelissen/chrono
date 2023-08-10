import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/alarm/logic/alarm_time.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/time.dart';
import 'package:clock_app/common/types/weekday.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/foundation.dart';

class WeekdaySchedule extends JsonSerializable {
  int weekday;
  AlarmRunner alarmRunner;

  WeekdaySchedule(this.weekday) : alarmRunner = AlarmRunner();

  WeekdaySchedule.fromJson(Json json)
      : weekday = json['weekday'],
        alarmRunner = AlarmRunner.fromJson(json['alarmRunner']);

  @override
  Json toJson() => {
        'weekday': weekday,
        'alarmRunner': alarmRunner.toJson(),
      };
}

class WeeklyAlarmSchedule extends AlarmSchedule {
  List<WeekdaySchedule> _weekdaySchedules = [];
  final ToggleSetting<int> _weekdaySetting;

  @override
  bool get isDisabled => false;

  @override
  bool get isFinished => false;

  List<Weekday> get scheduledWeekdays {
    return _weekdaySetting.selected
        .map((weekdayId) =>
            weekdays.firstWhere((weekday) => weekday.id == weekdayId))
        .toList();
  }

  WeekdaySchedule get nextWeekdaySchedule {
    if (_weekdaySchedules.isEmpty) return WeekdaySchedule(0);
    return _weekdaySchedules.reduce((a, b) => a
            .alarmRunner.currentScheduleDateTime!
            .isBefore(b.alarmRunner.currentScheduleDateTime!)
        ? a
        : b);
  }

  @override
  DateTime? get currentScheduleDateTime =>
      nextWeekdaySchedule.alarmRunner.currentScheduleDateTime;

  @override
  int get currentAlarmRunnerId => nextWeekdaySchedule.alarmRunner.id;

  WeeklyAlarmSchedule(Setting weekdaySetting)
      : _weekdaySetting = weekdaySetting as ToggleSetting<int>,
        super();

  @override
  Future<bool> schedule(Time time) async {
    for (WeekdaySchedule weekdaySchedule in _weekdaySchedules) {
      weekdaySchedule.alarmRunner.cancel();
    }

    List<int> weekdays = _weekdaySetting.selected.toList();
    List<int> existingWeekdays =
        _weekdaySchedules.map((schedule) => schedule.weekday).toList();

    if (!listEquals(weekdays, existingWeekdays)) {
      _weekdaySchedules =
          weekdays.map((weekday) => WeekdaySchedule(weekday)).toList();
    }

    for (WeekdaySchedule weekdaySchedule in _weekdaySchedules) {
      DateTime alarmDate = getWeeklyAlarmDate(time, weekdaySchedule.weekday);
      weekdaySchedule.alarmRunner.schedule(alarmDate);
    }

    return true;
  }

  @override
  void cancel() {
    for (WeekdaySchedule weekday in _weekdaySchedules) {
      weekday.alarmRunner.cancel();
    }
  }

  @override
  toJson() {
    return {
      'weekdaySchedules': _weekdaySchedules.map((e) => e.toJson()).toList(),
    };
  }

  WeeklyAlarmSchedule.fromJson(Json json, Setting weekdaySetting)
      : _weekdaySchedules = (json['weekdaySchedules'] as List)
            .map((e) => WeekdaySchedule.fromJson(e))
            .toList(),
        _weekdaySetting = weekdaySetting as ToggleSetting<int>,
        super();

  @override
  bool hasId(int id) {
    return _weekdaySchedules
        .any((weekdaySchedule) => weekdaySchedule.alarmRunner.id == id);
  }

  @override
  List<AlarmRunner> get alarmRunners =>
      _weekdaySchedules.map((e) => e.alarmRunner).toList();
}
