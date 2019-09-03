class TimerService {
  Duration getDurationRemaining(
      Stopwatch watch, int currentDurationInSeconds, bool started,
      [int increment]) {
    return Duration(
        seconds: currentDurationInSeconds -
            watch.elapsed.inSeconds +
            (started ? increment : 0));
  }
}
