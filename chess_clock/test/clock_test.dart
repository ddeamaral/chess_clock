import 'package:chess_clock/timer-service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_clock/clock.dart';

class MockTimer extends Mock implements Duration {}

class MockStopwatch extends Mock implements Stopwatch {}

void main() {
  test("Timer service calculates duration remaining", () {
    // arrange
    TimerService timerService = TimerService();
    MockStopwatch stopwatch = MockStopwatch();
    int testDuration = 3;
    bool started = true;
    int increment = 0;

    when(stopwatch.elapsed).thenReturn(Duration(seconds: 1));

    // act
    Duration timeRemaining = timerService.getDurationRemaining(
      stopwatch,
      testDuration,
      started,
      increment,
    );

    // assert
    expect(timeRemaining, Duration(seconds: 2));
  });

  testWidgets("can't tap timer after someone has flagged",
      (WidgetTester tester) {
    // todo: finish this test
    ClockWidget clockWidget = ClockWidget();
    ClockWidgetState clockState = clockWidget.createState();
    clockState.whiteFlagged = true;

    clockState.handleOnWhitePressed();
  });
}
