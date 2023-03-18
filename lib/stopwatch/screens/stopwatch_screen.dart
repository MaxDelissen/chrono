import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/linear_progress_bar.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:clock_app/stopwatch/types/stopwatch.dart';
import 'package:clock_app/stopwatch/widgets/lap_card.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:timer_builder/timer_builder.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final _listController = ListController<Lap>();

  late final ClockStopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = loadListSync<ClockStopwatch>('stopwatches').first;
  }

  void _handleReset() {
    setState(() {
      _stopwatch.pause();
      _stopwatch.reset();
    });
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleAddLap() {
    if (_stopwatch.currentLapTime.inMilliseconds == 0) return;
    _listController.addItem(_stopwatch.getLap());
    saveList('stopwatches', [_stopwatch]);
  }

  void _handleToggleState() {
    setState(() {
      _stopwatch.toggleState();
    });
    saveList('stopwatches', [_stopwatch]);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimerBuilder.periodic(const Duration(milliseconds: 30),
                builder: (context) {
              // print(_stopwatch.fastestLap?.lapTime.toTimeString());
              // print(_stopwatch.slowestLap?.lapTime.toTimeString());
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TimeDuration.fromMilliseconds(
                                _stopwatch.elapsedMilliseconds)
                            .toTimeString(showMilliseconds: true),
                        style: const TextStyle(fontSize: 48.0),
                      ),
                      const SizedBox(height: 8),
                      LapComparer(
                        stopwatch: _stopwatch,
                        comparisonLap: _stopwatch.previousLap,
                        label: "Previous",
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 4),
                      LapComparer(
                        stopwatch: _stopwatch,
                        comparisonLap: _stopwatch.fastestLap,
                        label: "Fastest",
                        color: Colors.red,
                      ),
                      const SizedBox(height: 4),
                      LapComparer(
                        stopwatch: _stopwatch,
                        comparisonLap: _stopwatch.slowestLap,
                        label: "Slowest",
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Expanded(
              child: CustomListView<Lap>(
                items: _stopwatch.laps,
                listController: _listController,
                itemBuilder: (lap) => LapCard(
                  key: ValueKey(lap),
                  lap: lap,
                ),
                placeholderText: "No laps yet",
                isDeleteEnabled: false,
                isDuplicateEnabled: false,
                isReorderable: false,
                onAddItem: (lap) => _stopwatch.updateFastestAndSlowestLap(),
              ),
            ),
          ],
        ),
        FAB(
          onPressed: _handleToggleState,
          icon: _stopwatch.isRunning
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
        ),
        if (_stopwatch.isStarted)
          FAB(
            index: 1,
            onPressed: _handleAddLap,
            icon: Icons.flag_rounded,
          ),
        if (_stopwatch.isStarted)
          FAB(
            index: 2,
            onPressed: _handleReset,
            icon: Icons.refresh_rounded,
          ),
      ],
    );
  }
}

class LapComparer extends StatelessWidget {
  const LapComparer({
    super.key,
    required ClockStopwatch stopwatch,
    required this.comparisonLap,
    required this.label,
    this.color = Colors.green,
  }) : _stopwatch = stopwatch;

  final Lap? comparisonLap;
  final ClockStopwatch _stopwatch;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LinearProgressBar(
          minHeight: 14,
          value: _stopwatch.currentLapTime.inMilliseconds /
              (comparisonLap?.lapTime.inMilliseconds ?? double.infinity),
          backgroundColor: Colors.black.withOpacity(0.25),
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 1.0, left: 4.0, right: 4.0),
          child: Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
              const Spacer(),
              Text(
                  comparisonLap != null
                      ? 'Lap ${comparisonLap?.number}: ${comparisonLap?.lapTime.toTimeString(showMilliseconds: true)}'
                      : '',
                  style: const TextStyle(fontSize: 10.0, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
