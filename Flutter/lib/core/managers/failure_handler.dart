import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tafasa/core/error/failure.dart';

class FailureHandler {
  static Failure fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Failure("انتهى وقت الاتصال، حاول مرة أخرى.");

      case DioExceptionType.connectionError:
        // 👇 نحلل الخطأ نفسه (error) علشان نعرف السبب الحقيقي
        if (e.error is SocketException) {
          final message = e.error.toString();

          if (message.contains("Connection refused") ||
              message.contains("Failed host lookup") ||
              message.contains("refused")) {
            return Failure(
              "الخادم غير متصل حالياً، حاول لاحقاً.",
            ); // ✅ سيرفر واقع
          }

          return Failure("لا يوجد اتصال بالإنترنت."); // ✅ شبكة مقطوعة
        }

        return Failure("حدث خطأ في الاتصال بالخادم.");

      case DioExceptionType.badResponse:
        final data = e.response?.data;

        if (data is Map && data.containsKey("errors")) {
          final errors = data["errors"];

          if (errors is List && errors.isNotEmpty) {
            // ناخد أول رسالة أو ندمجهم كلهم
            final messages = errors
                .map((err) => err["msg"]?.toString() ?? "")
                .where((msg) => msg.isNotEmpty)
                .join("\n");

            return Failure(messages, statusCode: e.response?.statusCode);
          }
        }

        // لو السيرفر بيرجع رسالة error مفردة
        if (data is Map && data.containsKey("error")) {
          return Failure(data["error"], statusCode: e.response?.statusCode);
        }

        return Failure(
          "حدث خطأ في السيرفر.",
          statusCode: e.response?.statusCode,
        );

      case DioExceptionType.receiveTimeout:
        return Failure("انتهت مهلة الاستجابة من الخادم.");

      case DioExceptionType.sendTimeout:
        return Failure("تعذر إرسال الطلب إلى الخادم.");

      default:
        return Failure("حدث خطأ غير متوقع، حاول مرة أخرى لاحقاً.");
    }
  }
}
