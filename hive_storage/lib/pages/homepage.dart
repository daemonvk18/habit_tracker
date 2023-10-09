import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_storage/components/monthly_summary.dart';
import 'package:hive_storage/data/habit_database.dart';

import '../components/habittile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //textediting controller
  final _controller = TextEditingController();

  HabitDataBase db = HabitDataBase();
  final _Mybox = Hive.box("DataBase");

  @override
  void initState() {
    //if it the first time we are opening the app then check if there is some data or not
    //then create the data
    if (_Mybox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }
    //if it is not the first time we are openin the app we will load the data
    else {
      db.loadData();
    }

    //update the database
    db.updateData();

    super.initState();
  }

  //method when the checkbox ist tapped
  void Boxtapped(bool? value, int index) {
    setState(() {
      db.HabitList[index][1] = value!;
    });
    db.updateData();
  }

  //addmethod to save the new habit
  void Addmethod() {
    setState(() {
      db.HabitList.add([_controller.text, false]);
    });
    _controller.clear();
    Navigator.of(context).pop();

    db.updateData();
  }

  //method to save the existing habit
  void saveHabit(int index) {
    setState(() {
      db.HabitList[index][0] = _controller.text;
    });
    _controller.clear();
    Navigator.of(context).pop();
    db.updateData();
  }

  //method to delete the habit
  void deleteHabit(int index) {
    setState(() {
      db.HabitList.removeAt(index);
    });
    db.updateData();
  }

  //open the habit settings
  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            title: Text(
              "Settings",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "code....",
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.grey.shade800,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "cancel",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextButton(
                onPressed: () => saveHabit(index),
                child: Text(
                  "save",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              )
            ],
          );
        });
  }

  //give the access to the user to create his own habit
  void CreateNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            title: Text("New Habit"),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "excercise...",
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.grey.shade800,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _controller.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel")),
              TextButton(onPressed: Addmethod, child: Text("Add"))
            ],
          );
        });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          //monthly summary heat map
          MonthlySummary(
              datasets: db.heatMapDataSet, startDate: _Mybox.get("START_DATE")),

          //list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: db.HabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitname: db.HabitList[index][0],
                habitcompleted: db.HabitList[index][1],
                onChanged: (value) => Boxtapped(value, index),
                settingsTapped: (value) => openHabitSettings(index),
                deleteTapped: (value) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: CreateNewHabit,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
