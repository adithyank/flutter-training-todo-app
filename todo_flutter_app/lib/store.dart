import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/todo.dart';

class TodoStore
{
  static Future<TodoItem> addNew(String title) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    TodoItem todo = TodoItem(DateTime.now().millisecondsSinceEpoch.toString(), title, false);
    return save(todo);
  }

  static Future<TodoItem> save(TodoItem todo) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(todo.id, '${todo.closed}|${todo.title}');
    return todo;
  }

  static void delete(TodoItem todo) async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(todo.id);
  }

  static Future<List<TodoItem>> readAll() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Set<String> ids = pref.getKeys();

    List<TodoItem> todos = [];

    for (String id in ids)
    {
      String? s = pref.getString(id);
      if (s == null || s.isEmpty || !s.contains('|'))
        continue;

      List<String> portions = s.split('|');
      TodoItem item = TodoItem(id, portions[1], bool.parse(portions[0]));
      todos.add(item);
    }

    return todos;
  }
}