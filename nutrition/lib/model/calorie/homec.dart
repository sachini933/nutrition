import 'package:flutter/material.dart';
import 'package:nutrition/model/calorie/day-view.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new TextButton(
          onPressed: () {
            // Navigate back to homepage
          },
          child: const Text('Go Back!'),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _Homepage();
  }
}

class _Homepage extends State<Homepage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void onClickHistoryScreenButton(BuildContext context) {
   
  }

  void onClickSettingsScreenButton(BuildContext context) {
   
  }

  void onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) =>DayViewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Flutter Calorie Tracker App",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: new Column(
          children: <Widget>[
            new ListTile(
                leading: const Icon(Icons.food_bank),
                title: new Text("Welcome To Calorie Tracker App!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            new ElevatedButton(
                onPressed: () {
                  onClickDayViewScreenButton(context);
                },
                child: Text("Day View Screen")),
            new ElevatedButton(
                onPressed: () {
                  onClickHistoryScreenButton(context);
                },
                child: Text("History Screen")),
            new ElevatedButton(
                onPressed: () {
                  onClickSettingsScreenButton(context);
                },
                child: Text("Settings Screen")),
          ],
        ));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
