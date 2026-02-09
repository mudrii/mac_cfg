# Neovim Training Guide

A hands-on training guide for your specific Neovim configuration.
Open this file in Neovim (`nvim ~/VIM_README.md`) and practice each section.

**Your config:** `~/.config/nvim/init.lua`
**Leader key:** `Space` (shown as `<leader>` below)
**Line numbers:** Relative (shows distance from cursor) with absolute on current line

---

## Table of Contents

1. [Modes](#1-modes)
2. [Basic Movement](#2-basic-movement)
3. [Going to Specific Locations](#3-going-to-specific-locations)
4. [Inserting Text](#4-inserting-text)
5. [Deleting Text](#5-deleting-text)
6. [Changing Text](#6-changing-text)
7. [Copying and Pasting](#7-copying-and-pasting)
8. [Undo and Redo](#8-undo-and-redo)
9. [Searching](#9-searching)
10. [Search and Replace](#10-search-and-replace)
11. [Visual Mode](#11-visual-mode)
12. [Text Objects](#12-text-objects)
13. [Commenting](#13-commenting)
14. [Autopairs](#14-autopairs)
15. [Code Folding](#15-code-folding)
16. [Indentation](#16-indentation)
17. [File Explorer (nvim-tree)](#17-file-explorer-nvim-tree)
18. [Fuzzy Finding (fzf)](#18-fuzzy-finding-fzf)
19. [Buffers](#19-buffers)
20. [Tabs](#20-tabs)
21. [Splits](#21-splits)
22. [LSP (Language Server)](#22-lsp-language-server)
23. [Autocompletion (nvim-cmp)](#23-autocompletion-nvim-cmp)
24. [Formatting (conform.nvim)](#24-formatting-conformnvim)
25. [Git Integration](#25-git-integration)
26. [Undo Tree](#26-undo-tree)
27. [Markdown Preview](#27-markdown-preview)
28. [Spell Checking](#28-spell-checking)
29. [Which-Key](#29-which-key)
30. [Command Mode Essentials](#30-command-mode-essentials)
31. [Macros](#31-macros)
32. [Marks](#32-marks)
33. [Registers](#33-registers)
34. [Practice Exercises](#34-practice-exercises)

---

## 1. Modes

Neovim has several modes. The current mode shows in your statusline (lualine, bottom left).

| Key | From | To | Description |
|-----|------|----|-------------|
| `i` | Normal | Insert | Insert before cursor |
| `a` | Normal | Insert | Insert after cursor |
| `Esc` | Any | Normal | Return to Normal mode |
| `v` | Normal | Visual | Character-wise selection |
| `V` | Normal | Visual Line | Line-wise selection |
| `Ctrl+v` | Normal | Visual Block | Block/column selection |
| `:` | Normal | Command | Enter command mode |
| `R` | Normal | Replace | Overwrite characters |

**Practice:**
1. Press `i` to enter Insert mode, type some text, press `Esc` to return to Normal
2. Press `v` to enter Visual mode, move around to select, press `Esc` to cancel
3. Press `:` to open the command line, press `Esc` to cancel

---

## 2. Basic Movement

All movement is done in **Normal mode** (press `Esc` first).

### Character Movement

| Key | Action |
|-----|--------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |

### Word Movement

| Key | Action |
|-----|--------|
| `w` | Jump to start of next word |
| `W` | Jump to start of next WORD (space-separated) |
| `b` | Jump to start of previous word |
| `B` | Jump to start of previous WORD |
| `e` | Jump to end of current/next word |
| `E` | Jump to end of current/next WORD |

**Practice:** Place your cursor on this line and try `w`, `b`, `e` to move word by word.

### Line Movement

| Key | Action |
|-----|--------|
| `0` | Jump to first column of line |
| `^` | Jump to first non-blank character |
| `$` | Jump to end of line |
| `f{char}` | Jump forward to `{char}` on current line |
| `F{char}` | Jump backward to `{char}` on current line |
| `t{char}` | Jump forward to just before `{char}` |
| `T{char}` | Jump backward to just after `{char}` |
| `;` | Repeat last `f`/`F`/`t`/`T` forward |
| `,` | Repeat last `f`/`F`/`t`/`T` backward |

**Practice on this line:** Try `0` (go to start), `$` (go to end), `fx` (find the letter x), then `;` to find the next x.

### Vertical Movement

| Key | Action |
|-----|--------|
| `gg` | Go to first line of file |
| `G` | Go to last line of file |
| `{number}G` | Go to line `{number}` (e.g., `42G` goes to line 42) |
| `:{number}` | Go to line `{number}` (e.g., `:42` goes to line 42) |
| `Ctrl+d` | Scroll down half a page |
| `Ctrl+u` | Scroll up half a page |
| `Ctrl+f` | Scroll down a full page |
| `Ctrl+b` | Scroll up a full page |
| `{` | Jump to previous empty line (paragraph up) |
| `}` | Jump to next empty line (paragraph down) |
| `%` | Jump to matching bracket `()`, `[]`, `{}` |

**Practice:**
1. Type `gg` to go to the top of this file
2. Type `G` to go to the bottom
3. Type `42G` to go to line 42
4. Type `:100` then Enter to go to line 100
5. Use `Ctrl+d` and `Ctrl+u` to scroll up and down

### Screen Position

| Key | Action |
|-----|--------|
| `H` | Move cursor to top of screen (High) |
| `M` | Move cursor to middle of screen (Middle) |
| `L` | Move cursor to bottom of screen (Low) |
| `zz` | Center screen on cursor line |
| `zt` | Scroll so cursor is at top of screen |
| `zb` | Scroll so cursor is at bottom of screen |

---

## 3. Going to Specific Locations

### By Line Number

Your config uses relative line numbers. The number shown is the distance from your cursor.

| Key | Action |
|-----|--------|
| `{number}G` | Go to absolute line number (e.g., `50G`) |
| `:{number}` | Go to absolute line number (e.g., `:50`) |
| `{number}j` | Go down `{number}` lines (e.g., `5j` goes 5 lines down) |
| `{number}k` | Go up `{number}` lines (e.g., `10k` goes 10 lines up) |

**Practice:** Look at the relative numbers on the left. If a line shows `7`, type `7j` to jump there.

### By Search

| Key | Action |
|-----|--------|
| `/{pattern}` | Search forward for `{pattern}` |
| `?{pattern}` | Search backward for `{pattern}` |
| `n` | Go to next match |
| `N` | Go to previous match |
| `*` | Search forward for word under cursor |
| `#` | Search backward for word under cursor |
| `<leader><space>` | Clear search highlighting |

**Practice:**
1. Type `/Practice` and press Enter to find the word "Practice"
2. Press `n` to jump to the next occurrence
3. Press `N` to go back
4. Press `Space` then `Space` to clear the yellow highlights

---

## 4. Inserting Text

All of these switch you from Normal mode to Insert mode.

| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `I` | Insert at beginning of line |
| `a` | Insert after cursor |
| `A` | Insert at end of line |
| `o` | Open new line below and insert |
| `O` | Open new line above and insert |
| `ea` | Insert at end of current word |

**Practice:**
1. Move to any line, press `A` to append text at the end
2. Press `Esc`, then `O` to open a new line above
3. Type something, press `Esc`

---

## 5. Deleting Text

All delete commands work in Normal mode. Deleted text is saved to the clipboard (your config syncs with system clipboard).

### Single Characters and Lines

| Key | Action |
|-----|--------|
| `x` | Delete character under cursor |
| `X` | Delete character before cursor |
| `dd` | Delete entire current line |
| `D` | Delete from cursor to end of line |
| `{number}dd` | Delete `{number}` lines (e.g., `5dd` deletes 5 lines) |

### Words

| Key | Action |
|-----|--------|
| `dw` | Delete from cursor to start of next word |
| `de` | Delete from cursor to end of word |
| `db` | Delete from cursor to start of previous word |
| `diw` | Delete inner word (the whole word cursor is on) |
| `daw` | Delete a word (word + surrounding space) |

### Lines and Paragraphs

| Key | Action |
|-----|--------|
| `dd` | Delete current line |
| `d$` or `D` | Delete from cursor to end of line |
| `d0` | Delete from cursor to start of line |
| `d^` | Delete from cursor to first non-blank character |
| `dip` | Delete inner paragraph |
| `dap` | Delete a paragraph (including surrounding blank lines) |
| `dG` | Delete from current line to end of file |
| `dgg` | Delete from current line to start of file |

### Using Counts

| Key | Action |
|-----|--------|
| `3dw` | Delete 3 words |
| `5dd` | Delete 5 lines |
| `d3j` | Delete current line and 3 lines below |
| `d2}` | Delete 2 paragraphs down |

### Inside Brackets/Quotes

| Key | Action |
|-----|--------|
| `di"` | Delete inside double quotes |
| `di'` | Delete inside single quotes |
| `di(` or `dib` | Delete inside parentheses |
| `di[` | Delete inside square brackets |
| `di{` or `diB` | Delete inside curly braces |
| `dit` | Delete inside HTML/XML tag |
| `da"` | Delete including the double quotes |
| `da(` | Delete including the parentheses |

**Practice:**
1. Place cursor on a word, type `diw` to delete it
2. Place cursor inside quotes like "hello world", type `di"` to delete the contents
3. Type `dd` to delete an entire line
4. Type `u` to undo each action

---

## 6. Changing Text

Change commands delete text and immediately enter Insert mode. Same patterns as delete, but with `c` instead of `d`.

| Key | Action |
|-----|--------|
| `cw` | Change from cursor to end of word |
| `ciw` | Change inner word (replace the whole word) |
| `caw` | Change a word (word + surrounding space) |
| `cc` | Change entire line |
| `C` | Change from cursor to end of line |
| `ci"` | Change inside double quotes |
| `ci'` | Change inside single quotes |
| `ci(` | Change inside parentheses |
| `ci{` | Change inside curly braces |
| `ci[` | Change inside square brackets |
| `cit` | Change inside HTML tag |
| `ct{char}` | Change from cursor to just before `{char}` |
| `cf{char}` | Change from cursor through `{char}` (inclusive) |
| `c$` | Change from cursor to end of line |
| `c0` | Change from cursor to start of line |
| `cip` | Change inner paragraph |
| `cap` | Change a paragraph |

**Practice:**
1. Place cursor on a word, type `ciw`, type a new word, press `Esc`
2. Place cursor inside (parentheses), type `ci(`, type new content, press `Esc`
3. Type `cc` to replace an entire line

---

## 7. Copying and Pasting

Your config syncs the clipboard with the system (`clipboard = "unnamed,unnamedplus"`), so anything you yank (copy) is available in other apps, and vice versa.

### Yanking (Copying)

| Key | Action |
|-----|--------|
| `yy` | Yank (copy) current line |
| `yw` | Yank from cursor to start of next word |
| `yiw` | Yank inner word |
| `yaw` | Yank a word (with surrounding space) |
| `yi"` | Yank inside double quotes |
| `yi(` | Yank inside parentheses |
| `yi{` | Yank inside curly braces |
| `y$` | Yank from cursor to end of line |
| `y0` | Yank from cursor to start of line |
| `yip` | Yank inner paragraph |
| `{number}yy` | Yank `{number}` lines |
| `yG` | Yank from cursor to end of file |

### Pasting

| Key | Action |
|-----|--------|
| `p` | Paste after cursor (or below current line for line-wise) |
| `P` | Paste before cursor (or above current line for line-wise) |

### Yank Highlighting

Your config highlights yanked text briefly (200ms flash) so you can see what was copied.

**Practice:**
1. Type `yy` to copy the current line (notice the flash)
2. Move down, type `p` to paste below
3. Type `yiw` on a word, move elsewhere, type `p` to paste
4. Copy text in another app, come back to Neovim, type `p` to paste it

---

## 8. Undo and Redo

Your config has persistent undo (survives closing and reopening files).

| Key | Action |
|-----|--------|
| `u` | Undo last change |
| `Ctrl+r` | Redo (undo the undo) |
| `{number}u` | Undo `{number}` changes |
| `F5` | Open Undotree (visual undo history) |

### Undotree (Plugin)

Press `F5` to open a visual tree of all your undo history. Inside the undotree:

| Key | Action |
|-----|--------|
| `j` / `k` | Navigate through history states |
| `Enter` | Select a state to restore |
| `p` | Preview the change |
| `q` | Close undotree |

**Practice:**
1. Make several changes to a line (change a word, delete something, add text)
2. Press `u` multiple times to undo step by step
3. Press `Ctrl+r` to redo
4. Press `F5` to open the full undo tree and navigate visually

---

## 9. Searching

Your config: case-insensitive search unless you type an uppercase letter (smartcase).

| Key | Action |
|-----|--------|
| `/{pattern}` | Search forward |
| `?{pattern}` | Search backward |
| `n` | Next match (same direction) |
| `N` | Previous match (opposite direction) |
| `*` | Search forward for exact word under cursor |
| `#` | Search backward for exact word under cursor |
| `<leader><space>` | Clear search highlights (`Space Space`) |

**Practice:**
1. Type `/mode` and press Enter to find "mode" in this file
2. Press `n` to jump through matches
3. Press `Space` then `Space` to clear highlights
4. Place cursor on any word, press `*` to find all occurrences

---

## 10. Search and Replace

| Command | Action |
|---------|--------|
| `:s/old/new/` | Replace first "old" with "new" on current line |
| `:s/old/new/g` | Replace all "old" with "new" on current line |
| `:%s/old/new/g` | Replace all "old" with "new" in entire file |
| `:%s/old/new/gc` | Replace all with confirmation (y/n for each) |
| `:5,10s/old/new/g` | Replace in lines 5 through 10 |

In Visual mode, select text first, then type `:s/old/new/g` to replace only within selection.

**Practice:**
1. Type `:%s/Practice/PRACTICE/gc` and press Enter
2. Press `y` or `n` for each match, `a` to replace all remaining
3. Press `u` to undo all changes

---

## 11. Visual Mode

### Entering Visual Mode

| Key | Action |
|-----|--------|
| `v` | Character-wise visual selection |
| `V` | Line-wise visual selection |
| `Ctrl+v` | Block (column) visual selection |

### Actions in Visual Mode

After selecting text:

| Key | Action |
|-----|--------|
| `d` | Delete selection |
| `y` | Yank (copy) selection |
| `c` | Change selection (delete and enter Insert) |
| `>` | Indent selection right |
| `<` | Indent selection left |
| `~` | Toggle case |
| `u` | Make lowercase |
| `U` | Make uppercase |
| `gc` | Comment/uncomment selection |
| `=` | Auto-indent selection |
| `:` | Enter command mode with selection range |
| `Esc` | Cancel selection |

### Block Selection (Column Editing)

`Ctrl+v` lets you select a rectangular block of text.

| Key | Action |
|-----|--------|
| `Ctrl+v` | Start block selection |
| Move with `h/j/k/l` | Expand the block |
| `I` | Insert at the start of each line in the block |
| `A` | Append at the end of each line in the block |
| `d` | Delete the block |
| `c` | Change the block |
| `r{char}` | Replace every character in block with `{char}` |

**Practice:**
1. Press `V` to select a line, then `j` or `k` to select more lines
2. Press `>` to indent the selection, `<` to unindent
3. Press `u` to undo
4. Try `Ctrl+v`, select a column, then `I`, type something, press `Esc`

---

## 12. Text Objects

Text objects let you operate on structured pieces of text. They follow the pattern:
`{operator}{a or i}{object}`

- `a` = "a" (includes surrounding delimiters/spaces)
- `i` = "inner" (only the content inside)

### Common Text Objects

| Object | Inner (`i`) | A (`a`) |
|--------|-------------|---------|
| `w` - word | `ciw` change word | `daw` delete word + space |
| `W` - WORD | `ciW` change WORD | `daW` delete WORD + space |
| `s` - sentence | `dis` delete sentence | `das` delete sentence + space |
| `p` - paragraph | `dip` delete paragraph | `dap` delete paragraph + blank lines |
| `"` - double quotes | `ci"` change inside quotes | `da"` delete including quotes |
| `'` - single quotes | `ci'` change inside quotes | `da'` delete including quotes |
| `` ` `` - backticks | `` ci` `` change inside backticks | `` da` `` delete including backticks |
| `(` or `b` - parentheses | `ci(` change inside parens | `da(` delete including parens |
| `[` - square brackets | `ci[` change inside brackets | `da[` delete including brackets |
| `{` or `B` - curly braces | `ci{` change inside braces | `da{` delete including braces |
| `t` - HTML/XML tag | `cit` change inside tag | `dat` delete including tag |
| `>` - angle brackets | `ci>` change inside `<>` | `da>` delete including `<>` |

### Examples

Given the text: `function hello(name, age)` with cursor on "name":

| Command | Result |
|---------|--------|
| `ciw` | Changes "name" to whatever you type |
| `ci(` | Changes "name, age" (everything inside parens) |
| `da(` | Deletes "(name, age)" including the parentheses |
| `yi(` | Yanks "name, age" |

Given the text: `const msg = "Hello World"` with cursor inside the quotes:

| Command | Result |
|---------|--------|
| `ci"` | Changes "Hello World" to whatever you type |
| `di"` | Deletes "Hello World" (quotes remain) |
| `da"` | Deletes `"Hello World"` including quotes |
| `yi"` | Yanks "Hello World" |

**Practice:**
1. Place cursor inside any parentheses in this file, type `ci(`, type new text, press `Esc`
2. Place cursor inside any quotes, type `di"` to delete the contents
3. Type `u` to undo

---

## 13. Commenting

Your config uses native Neovim commenting (0.10+) enhanced by ts-comments.nvim for better language detection.

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on current line |
| `gc{motion}` | Toggle comment on motion (e.g., `gcip` comments a paragraph) |
| `gc` | Toggle comment on visual selection (in Visual mode) |
| `{number}gcc` | Toggle comment on `{number}` lines |
| `gcG` | Comment from cursor to end of file |
| `gcgg` | Comment from cursor to start of file |

### Common Combinations

| Key | Action |
|-----|--------|
| `gcc` | Comment/uncomment current line |
| `3gcc` | Comment/uncomment 3 lines |
| `gcip` | Comment/uncomment entire paragraph |
| `gc5j` | Comment/uncomment current line and 5 below |
| `V` then select then `gc` | Comment/uncomment selected lines |

**Practice:**
1. Place cursor on a line, type `gcc` to comment it
2. Type `gcc` again to uncomment
3. Select multiple lines with `V` and `j`, then type `gc`

---

## 14. Autopairs

Your config auto-closes brackets and quotes (nvim-autopairs). This works automatically in Insert mode.

| You Type | You Get | Notes |
|----------|---------|-------|
| `(` | `()` | Cursor placed between |
| `[` | `[]` | Cursor placed between |
| `{` | `{}` | Cursor placed between |
| `"` | `""` | Cursor placed between |
| `'` | `''` | Cursor placed between |
| `` ` `` | ` `` ` ` | Cursor placed between |

Autopairs is treesitter-aware: it won't add a closing quote if you're already inside a string.

When you complete a function via nvim-cmp, parentheses are added automatically:
`print` + Enter (in completion menu) becomes `print()`

**Practice:**
1. Enter Insert mode (`i`), type `(` and see `()` appear
2. Type some text between the parens
3. Try `{`, `[`, `"` to see them auto-close

---

## 15. Code Folding

Your config uses treesitter-based folding. Folds are open by default.

| Key | Action |
|-----|--------|
| `za` | Toggle fold under cursor (open/close) |
| `zo` | Open fold under cursor |
| `zc` | Close fold under cursor |
| `zR` | Open ALL folds in file |
| `zM` | Close ALL folds in file |
| `zO` | Open all folds under cursor (recursively) |
| `zC` | Close all folds under cursor (recursively) |
| `zj` | Move to next fold |
| `zk` | Move to previous fold |

**Practice:** Open a code file (e.g., `nvim ~/.config/nvim/init.lua`), then:
1. Type `zM` to close all folds
2. Navigate with `j`/`k` to see folded sections
3. Type `za` on a fold to toggle it open
4. Type `zR` to reopen everything

---

## 16. Indentation

Your config: 4 spaces per indent, tabs converted to spaces.

| Key | Action |
|-----|--------|
| `>>` | Indent current line right |
| `<<` | Indent current line left |
| `{number}>>` | Indent `{number}` lines right |
| `>ip` | Indent inner paragraph |
| `=ip` | Auto-indent inner paragraph |
| `gg=G` | Auto-indent entire file |
| `<leader>i` | Fix indentation in entire file (`Space i`) |

In Visual mode (select lines first):

| Key | Action |
|-----|--------|
| `>` | Indent selection right |
| `<` | Indent selection left |
| `=` | Auto-indent selection |

**Practice:**
1. Select several lines with `V` and `j`
2. Press `>` to indent, press `.` to repeat
3. Press `<` to unindent
4. Type `<leader>i` (`Space i`) to fix the whole file

---

## 17. File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `Ctrl+n` | Toggle file tree on/off |
| `<leader>e` | Focus file tree (`Space e`) |

### Inside nvim-tree

| Key | Action |
|-----|--------|
| `o` or `Enter` | Open file / expand directory |
| `Tab` | Preview file (don't leave tree) |
| `a` | Create new file or directory (add `/` at end for directory) |
| `d` | Delete file or directory |
| `r` | Rename |
| `x` | Cut (mark for move) |
| `c` | Copy (mark for copy) |
| `p` | Paste (move/copy marked files here) |
| `y` | Copy file name |
| `Y` | Copy relative path |
| `gy` | Copy absolute path |
| `I` | Toggle showing hidden files |
| `H` | Toggle showing dotfiles |
| `R` | Refresh tree |
| `q` | Close tree |
| `?` | Show help |

**Practice:**
1. Press `Ctrl+n` to open the file tree
2. Navigate with `j`/`k`, press `Enter` to open a file
3. Press `a` to create a new file, type a name, press `Enter`
4. Press `d` on a file to delete it (will ask confirmation)
5. Press `q` to close the tree

---

## 18. Fuzzy Finding (fzf)

| Key | Action |
|-----|--------|
| `Ctrl+p` | Find files |
| `<leader>ff` | Find files (`Space f f`) |
| `<leader>fg` | Grep (search text in files) (`Space f g`) |
| `<leader>fb` | Find open buffers (`Space f b`) |
| `<leader>fh` | Find recently opened files (`Space f h`) |

### Inside FZF Window

| Key | Action |
|-----|--------|
| `Ctrl+j` / `Ctrl+k` | Navigate results up/down |
| `Enter` | Open selected file |
| `Ctrl+t` | Open in new tab |
| `Ctrl+x` | Open in horizontal split |
| `Ctrl+v` | Open in vertical split |
| `Esc` | Close fzf window |

### FZF Commands

| Command | Action |
|---------|--------|
| `:Files` | Find files |
| `:GFiles` | Git files only |
| `:Rg {pattern}` | Search for text pattern in all files |
| `:Buffers` | List open buffers |
| `:Lines` | Search lines across all buffers |
| `:BLines` | Search lines in current buffer |
| `:History` | Recently opened files |
| `:History:` | Command history |
| `:Commits` | Git commits |
| `:BCommits` | Git commits for current file |
| `:Maps` | Show all key mappings |

**Practice:**
1. Press `Ctrl+p`, start typing a filename, press `Enter` to open it
2. Press `Space f g`, type a search term to find it across all files
3. Press `Space f b` to see your open buffers

---

## 19. Buffers

A buffer is an open file in memory. Your tabline (top bar, via lualine) shows all open buffers.

| Key | Action |
|-----|--------|
| `<leader>bn` | Next buffer (`Space b n`) |
| `<leader>bp` | Previous buffer (`Space b p`) |
| `<leader>bl` | List all buffers (`Space b l`) |
| `<leader>bd` | Close current buffer (`Space b d`) |
| `<leader>fb` | Fuzzy find buffers (`Space f b`) |

### Buffer Commands

| Command | Action |
|---------|--------|
| `:e {file}` | Open file in new buffer |
| `:bn` / `:bp` | Next / previous buffer |
| `:bd` | Close current buffer |
| `:ls` | List all buffers |
| `:b {number}` | Switch to buffer number |
| `:b {name}` | Switch to buffer by partial name |

**Practice:**
1. Open a few files with `:e filename`
2. Press `Space b n` and `Space b p` to navigate between them
3. Press `Space b d` to close the current one

---

## 20. Tabs

Tabs are separate viewports, each showing one or more buffers.

| Key | Action |
|-----|--------|
| `<leader>tn` | New tab (`Space t n`) |
| `<leader>tc` | Close tab (`Space t c`) |
| `<leader>tt` | Next tab (`Space t t`) |
| `<leader>to` | Close all other tabs (`Space t o`) |
| `<leader>tm` | Move tab (`Space t m`) |

### Tab Commands

| Command | Action |
|---------|--------|
| `:tabnew {file}` | Open file in new tab |
| `:tabn` / `:tabp` | Next / previous tab |
| `:tabc` | Close current tab |
| `:tabo` | Close all other tabs |

---

## 21. Splits

Split windows let you view multiple files or different parts of the same file simultaneously.

### Creating Splits

| Key | Action |
|-----|--------|
| `<leader>sv` | Vertical split (`Space s v`) |
| `<leader>sh` | Horizontal split (`Space s h`) |
| `:vsplit {file}` | Vertical split with file |
| `:split {file}` | Horizontal split with file |

### Navigating Splits (works with tmux too)

| Key | Action |
|-----|--------|
| `Ctrl+h` | Move to left split |
| `Ctrl+j` | Move to split below |
| `Ctrl+k` | Move to split above |
| `Ctrl+l` | Move to right split |
| `Ctrl+\` | Move to previous split |

### Managing Splits

| Command | Action |
|---------|--------|
| `:q` | Close current split |
| `:only` | Close all splits except current |
| `Ctrl+w =` | Make all splits equal size |
| `Ctrl+w _` | Maximize height of current split |
| `Ctrl+w |` | Maximize width of current split |
| `Ctrl+w +` / `Ctrl+w -` | Increase / decrease height |
| `Ctrl+w >` / `Ctrl+w <` | Increase / decrease width |
| `Ctrl+w r` | Rotate splits |
| `Ctrl+w H/J/K/L` | Move split to far left/bottom/top/right |

**Practice:**
1. Type `Space s v` to create a vertical split
2. Press `Ctrl+h` and `Ctrl+l` to move between splits
3. Type `:q` to close one split

---

## 22. LSP (Language Server)

LSP provides code intelligence. It activates automatically when you open supported files.

### Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Go to references (list all usages) |
| `Ctrl+o` | Jump back to previous location |
| `Ctrl+i` | Jump forward |

### Information

| Key | Action |
|-----|--------|
| `K` | Hover documentation (show type/docs for symbol under cursor) |
| `Ctrl+k` | Signature help (show function parameters) |
| `<leader>ld` | Show diagnostic in float window (`Space l d`) |

### Actions

| Key | Action |
|-----|--------|
| `<leader>rn` | Rename symbol everywhere (`Space r n`) |
| `<leader>ca` | Code action (auto-fix, refactor) (`Space c a`) |
| `<leader>lf` | Format buffer (`Space l f`) |

### Diagnostics (Errors/Warnings)

| Key | Action |
|-----|--------|
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |
| `<leader>ld` | Show diagnostic details (`Space l d`) |
| `<leader>lq` | Send all diagnostics to location list (`Space l q`) |

### LSP Signs in the Gutter

| Sign | Meaning |
|------|---------|
| `✘` | Error |
| `⚠` | Warning |
| `➤` | Hint |
| `ℹ` | Information |

### Mason (LSP Server Manager)

| Command | Action |
|---------|--------|
| `:Mason` | Open Mason UI |
| `:MasonUpdate` | Update all LSP servers |
| `:MasonInstall {name}` | Install a specific package |

**Practice:** Open a code file (Python, TypeScript, Lua, etc.), then:
1. Place cursor on a function name, press `K` to see docs
2. Press `gd` to jump to where it's defined
3. Press `Ctrl+o` to jump back
4. Press `gr` to see all references
5. Press `Space r n` to rename a symbol

---

## 23. Autocompletion (nvim-cmp)

Completion appears automatically as you type in Insert mode.

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Manually trigger completion menu |
| `Tab` | Select next completion item |
| `Shift+Tab` | Select previous completion item |
| `Enter` | Confirm selection |
| `Ctrl+e` | Close completion menu |
| `Ctrl+b` | Scroll docs up |
| `Ctrl+f` | Scroll docs down |

### Completion Sources (shown in menu)

| Label | Source |
|-------|--------|
| `[LSP]` | Language server suggestions |
| `[Snip]` | Snippet expansions |
| `[Buf]` | Words from current buffer |
| `[Path]` | File paths |

### Snippets (LuaSnip)

When a snippet is selected and expanded:

| Key | Action |
|-----|--------|
| `Tab` | Jump to next placeholder in snippet |
| `Shift+Tab` | Jump to previous placeholder |

### Command Line Completion

| Mode | Trigger | Sources |
|------|---------|---------|
| `/` (search) | Auto | Buffer words |
| `:` (command) | Auto | Paths, commands |

**Practice:**
1. Open a code file, enter Insert mode, start typing a function name
2. Use `Tab` to navigate the completion menu
3. Press `Enter` to confirm (autopairs adds parens for functions)
4. Press `Ctrl+Space` if the menu doesn't appear automatically

---

## 24. Formatting (conform.nvim)

Your config auto-formats files on save and trims trailing whitespace. You can also format manually.

| Key / Command | Action |
|---------------|--------|
| `:w` (save) | Automatically formats before saving |
| `<leader>lf` | Format buffer manually (`Space l f`) |
| `:ConformInfo` | Show which formatter is active |

### Configured Formatters

| Language | Formatter |
|----------|-----------|
| Lua | stylua |
| Python | black |
| JavaScript/TypeScript | prettier |
| JSON, YAML, HTML, CSS | prettier |
| Shell/Bash | shfmt |

Install formatters: `:MasonInstall stylua prettier black shfmt`

---

## 25. Git Integration

### Gitsigns (Inline)

Signs appear in the gutter next to modified lines.

| Sign | Meaning |
|------|---------|
| `│` | Added or modified line |
| `_` | Deleted line |
| `‾` | Top of deleted block |
| `~` | Changed and deleted |
| `┆` | Untracked file line |

### Hunk Navigation

| Key | Action |
|-----|--------|
| `]c` | Jump to next changed hunk |
| `[c` | Jump to previous changed hunk |

### Hunk Actions

| Key | Action |
|-----|--------|
| `<leader>hs` | Stage hunk (`Space h s`) |
| `<leader>hr` | Reset hunk (discard changes) (`Space h r`) |
| `<leader>hS` | Stage entire buffer (`Space h S`) |
| `<leader>hR` | Reset entire buffer (`Space h R`) |
| `<leader>hu` | Undo stage hunk (`Space h u`) |
| `<leader>hp` | Preview hunk (see what changed) (`Space h p`) |
| `<leader>hb` | Blame current line (`Space h b`) |
| `<leader>hd` | Diff this file (`Space h d`) |
| `<leader>hD` | Diff this against parent commit (`Space h D`) |
| `<leader>tb` | Toggle line blame on/off (`Space t b`) |
| `<leader>td` | Toggle showing deleted lines (`Space t d`) |

### Fugitive (Git Commands)

| Key | Action |
|-----|--------|
| `<leader>gs` | Open git status (`Space g s`) |
| `<leader>gh` | Get diff from right (merge conflicts) |
| `<leader>gu` | Get diff from left (merge conflicts) |

### Fugitive Commands

| Command | Action |
|---------|--------|
| `:G` or `:Git` | Interactive git status |
| `:Gwrite` | Stage current file (git add) |
| `:Gread` | Discard changes (git checkout) |
| `:Gcommit` | Commit |
| `:Gpush` | Push |
| `:Gpull` | Pull |
| `:Gblame` | Show git blame for file |
| `:Gdiff` | Show diff in split |
| `:Glog` | File history in quickfix |

**Practice:**
1. Open a file in a git repo
2. Make some changes
3. Press `Space h p` to preview the hunk
4. Press `Space h s` to stage it
5. Press `Space g s` to see git status

---

## 26. Undo Tree

Visualize your entire undo history as a tree (branches when you undo then edit).

| Key | Action |
|-----|--------|
| `F5` | Toggle undotree panel |

Inside undotree:

| Key | Action |
|-----|--------|
| `j` / `k` | Navigate history |
| `Enter` | Restore that state |
| `p` | Preview the change |
| `q` | Close |

**Practice:**
1. Make 5-6 different edits to a file
2. Undo a few with `u`
3. Make a new edit (this creates a branch)
4. Press `F5` to see the tree structure
5. Navigate to an older state and press `Enter` to restore it

---

## 27. Markdown Preview

| Key / Command | Action |
|---------------|--------|
| `<leader>mp` | Preview markdown in floating window (`Space m p`) |
| `:Glow` | Same as above |
| `:Glow!` | Close preview |
| `q` | Close the Glow window |

**Practice:** You're reading a markdown file right now. Press `Space m p` to see it rendered.

---

## 28. Spell Checking

| Key | Action |
|-----|--------|
| `<leader>sp` | Toggle spell check on/off (`Space s p`) |
| `]s` | Next misspelled word |
| `[s` | Previous misspelled word |
| `z=` | Show spelling suggestions |
| `zg` | Add word to dictionary (mark as good) |
| `zw` | Mark word as wrong |

**Practice:**
1. Press `Space s p` to enable spell check
2. Misspelled words will be highlighted
3. Press `]s` to jump to the next one
4. Press `z=` to see suggestions, type the number to accept

---

## 29. Which-Key

Press `<leader>` (Space) and wait 300ms to see all available keybindings organized by group.

| Group | Prefix | Contains |
|-------|--------|----------|
| Find | `<leader>f` | File, grep, buffer, history search |
| Git | `<leader>g` | Git status, diff commands |
| Hunk | `<leader>h` | Git hunk stage, reset, preview, diff |
| Tab | `<leader>t` | Tab management, toggle blame/deleted |
| Code | `<leader>c` | Code actions |
| Buffer | `<leader>b` | Buffer navigation (prev/next/list/close) |
| Split | `<leader>s` | Split management, spell toggle |
| LSP | `<leader>l` | Format, diagnostics, loclist |
| Rename | `<leader>r` | Rename symbol |
| Markdown | `<leader>m` | Markdown preview |

**Practice:** Press `Space` and wait. Read through the groups. Press a letter to see subgroups.

---

## 30. Command Mode Essentials

Press `:` to enter command mode.

### File Operations

| Command | Action |
|---------|--------|
| `:w` | Save file |
| `:q` | Quit (fails if unsaved changes) |
| `:wq` or `:x` | Save and quit |
| `:q!` | Quit without saving |
| `:wa` | Save all open files |
| `:qa` | Quit all |
| `:qa!` | Quit all without saving |
| `:e {file}` | Open file |
| `:e!` | Reload current file (discard changes) |
| `<leader>W` | Save with sudo (`Space W`) |

### Information

| Command | Action |
|---------|--------|
| `:checkhealth` | Check Neovim health |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP server manager |
| `:Maps` | Show all key mappings (via fzf) |
| `:set number?` | Check if a setting is enabled |

---

## 31. Macros

Record a sequence of keystrokes and replay them.

| Key | Action |
|-----|--------|
| `q{register}` | Start recording macro into register (e.g., `qa`) |
| `q` | Stop recording |
| `@{register}` | Play macro (e.g., `@a`) |
| `@@` | Replay last macro |
| `{number}@{register}` | Play macro `{number}` times |

**Practice:**
1. Move to a line, type `qa` to start recording into register `a`
2. Perform some edits (e.g., `I- ` to add a bullet, `Esc`, `j` to move down)
3. Type `q` to stop recording
4. Move to another line, type `5@a` to replay 5 times

---

## 32. Marks

Save positions to jump back to later.

| Key | Action |
|-----|--------|
| `m{a-z}` | Set mark in current file (e.g., `ma`) |
| `m{A-Z}` | Set global mark across files (e.g., `mA`) |
| `` `{mark} `` | Jump to exact mark position |
| `'{mark}` | Jump to line of mark |
| `` `. `` | Jump to last change |
| `` `" `` | Jump to last position before closing file |
| `:marks` | List all marks |

Your config auto-restores cursor position when reopening files.

**Practice:**
1. Press `ma` on any line to set mark `a`
2. Move far away in the file
3. Type `` `a `` to jump back to the exact spot

---

## 33. Registers

Registers store yanked/deleted text. Your clipboard is synced via `"` and `+` registers.

| Key | Action |
|-----|--------|
| `"{register}y{motion}` | Yank into specific register |
| `"{register}p` | Paste from specific register |
| `"ayy` | Yank line into register `a` |
| `"ap` | Paste from register `a` |
| `"+y` | Yank to system clipboard (automatic in your config) |
| `"+p` | Paste from system clipboard (automatic in your config) |
| `:reg` | Show contents of all registers |
| `"0p` | Paste last yank (not last delete) |

### Special Registers

| Register | Contains |
|----------|----------|
| `"` | Last yank or delete |
| `0` | Last yank only |
| `1-9` | Last 9 deletes (history) |
| `+` / `*` | System clipboard |
| `.` | Last inserted text |
| `:` | Last command |
| `/` | Last search pattern |
| `%` | Current filename |

**Practice:**
1. Yank a line with `"ayy` (store in register `a`)
2. Delete another line with `dd`
3. Type `"ap` to paste the line from register `a` (not the deleted line)
4. Type `:reg` to see all registers

---

## 34. Practice Exercises

### Exercise 1: Navigation
1. Open this file: `nvim ~/VIM_README.md`
2. Go to line 1: `gg`
3. Go to line 50: `50G`
4. Go to the last line: `G`
5. Search for "Exercise 2": `/Exercise 2` then Enter
6. Jump back: `Ctrl+o`
7. Scroll down half a page: `Ctrl+d`

### Exercise 2: Editing
1. Copy this line: `yy`
2. Paste it below: `p`
3. Change the word "Copy" to "Paste": place cursor on "Copy", type `ciw`, type "Paste", press `Esc`
4. Delete the pasted line: `dd`
5. Undo everything: press `u` until back to original

### Exercise 3: Working with Code
1. Open a code file: `Ctrl+p` and select one
2. Jump to a function definition: `gd`
3. See hover docs: `K`
4. Find all references: `gr`
5. Jump back: `Ctrl+o`
6. Rename a variable: `<leader>rn`, type new name, Enter

### Exercise 4: Multi-File Workflow
1. Open file tree: `Ctrl+n`
2. Navigate and open 3 different files
3. Switch between buffers: `Space b n` and `Space b p`
4. Open a vertical split: `Space s v`
5. Navigate between splits: `Ctrl+h` and `Ctrl+l`
6. Close the split: `:q`
7. Close all but one buffer: `Space b d` repeatedly

### Exercise 5: Git Workflow
1. Open a file in a git repo
2. Make some changes
3. Preview the changes: `Space h p`
4. Stage the hunk: `Space h s`
5. Open git status: `Space g s`
6. Close git status: `q`

### Exercise 6: Text Objects
1. Given `const name = "John Doe"`, place cursor inside quotes
2. Change the name: `ci"`, type new name, `Esc`
3. Given `function(arg1, arg2)`, place cursor inside parens
4. Delete the arguments: `di(`
5. Given a paragraph, delete it: `dap`
6. Undo: `u`

### Exercise 7: Visual Block (Column Editing)
1. Find several lines that start similarly
2. Press `Ctrl+v` to start block selection
3. Select down with `j` (several lines)
4. Press `I` to insert at the beginning of each line
5. Type `// ` to add a comment prefix
6. Press `Esc` and watch it apply to all selected lines

### Exercise 8: Macros
1. Create 5 lines of text like: `item 1`, `item 2`, `item 3`...
2. Go to the first line, start recording: `qa`
3. Add a dash and space at the start: `I- `, then `Esc`, then `j`
4. Stop recording: `q`
5. Replay on remaining lines: `4@a`

---

## Cheat Sheet: The Vim Language

Vim commands follow a grammar: **verb + count + noun**

### Verbs (Operators)
| Key | Verb |
|-----|------|
| `d` | Delete |
| `c` | Change (delete + enter Insert) |
| `y` | Yank (copy) |
| `v` | Visual select |
| `>` | Indent right |
| `<` | Indent left |
| `=` | Auto-indent |
| `gc` | Comment toggle |

### Nouns (Motions/Text Objects)
| Key | Noun |
|-----|------|
| `w` | Word |
| `W` | WORD (space-delimited) |
| `b` | Back a word |
| `$` | End of line |
| `0` | Start of line |
| `gg` | Top of file |
| `G` | Bottom of file |
| `ip` | Inner paragraph |
| `i"` | Inner quotes |
| `i(` | Inner parentheses |
| `i{` | Inner braces |
| `it` | Inner tag |

### Combining Them

| Command | Meaning |
|---------|---------|
| `d2w` | Delete 2 words |
| `ci"` | Change inside quotes |
| `yip` | Yank inner paragraph |
| `>3j` | Indent current line and 3 below |
| `gcip` | Comment inner paragraph |
| `da(` | Delete around parentheses |
| `y$` | Yank to end of line |
| `c3w` | Change 3 words |
| `dG` | Delete to end of file |
| `=ip` | Auto-indent paragraph |

Once you learn the verbs and nouns, you can combine any verb with any noun. This is the power of Vim's composable commands.
