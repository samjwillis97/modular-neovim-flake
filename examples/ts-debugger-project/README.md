# TypeScript Debugger Example

This example demonstrates how to extend the base neovim configuration with Node.js debugging support using nvim-dap and vscode-js-debug. It includes a simple Express Todo API server with routes designed for practicing with the debugger.

## Structure

```
ts-debugger-project/
├── flake.nix              # Main flake with dev shell configuration
├── neovim/
│   └── debugger.nix       # DAP adapter and debug configurations
├── package.json           # Node.js dependencies
├── tsconfig.json          # TypeScript compiler configuration
└── src/
    └── index.ts           # Express server with Todo API routes
```

## What's Included

### DAP Adapter Configuration

- `pwa-node` adapter using `vscode-js-debug` from nixpkgs
- No manual adapter installation required - Nix handles it

### Debug Configurations

- **Launch current file** - Compile and debug the currently open JS/TS file
- **Attach to process** - Connect to a running Node.js process started with `--inspect`

Both configurations include source map support and skip Node.js internals when stepping.

### Express Server

A Todo API with CRUD endpoints, designed with good debugging targets:

- Variables to inspect (`todos` array, `completed`/`pending` filters)
- Conditional logic to step through (validation, not-found checks)
- Console logging to verify execution flow

## Setup

1. Enter the dev shell:

```bash
nix develop
```

2. Install Node.js dependencies:

```bash
npm install
```

3. Compile TypeScript:

```bash
npx tsc
```

## How to Debug

### Launch Mode

Launch mode compiles and runs a file directly under the debugger.

1. Open `src/index.ts` in neovim
2. Set a breakpoint on a line inside a route handler (e.g., the `GET /todos` handler) with `<leader>bb`
3. Press `<leader>dd` to start debugging
4. Select **"Launch current file"**
5. The server starts under the debugger - trigger your breakpoint with:

```bash
curl http://localhost:3000/todos
```

### Attach Mode

Attach mode connects to an already-running Node.js process.

1. Start the server with the debug inspector enabled:

```bash
npm run debug
# or: node --inspect=9229 dist/index.js
```

2. Open `src/index.ts` in neovim and set breakpoints with `<leader>bb`
3. Press `<leader>dd` and select **"Attach to process"**
4. Trigger your breakpoint:

```bash
curl http://localhost:3000/todos
```

## Testing Breakpoints

Good places to set breakpoints for practice:

- `src/index.ts` line inside `GET /todos` - inspect `completed` and `pending` arrays
- `src/index.ts` line inside `POST /todos` - step through validation logic
- `src/index.ts` line inside `PATCH /todos/:id` - watch the `todo` object get modified
- `src/index.ts` line inside `DELETE /todos/:id` - inspect `splice` behavior

Example test commands:

```bash
# List all todos
curl http://localhost:3000/todos

# Create a new todo
curl -X POST http://localhost:3000/todos -H 'Content-Type: application/json' -d '{"title":"Debug this!"}'

# Toggle completion
curl -X PATCH http://localhost:3000/todos/1 -H 'Content-Type: application/json' -d '{"completed":true}'

# Delete a todo
curl -X DELETE http://localhost:3000/todos/2
```

## Key Bindings Reference

These bindings come from the base DAP configuration:

| Binding            | Action                |
|--------------------|---------------------- |
| `<leader>bb`       | Toggle breakpoint     |
| `<leader>dd`       | Start debugging       |
| `<Up>`             | Continue              |
| `<leader><leader>` | Stop debugging        |
| `<leader>du`       | Toggle DAP view       |

## Customization

### Adding More Debug Configurations

Edit `neovim/debugger.nix` to add more configurations to the `jsConfigs` list. For example, to add a configuration that always launches `src/index.ts`:

```nix
{
  type = "pwa-node";
  request = "launch";
  name = "Launch server";
  program = "\${workspaceFolder}/src/index.ts";
  cwd = "\${workspaceFolder}";
  sourceMaps = true;
  skipFiles = [ "<node_internals>/**" ];
}
```

### Adding More Modules

Create additional `.nix` files in the `neovim/` directory and add them to the `extendModules` list in `flake.nix`:

```nix
(my-neovim.lib.${system}.extendModules [
  ./neovim/debugger.nix
  ./neovim/your-new-module.nix
])
```
