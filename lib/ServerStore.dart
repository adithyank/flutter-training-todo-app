
import 'dart:convert';

import 'package:todo/todo.dart';
import 'package:http/http.dart' as http;


class ServerStore
{
  static String URL = "192.168.1.4:8080";

  static Future<TodoItem> addNew(String title) async
  {
    TodoItem ti = TodoItem('', title, false);

    var response = await http.post(
      Uri.http(URL, '/todo/add'),
      body: jsonEncode(ti),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    dynamic obj = jsonDecode(utf8.decode(response.bodyBytes));
    print('obj = $obj');
    return TodoItem.fromJson(obj);
  }

  static void save(TodoItem todo) async
  {
    await http.post(
        Uri.http(URL, '/todo/save'),
        body: jsonEncode(todo),
        headers: {
          'Content-Type': 'application/json'
        }
    );
  }

  static void delete(TodoItem todo) async
  {
    await http.delete(
      Uri.http(URL, '/todo/delete/${todo.id}')
    );
  }

  static Future<List<TodoItem>> readAll() async
  {
    print('read called');
    var response = await http.get(
      Uri.http(URL, '/todo/list')
    );

    List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
    print('list: $list');
    return list.map((e) => TodoItem.fromJson(e)).toList();
  }
}