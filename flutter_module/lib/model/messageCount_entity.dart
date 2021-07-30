// To parse this JSON data, do
//
//     final messageCount = messageCountFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_module/model/base_entity.dart';

MessageCount messageCountFromJson(String str) =>
    MessageCount.fromJson(json.decode(str) as Map<String, dynamic>);

String messageCountToJson(MessageCount data) => json.encode(data.toJson());

class MessageCount  {
  MessageCount({
    this.remindCount,
    this.noticeCount,
  });

  int remindCount;
  int noticeCount;

  MessageCount fromJson(Map<String, dynamic> json) {
    return MessageCount(
        remindCount: json["remindCount"] as int,
        noticeCount: json["noticeCount"] as int,
      );
  }

  factory MessageCount.fromJson(Map<String, dynamic> json) => MessageCount(
        remindCount: json["remindCount"] as int,
        noticeCount: json["noticeCount"] as int,
      );

  Map<String, dynamic> toJson() => {
        "remindCount": remindCount,
        "noticeCount": noticeCount,
      };
}
