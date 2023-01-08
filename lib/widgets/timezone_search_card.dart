import 'package:clock_app/types/time.dart';
import 'package:clock_app/widgets/clock.dart';
import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart' as timezone;

import 'package:clock_app/types/city.dart';

class TimeZoneSearchCard extends StatelessWidget {
  TimeZoneSearchCard({
    Key? key,
    required this.city,
    required this.onTap,
  }) : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timezone);
  }

  late final timezone.Location timezoneLocation;
  final City city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name.replaceAll('', '\u{200B}'),
                        style: Theme.of(context).textTheme.displaySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Text(
                        city.country,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Clock(
                    timezoneLocation: timezoneLocation,
                    scale: 0.3,
                    timeFormat: TimeFormat.H24,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
