import 'package:flutter/material.dart';

const String tableName = 'dataModel';

class DataModelFields {
  static final List<String> values = [id, title, url, user];
  static const String id = '_id';
  static const String title = 'title';
  static const String url = 'url';
  static const String user = 'user';
  static const String time = 'time';
}

class DataModel {
  final int? id;
  final String title;
  final String url;
  final String user;
  final DateTime createdTime;

  const DataModel({
    this.id,
    required this.title,
    required this.url,
    required this.user,
    required this.createdTime,
  });

  DataModel copy({
    int? id,
    String? title,
    String? url,
    String? user,
    DateTime? createdTime,
  }) =>
      DataModel(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        user: user ?? this.user,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, Object?> toJson() => {
        DataModelFields.id: id,
        DataModelFields.title: title,
        DataModelFields.url: url,
        DataModelFields.user: user,
        DataModelFields.time: createdTime.toIso8601String()
      };

  static DataModel fromJson(Map<String, Object?> json) => DataModel(
        id: json[DataModelFields.id] as int?,
        title: json[DataModelFields.title] as String,
        url: json[DataModelFields.url] as String,
        user: json[DataModelFields.user] as String,
        createdTime: DateTime.parse(json[DataModelFields.time] as String),
      );
}
