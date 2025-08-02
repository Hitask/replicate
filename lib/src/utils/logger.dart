import 'dart:developer' as dev;

class ReplicateLogger {
  static bool _isActive = true;

  static set isActive(bool newValue) {
    _isActive = newValue;
  }

  static void log(message) {
    if (!_isActive) {
      return;
    }

    dev.log(message, name: 'Replicate');
  }

  static void logRequestStart(String url) {
    log("request started from/to: $url.");
  }

  static void logRequestEnd(String url) {
    log("request from/to: $url end.");
  }

  static void logPredictionTermination(String id) {
    log("prediction with id: $id terminated, polling stopped.");
  }

  static void logRequestPayload(String to, Map<String, dynamic> body) {
    log("request payload to: $to, body: $body.");
  }
}
