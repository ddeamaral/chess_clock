import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game-time.dart';

class ClockWidget extends StatefulWidget {
  static const routeName = "/clock";

  ClockWidget({Key key}) : super(key: key);

  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  Stopwatch whiteTimer;
  Stopwatch blackTimer;
  Timer periodicTicker;
  bool started = false;
  bool readyToStart = false;
  bool isWhitesTurn = true;
  bool whiteFlagged = false;
  bool blackFlagged = false;
  int duration = 0;
  int whiteTimeLeft = 0;
  int blackTimeLeft = 0;

  final Color activeColor = Colors.green[500];

  @override
  void dispose() {
    super.dispose();
    whiteTimer = null;
    blackTimer = null;
    periodicTicker.cancel();
    periodicTicker = null;
  }

  @override
  Widget build(BuildContext context) {
    // Hide notification bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    return OrientationBuilder(
      builder: (context, orientation) {
        if (readyToStart == false) {
          return clockSelectionScreen();
        }

        if (orientation == Orientation.landscape) {
          return horizontalClock(context);
        }

        return verticalClock(context);
      },
    );
  }

  Widget horizontalClock(context) {
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: (started == true
              ? MainAxisAlignment.start
              : MainAxisAlignment.center),
          mainAxisSize: MainAxisSize.max,
          children: horizontalClockTimer(
            context,
            MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }

  List<Widget> horizontalClockTimer(context, width, height) {
    int whiteMinutes = whiteTimeLeft >= 60 ? (whiteTimeLeft / 60).floor() : 0;
    int whiteSeconds = whiteTimeLeft - (whiteMinutes * 60);
    int blackMinutes = blackTimeLeft >= 60 ? (blackTimeLeft / 60).floor() : 0;
    int blackSeconds = blackTimeLeft - (blackMinutes * 60);

    return <Widget>[
      Container(
        width: width,
        height: height,
        child: FlatButton(
          onPressed: handleOnWhitePressed,
          color: (isWhitesTurn == true ? activeColor : Colors.white),
          child: RotatedBox(
            quarterTurns: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (whiteFlagged == true
                  ? <Widget>[Icon(Icons.flag, color: Colors.red, size: 150)]
                  : timerButtonText(
                      "White", whiteMinutes, whiteSeconds, Colors.black)),
            ),
          ),
        ),
      ),
      Container(
        width: width,
        height: height,
        child: FlatButton(
          onPressed: handleOnBlackPressed,
          color: (isWhitesTurn == false ? activeColor : Colors.black),
          child: RotatedBox(
            quarterTurns: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (blackFlagged == true
                  ? <Widget>[Icon(Icons.flag, color: Colors.red, size: 150)]
                  : timerButtonText(
                      "Black", blackMinutes, blackSeconds, Colors.white)),
            ),
          ),
        ),
      ),
    ];
  }

  void handleOnBlackPressed() {
    if (started) {
      setState(() {
        isWhitesTurn = false;
      });
      whiteTimer.stop();
      blackTimer.start();
    }
  }

  List<Widget> verticalClockTimer(context, width, height) {
    int whiteMinutes = whiteTimeLeft >= 60 ? (whiteTimeLeft / 60).floor() : 0;
    int whiteSeconds = whiteTimeLeft - (whiteMinutes * 60);
    int blackMinutes = blackTimeLeft >= 60 ? (blackTimeLeft / 60).floor() : 0;
    int blackSeconds = blackTimeLeft - (blackMinutes * 60);

    return <Widget>[
      Container(
        width: width,
        height: height,
        child: FlatButton(
          onPressed: handleOnWhitePressed,
          color: (isWhitesTurn ? activeColor : Colors.white),
          child: RotatedBox(
            quarterTurns: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (whiteFlagged == true
                  ? <Widget>[Icon(Icons.flag, color: Colors.red, size: 150)]
                  : timerButtonText(
                      "White",
                      whiteMinutes,
                      whiteSeconds,
                      Colors.black,
                    )),
            ),
          ),
        ),
      ),
      Container(
        width: width,
        height: height,
        child: FlatButton(
          onPressed: handleOnBlackPressed,
          color: (isWhitesTurn == false ? activeColor : Colors.black),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (blackFlagged == true
                ? <Widget>[Icon(Icons.flag, color: Colors.red, size: 150)]
                : timerButtonText(
                    "Black", blackMinutes, blackSeconds, Colors.white)),
          ),
        ),
      ),
    ];
  }

  void handleOnWhitePressed() {
    if (started == false) {
      periodicTicker = Timer.periodic(Duration(seconds: 1), (t) {
        if (whiteFlagged || blackFlagged) {
          // Game over, out of time
          t.cancel();
        }

        setState(() {
          if (whiteTimer.isRunning &&
              whiteTimer.elapsed.inSeconds <= duration) {
            whiteTimeLeft = duration - whiteTimer.elapsed.inSeconds;
          }
          if (blackTimer.isRunning &&
              blackTimer.elapsed.inSeconds <= duration) {
            blackTimeLeft = duration - blackTimer.elapsed.inSeconds;
          }
          started = true;
          whiteFlagged = whiteTimeLeft <= 0;
          blackFlagged = blackTimeLeft <= 0;
        });
      });
    }
    setState(() {
      isWhitesTurn = true;
    });
    whiteTimer.start();
    blackTimer.stop();
  }

  List<Widget> timerButtonText(String timerLabel, int minutesRemaining,
      int secondsRemaining, Color textColor) {
    String timeString = minutesRemaining.toString().padLeft(2, "0") +
        ":" +
        (secondsRemaining > 9
            ? secondsRemaining.toString().padRight(2, "0")
            : secondsRemaining.toString().padLeft(2, "0"));

    return <Widget>[
      Text(
        timerLabel,
        style: TextStyle(
          fontSize: 30,
          color: textColor,
        ),
      ),
      Text(
        timeString,
        style: TextStyle(fontSize: 75, color: textColor),
      )
    ];
  }

  Widget clockSelectionScreen() {
    return Container(
      color: Colors.grey[300],
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          timerOption("1 Hour", GameTime.Hour),
          timerOption("20 Minute", GameTime.TwentyMinute),
          timerOption("10 Minute", GameTime.TenMinute),
          timerOption("5 Minute", GameTime.FiveMinute),
          timerOption("3 Minute", GameTime.ThreeMinute),
          timerOption("1 Minute", GameTime.OneMinute),
          timerOption("30 Second", GameTime.ThirtySecond)
        ],
      ),
    );
  }

  MaterialButton timerOption(String timerText, GameTime timerOption) {
    return RaisedButton(
      onPressed: () {
        int d = 0;
        switch (timerOption) {
          case GameTime.ThirtySecond:
            d = 30;
            break;
          case GameTime.OneMinute:
            d = 60;
            break;
          case GameTime.ThreeMinute:
            d = 180;
            break;
          case GameTime.FiveMinute:
            d = 300;
            break;
          case GameTime.TenMinute:
            d = 600;
            break;
          case GameTime.TwentyMinute:
            d = 1200;
            break;
          case GameTime.Hour:
            d = 3600;
            break;
          default:
        }

        setState(() {
          duration = d;
          readyToStart = true;
          whiteTimer = new Stopwatch();
          blackTimer = new Stopwatch();
          whiteTimeLeft = d;
          blackTimeLeft = d;
        });
      },
      child: Text(
        timerText,
        style: TextStyle(
          fontSize: 30,
          backgroundColor: activeColor,
        ),
      ),
    );
  }

  Widget verticalClock(context) {
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: (started == true
              ? MainAxisAlignment.start
              : MainAxisAlignment.center),
          mainAxisSize: MainAxisSize.max,
          children: verticalClockTimer(
            context,
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 2,
          ),
        ),
      ),
    );
  }
}
