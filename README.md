# nvim

Neovim config shared between macOS and NixOS. Clone it into `~/.config/nvim`:

```sh
git clone git@github.com:jamescalam/nvim.git ~/.config/nvim
```

On first launch lazy.nvim bootstraps itself. Then run `:Lazy restore` to
install the exact plugin versions from `lazy-lock.json` (use `:Lazy update`
only on the machine where you intend to bump plugins, and commit the lock).

## Tools expected on PATH

| Tool | Used by |
| --- | --- |
| `rg`, `fd` | telescope |
| `ruff`, `pyright-langserver` | Python LSP |
| `mypy` | nvim-lint (the project venv's copy is preferred when present) |
| `gopls` | Go LSP |
| `vscode-html-language-server`, `vscode-css-language-server` | HTML/CSS LSP |
| `stylua` | conform (Lua formatting) |
| `uv` | iron.nvim ipython REPL |
| `gcc` or `clang` | LuaSnip jsregexp, treesitter parsers |

On macOS Mason installs the LSP/lint/format tools automatically on startup
(see `mason-tool-installer` in `lua/plugins/init.lua`); `rg`, `fd`, `uv` and `gopls` come from Homebrew or Go. On NixOS Mason cannot install
binaries, so put them in `environment.systemPackages`:

```nix
ripgrep fd ruff pyright mypy gopls vscode-langservers-extracted stylua uv gcc
```

## Own plugins

`neo-herdr`, `neo-reviewr` and `context-switch` are loaded from
`~/Documents/aurelio/<repo>` when that checkout exists, otherwise from the
latest GitHub release (see `own()` at the top of `lua/plugins/init.lua`).

## Python REPL

iron.nvim starts ipython for the project owning the current buffer:
the venv's own `ipython` if installed, otherwise `uv run --with ipython`.
Cells are delimited by `# %%`. `<space>sb` sends the current cell,
`<space>sn` sends it and moves to the next, `<space>rr` toggles the REPL.
