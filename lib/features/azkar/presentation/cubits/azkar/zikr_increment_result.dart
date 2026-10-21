sealed class ZikrIncrementResult {
  const ZikrIncrementResult();
}

class ZikrIncremented extends ZikrIncrementResult {
  const ZikrIncremented();
}

class ZikrCompleted extends ZikrIncrementResult {
  const ZikrCompleted();
}

class ZikrIgnored extends ZikrIncrementResult {
  const ZikrIgnored();
}
