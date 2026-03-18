# 📸 PLUGIN: CAMERA, AUDIO, & MEDIA
> **Version:** 1.0.0 | **Author:** Antigravity (Senior Partner)
> **Target:** Hardware utilization (Photos, Microphones, Scanner).

## 🏛️ CORE PHILOSOPHY
Capturing visual and audio data requires managing immense temporary file sizes, compressing them before network upload to prevent OOM (Out Of Memory) crashes, and strict iOS Info.plist reasoning.

---

## 🛠️ CAMERA & GALLERY PROTOCOL
- **Library:** `image_picker` for simple gallery/photo shoots. `camera` for custom, Snapchat-like UI. `mobile_scanner` exclusively for QR codes.
- **Compression:** High-end phones shoot 4K photos (8MB+). **Never** upload raw photos via Dio (`C2_Multipart_Request_Template`). Always pass `imageQuality: 50` or wrap in `flutter_image_compress` prior to payload creation.
- **UI State:** While `image_picker` is active, the app pauses. The Cubit must save all forms and states to prevent data loss if the OS forcefully closes the parent app while the camera is open.

## 🎙️ MICROPHONE & AUDIO PROTOCOL
- **Library:** Use `just_audio` for playback (excellent background support) and `record` for capturing audio (outputs standard `.m4a`.
- **Background Usage:** Do NOT put audio playing in a `StatelessWidget`. Bind `just_audio` to a `Cubit` because playback state (playing, pausing, buffering, completed) drives a progress bar. Ensure `.dispose()` kills the audio player, otherwise the audio will infinitely play over other screens.
- **Permissions:** `NSMicrophoneUsageDescription` in iOS needs extreme clarity. Example: `"This app needs the microphone so you can record voice messages for the chat."`
