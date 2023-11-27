import 'package:flutter/material.dart';
import 'package:todo/store.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  TextEditingController todoBox = TextEditingController();

  List<TodoItem> todoitems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.dashboard),
          tooltip: 'Dashboard'),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
          tooltip: 'Dashboard'),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
          tooltip: 'Dashboard')
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.perm_identity_sharp, size: 40),
                ),
                accountName: Text('K Adithyan'),
                accountEmail: Text('adithyank@gmail.com')
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              subtitle: Text('Click to view user profile and change password'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setttings'),
              subtitle: Text('Application Preferences'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              subtitle: Text('Please come back'),
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoBox,
                    decoration: InputDecoration(
                      labelText: 'Add Todo Item',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      TodoStore.addNew(todoBox.text).then((item) {
                        setState(() {
                          todoitems.add(item);
                          todoBox.text = '';
                        });
                      });
                    },
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                  tooltip: 'Click to add Todo Item',
                )
              ]
            ),
            FutureBuilder(
                future: TodoStore.readAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return CircularProgressIndicator();

                  todoitems = snapshot.data ?? [];

                  return Expanded(
                    child: ListView(
                      children: todoitems.map((e) => buildItemRow(context, e)).toList(),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  Widget buildItemRow(BuildContext context, TodoItem item)
  {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        color: item.closed ? Colors.green.shade100 : Colors.blue.shade100,
        child: Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                  value: item.closed,
                  title: Text(item.title),
                  onChanged: (value) {
                    setState(() {
                      item.closed = value ?? false;
                      TodoStore.save(item);
                    });
                  },
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    TodoStore.delete(item);
                  });
                },
                icon: Icon(Icons.delete_outline, color: Colors.red)
            )
          ],
        ),
      ),
    );
  }
}

class TodoItem
{
  String id;
  String title;
  bool closed;

  TodoItem(this.id, this.title, this.closed);
}
