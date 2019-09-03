import 'package:flutter/material.dart';

import 'clock.dart';
import 'game-settings.dart';
import 'game-time.dart';

class TimeSelectionWidget extends StatefulWidget {
  static const routeName = '/time-selection';

  TimeSelectionWidget({Key key}) : super(key: key);

  _TimeSelectionWidgetState createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  int increment = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: clockSelectionScreen(),
    );
  }

  Widget clockSelectionScreen() {
    return Scaffold(
      body: Container(
        color: Colors.white12,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                wrappedButtons(orientation),
                Text(
                  "Increment",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                incrementSection(orientation)
              ],
            );
          },
        ),
      ),
    );
  }

  Wrap wrappedButtons(Orientation orientation) {
    return Wrap(
      direction: orientation == Orientation.landscape
          ? Axis.horizontal
          : Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: <Widget>[
        timerOption("1 Hour", GameTime.Hour),
        timerOption("20 Minute", GameTime.TwentyMinute),
        timerOption("10 Minute", GameTime.TenMinute),
        timerOption("5 Minute", GameTime.FiveMinute),
        timerOption("3 Minute", GameTime.ThreeMinute),
        timerOption("1 Minute", GameTime.OneMinute),
        timerOption("30 Second", GameTime.ThirtySecond)
      ],
    );
  }

  MaterialButton timerOption(String timerText, GameTime timerOption) {
    return RaisedButton(
      color: Colors.blue[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () {
        int durationInSeconds = 0;
        switch (timerOption) {
          case GameTime.ThirtySecond:
            durationInSeconds = 30;
            break;
          case GameTime.OneMinute:
            durationInSeconds = 60;
            break;
          case GameTime.ThreeMinute:
            durationInSeconds = 180;
            break;
          case GameTime.FiveMinute:
            durationInSeconds = 300;
            break;
          case GameTime.TenMinute:
            durationInSeconds = 600;
            break;
          case GameTime.TwentyMinute:
            durationInSeconds = 1200;
            break;
          case GameTime.Hour:
            durationInSeconds = 3600;
            break;
          default:
        }

        Navigator.pushNamed(context, ClockWidget.routeName,
            arguments: GameSettings(
                durationInSeconds: durationInSeconds, increment:  increment));
      },
      child: Text(
        timerText,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }

  RaisedButton decrementButton() {
    return RaisedButton(
      onPressed: () {
        if (increment > 0) {
          setState(() {
            increment = increment - 1;
          });
        }
      },
      color: Colors.red,
      child: Text(
        "-",
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
        ),
      ),
    );
  }

  Widget incrementSection(Orientation orientation) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: decrementButton(),
          ),
          Text(
            increment.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: incrementButton(),
          )
        ],
      ),
    );
  }

  Widget incrementButton() {
    return RaisedButton(
      onPressed: () {
        setState(() {
          increment = increment + 1;
        });
      },
      color: Colors.green,
      child: Text(
        "+",
        style: TextStyle(
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
