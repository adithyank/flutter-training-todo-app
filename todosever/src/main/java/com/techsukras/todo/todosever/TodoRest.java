package com.techsukras.todo.todosever;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/todo")
public class TodoRest
{
    @Autowired
    private TodoRepo todoRepo;

    @PostMapping("/add")
    public TodoItem addTodo(@RequestBody TodoItem todoItem)
    {
        Todo todo = new Todo();
        todo.setClosed("false");
        todo.setTitle(todoItem.title);
        Todo savedTodo = todoRepo.save(todo);
        return createItem(savedTodo);
    }

    private TodoItem createItem(Todo todo)
    {
        TodoItem ti = new TodoItem();
        ti.id = todo.getId();
        ti.title = todo.getTitle();
        ti.closed = Boolean.parseBoolean(todo.getClosed());
        return ti;
    }

    @PostMapping("/save")
    public TodoItem saveTodo(@RequestBody TodoItem todoItem)
    {
        Todo todo = new Todo();
        todo.setId(todoItem.id);
        todo.setClosed(String.valueOf(todoItem.closed));
        todo.setTitle(todoItem.title);
        Todo savedTodo = todoRepo.save(todo);
        return createItem(savedTodo);
    }

    @DeleteMapping("/delete/{todoItemId}")
    public void delete(@PathVariable String todoItemId)
    {
        todoRepo.deleteById(todoItemId);
    }

    @GetMapping("/list")
    public List<TodoItem> readAll()
    {
        System.out.println("server read called");
        List<Todo> dbList = todoRepo.findAll();
        System.out.println("list from db: " + dbList.size());

        List<TodoItem> itemList = new ArrayList<>();

        for (Todo todo : dbList)
        {
            TodoItem item = createItem(todo);
            itemList.add(item);
        }

        System.out.println("itemList.size = " + itemList.size());

        return itemList;
    }

    public static class TodoItem
    {
        public String id;
        public String title;
        public boolean closed;
    }
}
