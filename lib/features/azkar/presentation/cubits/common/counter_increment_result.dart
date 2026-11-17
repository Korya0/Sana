sealed class CounterIncrementResult {
  // Creates result
  const CounterIncrementResult();
}

class CounterIncremented extends CounterIncrementResult {
  // Creates result
  const CounterIncremented();
}

class CounterCompleted extends CounterIncrementResult {
  // Creates result
  const CounterCompleted();
}

class CounterIgnored extends CounterIncrementResult {
  // Creates result
  const CounterIgnored();
}
