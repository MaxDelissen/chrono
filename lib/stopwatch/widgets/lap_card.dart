import 'package:clock_app/stopwatch/types/lap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LapCard extends StatefulWidget {
  const LapCard({super.key, required this.lap, this.onInit});

  final Lap lap;
  final VoidCallback? onInit;

  @override
  State<LapCard> createState() => _LapCardState();
}

class _LapCardState extends State<LapCard> {
  @override
  void initState() {
    super.initState();
    // widget.onInit?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text('${widget.lap.number}'),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.lap.lapTime.toTimeString(showMilliseconds: true),
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                  '${AppLocalizations.of(context)!.elapsedTime}: ${widget.lap.elapsedTime.toTimeString(showMilliseconds: true)}'),
            ],
          ),
        ],
      ),
    );
  }
}
