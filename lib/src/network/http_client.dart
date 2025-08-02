import 'dart:convert';
import 'dart:io';

import 'package:replicate/src/network/builder/headers.dart';
import 'package:http/http.dart' as http;

import '../exceptions/replicate_exception.dart';
import '../utils/logger.dart';
class ReplicateHttpClient {
  static Future<T> get<T>({
    required T Function(Map<String, dynamic>) onSuccess,
    required String from,
  }) async {
    ReplicateLogger.logRequestStart(from);
    final response = await http.get(
      Uri.parse(from),
      headers: HeaderBuilder.build(),
    );
    ReplicateLogger.logRequestEnd(from);

    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

    final error = decodedBody["error"];
    final detail = decodedBody["detail"];

    if (error == null && detail == null) {
      return onSuccess(decodedBody);
    } else {
      throw ReplicateException(message: error, statsCode: response.statusCode);
    }
  }

  static Future<T> post<T>({
    required T Function(Map<String, dynamic>) onSuccess,
    required String to,
    Map<String, dynamic>? body,
  }) async {
    ReplicateLogger.logRequestStart(to);
    final response = await http.post(
      Uri.parse(to),
      headers: HeaderBuilder.build(true),
      body: jsonEncode(body),
    );
    ReplicateLogger.logRequestEnd(to);
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

    final error = decodedBody["error"];
    final detail = decodedBody["detail"];
    if (error == null && detail == null) {
      return onSuccess(decodedBody);
    } else {
      throw ReplicateException(
        message: error ?? detail ?? "Unknown error",
        statsCode: response.statusCode,
      );
    }
  }

  static Future<T> postMultipart<T>({
    required T Function(Map<String, dynamic>) onSuccess,
    required String to,
    required File file,
    required String filename,
    String? contentType,
    Map<String, dynamic>? metadata,
  }) async {
    ReplicateLogger.logRequestStart(to);

    final request = http.MultipartRequest('POST', Uri.parse(to));

    // Add headers (but not Content-Type as it's set by MultipartRequest)
    final headers = HeaderBuilder.build(false);
    headers.forEach((key, value) {
      if (key.toLowerCase() != 'content-type') {
        request.headers[key] = value;
      }
    });

    // Add file
    final multipartFile = await http.MultipartFile.fromPath(
      'content',
      file.path,
      filename: filename,
    );
    request.files.add(multipartFile);

    // Add metadata if provided
    if (metadata != null) {
      request.fields['metadata'] = jsonEncode(metadata);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    ReplicateLogger.logRequestEnd(to);

    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

    final error = decodedBody["error"];
    final detail = decodedBody["detail"];
    if (error == null && detail == null) {
      return onSuccess(decodedBody);
    } else {
      throw ReplicateException(
        message: error ?? detail ?? "Unknown error",
        statsCode: response.statusCode,
      );
    }
  }

  static Future<void> delete({
    required void Function() onSuccess,
    required String from,
  }) async {
    ReplicateLogger.logRequestStart(from);
    final response = await http.delete(
      Uri.parse(from),
      headers: HeaderBuilder.build(),
    );
    ReplicateLogger.logRequestEnd(from);

    final decodedBody = response.body.isEmpty
        ? {}
        : jsonDecode(response.body) as Map<String, dynamic>;

    final error = decodedBody["error"];
    final detail = decodedBody["detail"];
    if (error == null && detail == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return onSuccess();
      }
    } else {
      throw ReplicateException(
        message: error ?? detail ?? "Unknown error",
        statsCode: response.statusCode,
      );
    }
  }
}
