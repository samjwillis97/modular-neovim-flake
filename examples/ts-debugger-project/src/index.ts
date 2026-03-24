import express, { Request, Response } from "express";

const app = express();
const PORT = 3001;

app.use(express.json());

interface Todo {
  id: number;
  title: string;
  completed: boolean;
}

// In-memory store - good for inspecting in debugger
const todos: Todo[] = [
  { id: 1, title: "Learn Neovim DAP", completed: false },
  { id: 2, title: "Set breakpoints", completed: false },
  { id: 3, title: "Inspect variables", completed: true },
];

let nextId = 4;

// Try setting a breakpoint here and hitting GET /todos
app.get("/todos", (_req: Request, res: Response) => {
  const completed = todos.filter((t) => t.completed);
  const pending = todos.filter((t) => !t.completed);

  console.log(`Returning ${todos.length} todos (${completed.length} completed, ${pending.length} pending)`);

  res.json({ todos, stats: { total: todos.length, completed: completed.length, pending: pending.length } });
});

// Try stepping through this handler with the debugger
app.post("/todos", (req: Request, res: Response) => {
  const { title } = req.body;

  if (!title || typeof title !== "string") {
    res.status(400).json({ error: "Title is required and must be a string" });
    return;
  }

  const todo: Todo = {
    id: nextId++,
    title: title.trim(),
    completed: false,
  };

  todos.push(todo);
  console.log(`Created todo #${todo.id}: "${todo.title}"`);

  res.status(201).json(todo);
});

app.patch("/todos/:id", (req: Request, res: Response) => {
  const id = parseInt(req.params.id, 10);
  const todo = todos.find((t) => t.id === id);

  if (!todo) {
    res.status(404).json({ error: `Todo #${id} not found` });
    return;
  }

  if (req.body.title !== undefined) {
    todo.title = req.body.title;
  }
  if (req.body.completed !== undefined) {
    todo.completed = req.body.completed;
  }

  console.log(`Updated todo #${id}: ${JSON.stringify(todo)}`);
  res.json(todo);
});

app.delete("/todos/:id", (req: Request, res: Response) => {
  const id = parseInt(req.params.id, 10);
  const index = todos.findIndex((t) => t.id === id);

  if (index === -1) {
    res.status(404).json({ error: `Todo #${id} not found` });
    return;
  }

  const [deleted] = todos.splice(index, 1);
  console.log(`Deleted todo #${id}: "${deleted.title}"`);
  res.json({ message: `Deleted todo #${id}`, todo: deleted });
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
  console.log("Routes:");
  console.log("  GET    /todos");
  console.log("  POST   /todos");
  console.log("  PATCH  /todos/:id");
  console.log("  DELETE /todos/:id");
});
