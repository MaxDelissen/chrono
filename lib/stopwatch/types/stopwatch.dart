import 'package:clock_app/common/types/timer_state.dart';
import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/common/utils/json_serialize.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class ClockStopwatch extends JsonSerializable {
  int _elapsedMillisecondsOnPause;
  DateTime _startTime;
  TimerState _state;
  final int _id;
  List<Lap> _laps = [];
  Lap? _fastestLap;
  Lap? _slowestLap;

  int get id => _id;
  List<Lap> get laps => _laps;
  int get elapsedMilliseconds => _state == TimerState.running
      ? DateTime.now().difference(_startTime).toTimeDuration().inMilliseconds
      : _elapsedMillisecondsOnPause;
  bool get isRunning => _state == TimerState.running;
  bool get isStarted =>
      _state == TimerState.running || _state == TimerState.paused;
  TimerState get state => _state;
  TimeDuration get currentLapTime =>
      TimeDuration.fromMilliseconds(elapsedMilliseconds -
          (_laps.isNotEmpty ? _laps.first.elapsedTime.inMilliseconds : 0));
  Lap? get previousLap => _laps.isNotEmpty ? _laps.first : null;
  Lap? get fastestLap => _fastestLap;
  Lap? get slowestLap => _slowestLap;
  Lap? get averageLap {
    if (_laps.isEmpty) return null;
    var totalMilliseconds = _laps.fold(
        0, (previousValue, lap) => previousValue + lap.lapTime.inMilliseconds);
    return Lap(
      elapsedTime:
          TimeDuration.fromMilliseconds(totalMilliseconds ~/ _laps.length),
      number: _laps.length + 1,
      lapTime: TimeDuration.fromMilliseconds(totalMilliseconds ~/ _laps.length),
    );
  }

  ClockStopwatch()
      : _id = UniqueKey().hashCode,
        _elapsedMillisecondsOnPause = 0,
        _startTime = DateTime(0),
        _state = TimerState.stopped;

  ClockStopwatch.fromStopwatch()
      : _elapsedMillisecondsOnPause = 0,
        _startTime = DateTime(0),
        _state = TimerState.stopped,
        _id = UniqueKey().hashCode;

  void start() {
    if (_state == TimerState.stopped) {
      _startTime = DateTime.now();
    } else if (_state == TimerState.paused) {
      _startTime = DateTime.now()
          .subtract(Duration(milliseconds: _elapsedMillisecondsOnPause));
    }
    _state = TimerState.running;
  }

  void pause() {
    _elapsedMillisecondsOnPause =
        DateTime.now().difference(_startTime).toTimeDuration().inMilliseconds;
    _state = TimerState.paused;
  }

  void reset() {
    _state = TimerState.stopped;
    _elapsedMillisecondsOnPause = 0;
    _laps = [];
    _fastestLap = null;
    _slowestLap = null;
  }

  void toggleState() {
    if (state == TimerState.running) {
      pause();
    } else {
      start();
    }
  }

  void updateFastestAndSlowestLap() {
    // print("update");
    _fastestLap = _laps.reduce((value, element) =>
        value.lapTime.inMilliseconds < element.lapTime.inMilliseconds
            ? value
            : element);
    _slowestLap = _laps.reduce((value, element) =>
        value.lapTime.inMilliseconds > element.lapTime.inMilliseconds
            ? value
            : element);
  }

  void addLap() {
    _laps.insert(0, getLap());
    updateFastestAndSlowestLap();
  }

  Lap getLap() {
    return Lap(
      elapsedTime: TimeDuration.fromMilliseconds(elapsedMilliseconds),
      number: _laps.length + 1,
      lapTime: currentLapTime,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      '_elapsedMillisecondsOnPause': _elapsedMillisecondsOnPause,
      'startTime': _startTime.toIso8601String(),
      'state': _state.toString(),
      'laps': _laps.map((e) => e.toJson()).toList(),
    };
  }

  ClockStopwatch.fromJson(Map<String, dynamic> json)
      : _elapsedMillisecondsOnPause = json['_elapsedMillisecondsOnPause'],
        _startTime = DateTime.parse(json['startTime']),
        _state =
            TimerState.values.firstWhere((e) => e.toString() == json['state']),
        _id = json['id'],
        _laps = (json['laps'] as List).map((e) => Lap.fromJson(e)).toList();
}
