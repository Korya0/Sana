# 🦷 PLUGIN: BLUETOOTH (BLE)
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** Connecting to IoT hardware, Smartwatches, and POS Printers.

## 🏛️ CORE PHILOSOPHY
Bluetooth Low Energy is stream-based. Forgetting to `.cancel()` a Bluetooth scanning stream will aggressively destroy the phone's battery within an hour.

---

## 🛠️ BLUETOOTH PROTOCOL
- **Library:** Always use `flutter_blue_plus`. It is strictly superior to all legacy forks.
- **Permissions:** Android 12+ completely changed this. Do NOT request `Location` for BLE unless supporting old phones. Request `BLUETOOTH_SCAN` and `BLUETOOTH_CONNECT` explicitly via the `Manifest`.
- **The Scan Flow:**
  1. Verify Bluetooth is ON (`FlutterBluePlus.adapterState`).
  2. Start Scan (`startScan(timeout: Duration(seconds: 4))`). **Never** scan infinitely.
  3. Listen to `scanResults` stream.
  4. Stop Scan immediately once the target device is parsed to save power.
- **The Connect Flow:**
  1. Use `device.connect(autoConnect: false)`.
  2. Always wrap reads/writes in try/catch blocks because IoT devices drop connection unpredictably.
- **Disposal:** The enclosing `Cubit` MUST cancel the `StreamSubscription` for device state in its `close()` override.
