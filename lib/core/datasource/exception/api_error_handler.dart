import 'package:dio/dio.dart';
import '../exception/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Connection error with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription = "Connection to API server failed";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 403:
                  if (error.response!.data['errors'] != null) {
                    errorDescription = error.response!.data['errors'][0];
                  } else {
                    errorDescription = error.response!.data['message'];
                  }
                  break;
                case 400:
                  return errorDescription = error.response!.data['message'];
                case 409:
                  return errorDescription = error.response!.data['message'];
                case 413:
                  return errorDescription = error.response!.data['message'];
                case 401:
                  return errorDescription = error.response!.data['message'];
                case 404:
                case 500:
                  return errorDescription = error.response!.data['message'];
                case 503:
                case 429:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  ErrorResponse errorResponse = ErrorResponse.fromJson(
                    error.response!.data,
                  );
                  if (errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription =
                        "Unable to connect to the server. Please try again.";
                    if (error.response != null &&
                        error.response!.data != null) {
                      final message = error.response!.data['message'];

                      if (message ==
                          'Your account is disabled. Please contact with admin.') {
                        errorDescription = "$message";
                      } else if (message is Map &&
                          message['name'] == 'SqlError') {
                        errorDescription = "${message['sqlMessage']}";
                      } else if (message == 'No user found.') {
                        errorDescription = "$message";
                      } else {
                        errorDescription = "An unknown error occurred.";
                      }
                    } else {
                      errorDescription =
                          "Unable to connect to the server. Please try again.";
                    }
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate Error";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = error.toString();
    }
    return errorDescription;
  }
}
