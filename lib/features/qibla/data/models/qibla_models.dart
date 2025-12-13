/// Enum representing different types of Qibla direction messages
enum QiblaMessageType { perfect, close, adjusting, searching }

/// Model for Qibla direction messages shown to the user
class QiblaMessage {
  final String message;
  final String subMessage;
  final QiblaMessageType type;

  QiblaMessage({
    required this.message,
    required this.subMessage,
    required this.type,
  });
}
