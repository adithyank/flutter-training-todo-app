package com.techsukras.todo.todosever;

import org.springframework.data.jpa.repository.JpaRepository;

public interface TodoRepo extends JpaRepository<Todo, String>
{
}
