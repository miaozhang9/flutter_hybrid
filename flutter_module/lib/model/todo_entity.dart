/*
 * @Author: miaoz 
 * @Date: 2020-08-28 18:23:41 
 * @Last Modified by: miaoz
 * @Last Modified time: 2020-08-28 20:59:23
 */

// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);
import 'dart:convert';

List<Todo> todoFromJson(String str) => List<Todo>.from((json.decode(str) as Iterable<dynamic>).map((x) => Todo.fromJson(x as Map<String, dynamic>)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Todo {
    Todo({
        this.count,
        this.name,
        this.url,
    });

    int count;
    String name;
    String url;

    factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        count: json["count"] as int,
        name: json["name"] as String,
        url: json["url"] as String, 
    );

    Map<String, dynamic> toJson() => {
        "count": count as int,
        "name": name as String,
        "url": url as String,
    };
}
