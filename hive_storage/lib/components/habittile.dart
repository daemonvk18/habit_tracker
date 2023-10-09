import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  const HabitTile(
      {super.key,
      required this.habitname,
      required this.habitcompleted,
      required this.onChanged,
      required this.deleteTapped,
      required this.settingsTapped});
  final String habitname;
  final bool habitcompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 21.0),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          //options after sliding

          //1)settings option
          SlidableAction(
            onPressed: settingsTapped,
            backgroundColor: Colors.yellow,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(10),
          ),

          //2)delete option
          SlidableAction(
            onPressed: deleteTapped,
            backgroundColor: Colors.blue,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(10),
          ),
        ]),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              //checkbox
              Checkbox(value: habitcompleted, onChanged: onChanged),
              //habit name
              Text(habitname),
            ],
          ),
          decoration: BoxDecoration(
              color: (habitcompleted) ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
