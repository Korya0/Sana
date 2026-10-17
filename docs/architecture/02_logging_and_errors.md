# Logging & Errors

## Logging

- One place logs an error — not every layer. Decide who logs and where.
- Reported errors go to Firebase Crashlytics.
- Never log sensitive user data.

## Errors & results

- Define error types, e.g. `NetworkFailure`, `CacheFailure`.
- Return every result as `Result<T>`.
- An error travels up through the layers: data → Cubit → UI.
- Never let a raw exception leak to an upper layer.
