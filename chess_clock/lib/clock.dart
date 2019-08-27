import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'player.dart';

class ClockWidget extends StatefulWidget {
  static const routeName = "/clock";

  ClockWidget({Key key}) : super(key: key);

  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  Stopwatch whiteTimer = new Stopwatch();
  Stopwatch blackTimer = new Stopwatch();
  Timer periodicTicker;
  bool started = false;
  bool isWhitesTurn = true;
  bool whiteFlagged = false;
  bool blackFlagged = false;
  int duration = 0;
  Duration whiteTime;
  Duration blackTime;

  final Color activeColor = Colors.green[500];
  final Color flaggedColor = Colors.red[100];

  @override
  void dispose() {
    super.dispose();
    whiteTimer = null;
    blackTimer = null;
    periodicTicker.cancel();
    periodicTicker = null;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      duration = ModalRoute.of(context).settings.arguments as int;

      int whiteMinutes = duration >= 60 ? (duration / 60).floor() : 0;
      int whiteSeconds = duration - (whiteMinutes * 60);
      int blackMinutes = duration >= 60 ? (duration / 60).floor() : 0;
      int blackSeconds = duration - (blackMinutes * 60);

      whiteTime = Duration(
        minutes: whiteMinutes,
        seconds: whiteSeconds,
      );

      blackTime = Duration(
        minutes: blackMinutes,
        seconds: blackSeconds,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hide notification bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    return OrientationBuilder(
      builder: (context, orientation) {
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
                      "White",
                      whiteTime.inMinutes,
                      whiteTime.inSeconds - (whiteTime.inMinutes * 60),
                      Colors.black)),
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
                      "Black",
                      blackTime.inMinutes,
                      blackTime.inSeconds - (blackTime.inMinutes * 60),
                      Colors.white)),
            ),
          ),
        ),
      ),
    ];
  }

  void handleOnBlackPressed() {
    if (whiteFlagged || blackFlagged) return;

    if (started) {
      setState(() {
        isWhitesTurn = false;
      });
      whiteTimer.stop();
      blackTimer.start();
    }
  }

  List<Widget> verticalClockTimer(context, width, height) {
    return <Widget>[
      Container(
        width: width,
        height: height,
        child: FlatButton(
          onPressed: handleOnWhitePressed,
          color: getColorFor(Player.White),
          child: RotatedBox(
            quarterTurns: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (whiteFlagged == true
                  ? <Widget>[Icon(Icons.flag, color: Colors.red, size: 150)]
                  : timerButtonText(
                      "White",
                      whiteTime.inMinutes,
                      blackTime.inSeconds,
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
          color: getColorFor(Player.Black),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (blackFlagged == true
                ? <Widget>[Icon(Icons.flag, color: Colors.red, size: 150)]
                : timerButtonText("Black", blackTime.inMinutes,
                    blackTime.inSeconds, Colors.white)),
          ),
        ),
      ),
    ];
  }

  void handleOnWhitePressed() {
    if (whiteFlagged || blackFlagged) return;

    if (started == false) {
      periodicTicker = Timer.periodic(Duration(seconds: 1), (t) {
        if (whiteFlagged || blackFlagged) {
          // Game over, out of time
          t.cancel();
        }

        setState(() {
          if (whiteTimer.isRunning &&
              whiteTimer.elapsed.inSeconds <= duration) {
            whiteTime =
                Duration(seconds: duration - whiteTimer.elapsed.inSeconds);
          }

          if (blackTimer.isRunning &&
              blackTimer.elapsed.inSeconds <= duration) {
            blackTime =
                Duration(seconds: duration - blackTimer.elapsed.inSeconds);
          }

          started = true;
          whiteFlagged = whiteTime.inSeconds <= 0;
          blackFlagged = blackTime.inSeconds <= 0;
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

  Color getColorFor(Player player) {
    if ((whiteFlagged && player == Player.White) ||
        (blackFlagged && player == Player.Black)) {
      return flaggedColor;
    }

    if (player == Player.White) {
      return isWhitesTurn == true ? activeColor : Colors.white;
    }

    return player == Player.Black && isWhitesTurn == false
        ? activeColor
        : Colors.black;
  }
}
