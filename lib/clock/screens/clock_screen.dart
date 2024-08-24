import 'package:clock_app/clock/screens/search_city_screen.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:clock_app/common/widgets/clock/clock.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/types/alignment.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  bool shouldShowSeconds = false;
  late Setting showSecondsSetting;

  final _listController = PersistentListController<City>();

  void setShowSeconds(dynamic value) {
    setState(() {
      shouldShowSeconds = value;
    });
  }

  @override
  void initState() {
    super.initState();
    showSecondsSetting = appSettings
        .getGroup("General")
        .getGroup("Display")
        .getSetting("Show Seconds");
    setShowSeconds(showSecondsSetting.value);
    showSecondsSetting.addListener(setShowSeconds);
  }

  @override
  void dispose() {
    showSecondsSetting.removeListener(setShowSeconds);
    super.dispose();
  }

  void _handleSearchReturn(dynamic city) {
    if (city != null) {
      _listController.addItem(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Clock(
            shouldShowDate: true,
            shouldShowSeconds: shouldShowSeconds,
            horizontalAlignment: ElementAlignment.center,
          ),
        ),
        // const SizedBox(height: 8),
        Expanded(
          child: PersistentListView<City>(
            saveTag: 'favorite_cities',
            listController: _listController,
            itemBuilder: (city) => TimeZoneCard(
                city: city,
                onDelete: () => _listController.deleteItem(city)),
            placeholderText: "No cities added",
            isDuplicateEnabled: false,
            isSelectable: true,
          ),
        ),
      ]),
      FAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchCityScreen()),
          ).then(_handleSearchReturn);
        },
      )
    ]);
  }
}
