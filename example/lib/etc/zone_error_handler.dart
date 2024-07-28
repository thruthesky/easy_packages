import 'dart:developer';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:example/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 에러 핸들러
zoneErrorHandler(e, stackTrace) {
  log("----> runZoneGuarded() : Exceptions outside flutter framework.");
  log("--------------------------------------------------------------");
  log("---> runtimeType: ${e.runtimeType}");

  if (e is FirebaseAuthException) {
    String message = "${e.code} - ${e.message}";
    if (e.code == 'invalid-email') {
      message = '잘못된 이메일 주소입니다.';
    } else if (e.code == 'weak-password') {
      message = '비밀번호를 더 어렵게 해 주세요. 대소문자, 숫자 및 특수문자를 포함하여 6자 이상으로 입력해주세요.';
    } else if (e.code == 'email-already-in-use') {
      message = '메일 주소 또는 비밀번호를 잘못 입력하였습니다.';
    }
    toast(context: globalContext, message: Text('로그인 에러 :  $message'));
  } else if (e is FirebaseException) {
    log("FirebaseException :  ${e.code}, ${e.message}");
    if (e.plugin == 'firebase_storage') {
      if (e.code == 'unknown') {
        error(
            context: globalContext,
            message: Text('파일 업로드 에러 :  ${e.message}\n\nStorage 서비스를 확인해주세요.'));
      } else {
        error(context: globalContext, message: Text(e.toString()));
      }
    } else {
      error(context: globalContext, message: Text(e.toString()));
    }
  } else if (e is PlatformException) {
    log("PlatformException: (${e.code}) - ${e.message}");

    error(
        context: globalContext,
        title: Text(e.code),
        message: Text(e.message ?? ''));
  } else {
    log("Unknown Error :  $e");
    if (e.toString().contains('/')) {
      final title = e.toString().split(' ')[0].split('/')[1];
      final parts = e.toString().split(' ');
      String message = '';
      if (parts.length > 1) {
        message = parts.sublist(1).join(' ');
      }
      error(context: globalContext, title: Text(title), message: Text(message));
    } else {
      error(context: globalContext, message: Text(e.toString()));
    }
  }
  debugPrintStack(stackTrace: stackTrace);
}
