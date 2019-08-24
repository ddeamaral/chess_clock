import 'package:chess_clock/clock.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      new MaterialApp(initialRoute: '/', routes: {
        MyApp.routeName: (context) => MyApp(),
        ClockWidget.routeName: (context) => ClockWidget(),
      }),
    );

class MyApp extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flutter Demo Home Page');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Chess Clock",
              style: TextStyle(
                color: Colors.red,
                fontSize: 42,
              ),
            ),
            MaterialButton(
              child: Text("Start Game"),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, ClockWidget.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
