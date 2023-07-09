import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';

class SelectTextOptionCard extends StatelessWidget {
  const SelectTextOptionCard({
    Key? key,
    required this.selectedIndex,
    required this.choice,
    required this.index,
    required this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final SelectChoice choice;
  final int index;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(index),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: choice.description.isNotEmpty ? 8.0 : 2.0),
          child: Row(
            children: [
              Radio(
                value: index,
                groupValue: selectedIndex,
                onChanged: (dynamic value) => onSelect(index),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(choice.name,
                      style: Theme.of(context).textTheme.headlineMedium),
                  if (choice.description.isNotEmpty)
                    const SizedBox(height: 4.0),
                  if (choice.description.isNotEmpty)
                    Text(choice.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
