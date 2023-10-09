import 'package:hive/hive.dart';
import 'package:hive_storage/date_time/datetime.dart';

//refernce the opened box(database)
final _Mybox = Hive.box("DataBase");

class HabitDataBase {
  List HabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //create an initial default data
  void createDefaultData() {
    HabitList = [
      ["Morning Run", false],
      ["Code App", false],
      ["Read Book", false]
    ];
    _Mybox.put("START_DATE", todaysDateFormatted());
  }

  //load the data if already there in the data base
  void loadData() {
    //if it is a new day,we want to get the current habit list
    if (_Mybox.get(todaysDateFormatted()) == null) {
      HabitList = _Mybox.get("CURRENT_HABIT_LIST");
      //as it is a new day we need to set all of the habits to false
      for (int i = 0; i < HabitList.length; i++) {
        HabitList[i][1] = false;
      }
    }
    //if it is not the new day,load todays list
    else {
      HabitList = _Mybox.get(todaysDateFormatted());
    }
  }

  //update the database
  void updateData() {
    //update todays entries
    _Mybox.put(todaysDateFormatted(), HabitList);

    //update thw whole database
    _Mybox.put("CURRENT_HABIT_LIST", HabitList);

    //calculate habit percentages for each day
    calculateHabitPercentages();

    //load the heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < HabitList.length; i++) {
      if (HabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = HabitList.isEmpty
        ? '0.0'
        : (countCompleted / HabitList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _Mybox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_Mybox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _Mybox.get("PERCENTAGE_SUMMARY_${yyyymmdd}") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
