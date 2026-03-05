import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { cookie, token }

class DioClient {
  final String baseUrl;
  final SharedPreferences sharedPreferences;
  final PrettyDioLogger prettyDioLogger;
  String? token;
  Dio? dio;
  PersistCookieJar? cookieJar;
  // AuthMode? _authMode;
  // String? _token;

  DioClient(
    this.baseUrl,
    Dio? dioC, {
    required this.sharedPreferences,
    required this.prettyDioLogger,
  }) {
    token = sharedPreferences.getString(AppConstants.accessToken);

    dio = dioC ?? Dio();

    dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(minutes: 1)
      ..options.receiveTimeout = const Duration(minutes: 1)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

    dio!.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        request: true,
        logPrint: (object) => print('\x1B[35m$object\x1B[0m'),
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          // if (options.path.contains(AppConstants.myInfoUrl)) {
          //   return false;
          // }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
    // ! for cookie
    // _initCookieAuth();
  }
  void updateHeader(String? token) {
    token = token ?? this.token;
    this.token = token;
    dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // ! for cookie based authentication
  /* // --------------------------
  // AUTH MODE SWITCHING LOGIC
  // --------------------------
  /// Enable cookie-based authentication
  // Future<void> enableCookieAuth() async {
  //   _authMode = AuthMode.cookie;
  //   await _initCookieAuth();
  // }
  /// Enable token-based authentication
  // Future<void> enableTokenAuth(String token) async {
  //   _authMode = AuthMode.token;
  //   _token = token;
  //   _initTokenAuth(token);
  // }
  /// Internal setup for cookie auth
  // Future<void> _initCookieAuth() async {
  //   final appDocDir = await getApplicationDocumentsDirectory();
  //   final cookiesPath = "${appDocDir.path}/cookies";
  //   cookieJar = PersistCookieJar(storage: FileStorage(cookiesPath));
  //   dio!.interceptors.clear();
  //   dio!.interceptors.addAll([prettyDioLogger, CookieManager(cookieJar!)]);
  //   await _logCookies();
  //   log("✅ Cookie-based authentication enabled");
  // }
  /// Internal setup for token auth
  // void _initTokenAuth(String token) {
  //   dio!.interceptors.clear();
  //   dio!.interceptors.add(prettyDioLogger);
  //   dio!.options.headers["Authorization"] = "Bearer $token";
  //   log("🔐 Token-based authentication enabled");
  // }
  // --------------------------
  // HELPER METHODS
  // --------------------------
  // Future<void> _logCookies() async {
  //   try {
  //     final cookies = await cookieJar?.loadForRequest(Uri.parse(baseUrl));
  //     if (cookies != null && cookies.isNotEmpty) {
  //       for (var cookie in cookies) {
  //         log("🍪 Cookie: ${cookie.name}=${cookie.value}");
  //       }
  //     } else {
  //       log("⚠️ No cookies stored yet.");
  //     }
  //   } catch (e) {
  //     log("❌ Error reading cookies: $e");
  //   }
  // }
  // Future<void> clearSession() async {
  //   try {
  // if (_authMode == AuthMode.cookie) {
  //     await cookieJar?.deleteAll();
  // }
  // if (_authMode == AuthMode.token) {
  //   _token = null;
  //   dio!.options.headers.remove("Authorization");
  // }
  // log("🧹 Session cleared (${_authMode?.name ?? 'unknown'})");
  //   } catch (e) {
  //     log("❌ Error clearing session: $e");
  //   }
  // }*/

  Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // --------------------------
  // GENERIC HTTP METHODS
  // --------------------------

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final hasInternet = await isConnectedToInternet();

    if (!hasInternet) {
      throw Exception("No internet connection. Please try again.");
    }

    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> download(
    String uri,
    String savePath, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.download(
        uri,
        savePath,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> downloadWithAutomaticFilename(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      String? savedPath;
      String? savedFileName;

      var response = await dio!.download(
        uri,
        (Headers headers) async {
          final fileName = _extractFileNameFromHeaders(headers, uri);
          savedFileName = fileName;

          final dirPath = await _getDownloadsDirectory();
          savedPath = '$dirPath/$fileName';
          return savedPath!;
        },
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      // Return new Response with file info
      return Response(
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        data: {'file_path': savedPath, 'file_name': savedFileName},
      );
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  String _extractFileNameFromHeaders(Headers headers, String url) {
    // Try to get filename from Content-Disposition header
    final contentDisposition = headers.value('content-disposition');

    if (contentDisposition != null) {
      // Handle filename* (RFC 5987)
      final fileNameStarMatch = RegExp(
        r"filename\*=UTF-8''([^;]+)",
      ).firstMatch(contentDisposition);
      if (fileNameStarMatch != null) {
        return Uri.decodeComponent(fileNameStarMatch.group(1)!);
      }

      // Handle regular filename
      final fileNameMatch = RegExp(
        r'''filename=["']?([^"';]+)["']?''',
      ).firstMatch(contentDisposition);
      if (fileNameMatch != null) {
        String fileName = fileNameMatch.group(1)!;
        return fileName.replaceAll('"', '').trim();
      }
    }

    // Fallback: Extract from URL
    final uri = Uri.parse(url);
    String urlFileName = path.basename(uri.path);

    if (urlFileName.isEmpty || urlFileName == '/') {
      // Generate unique filename
      urlFileName = 'download_${DateTime.now().millisecondsSinceEpoch}';

      // Add extension based on content type
      final contentType = headers.value('content-type');
      if (contentType != null) {
        final extension = _getExtensionFromContentType(contentType);
        urlFileName = '$urlFileName.$extension';
      }
    }

    return urlFileName;
  }

  String _getExtensionFromContentType(String contentType) {
    final Map<String, String> extensions = {
      'application/pdf': 'pdf',
      'image/jpeg': 'jpg',
      'image/png': 'png',
      'image/gif': 'gif',
      'application/zip': 'zip',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
          'docx',
      'application/msword': 'doc',
      'application/vnd.ms-excel': 'xls',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
          'xlsx',
      'text/plain': 'txt',
      'text/csv': 'csv',
      'application/json': 'json',
      'application/octet-stream': 'bin',
      'application/vnd.android.package-archive': 'apk',
    };

    return extensions[contentType] ?? 'bin';
  }

  /// Get default downloads directory
  Future<String> _getDownloadsDirectory() async {
    String basePath;
    if (Platform.isAndroid) {
      basePath = '/storage/emulated/0';
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      basePath = directory.path;
    } else if (Platform.isWindows) {
      final directory = await getDownloadsDirectory();
      basePath =
          directory?.path ?? (await getApplicationDocumentsDirectory()).path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      basePath = directory.path;
    }

    final finalPath = path.join(basePath, 'Banijjo');
    final directory = Directory(finalPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return finalPath;
  }
}
