# fzf-tmux-named-snapshot

A fork of [tmux-named-snapshot](https://github.com/spywhere/tmux-named-snapshot) with fzf integration for interactive snapshot selection.

This plugin allows you to save and restore
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) snapshots
into its own separate snapshot, making it easy to keep track of tmux session setup.

## Getting Started

This plugin is shipped with these key bindings

- `Prefix + Ctrl-m`: Save 'manual' snapshot
- `Prefix + M`: Open fzf menu to save snapshot (create new or overwrite existing)
- `Prefix + Ctrl-n`: Restore 'manual' snapshot
- `Prefix + N`: Prompt for a name and restore the snapshot by that name
- `Prefix + Ctrl-f`: Open fzf menu to select and restore a snapshot

### FZF Menu

The fzf menu provides an interactive way to browse, save, and restore snapshots:

**Restore menu** (`Prefix + Ctrl-f`):
- Shows all saved named snapshots
- Use arrow keys or Ctrl-j/Ctrl-k to navigate
- Press Enter to restore selected snapshot
- Press Ctrl-d to delete selected snapshot
- Press Esc to cancel

**Save menu** (`Prefix + M`):
- Shows existing snapshots (for overwriting)
- Type a new name to create a new snapshot
- Select an existing snapshot to overwrite it
- Press Enter to save
- Press Esc to cancel

Check out [Configurations](#configurations) section below to customize the
key bindings and any additional options.

## Configurations

- `@named-snapshot-save`  
Description: A list of key mapping to be bound to save command  
Default: `C-m:manual`  
Values: a space separated keymap, in which consists of colon separated strings
- `@named-snapshot-restore`  
Description: A list of key mapping to be bound to restore command  
Default: `C-n:manual N:*`  
Values: a space separated keymap, in which consists of colon separated strings

Each mapping should consists of key and its corresponding snapshot name. So
a mapping of `C-m:manual` will map a `manual` snapshot to `C-m` key binding.

A special snapshot name `*` will prompt for a snapshot name before
performing the action.

You can always map multiple key bindings to the same snapshot name.

- `@named-snapshot-switch-client`  
Description: A specification of an optional
[switch-client](<https://man7.org/linux/man-pages/man1/tmux.1.html#:~:text=SIGTSTP%20(tty%20stop).-,switch%2Dclient,-%5B%2DElnprZ%5D%20%5B>)
keybinding to define all specified save/restore bindings in a separate "namespace".  
Default: _Empty_ (not used by default)  
Values: a colon separated strings with "key:table_name"

- `@named-snapshot-dir`  
Description: A path (without a trailing slash) to the directory for storing
named snapshots (missing directory will **NOT** be created automatically)  
Default: _Empty_ (default to `@resurrect_dir` option)  
Value: a string to be used as a path

- `@named-snapshot-fzf`  
Description: Key binding to open fzf menu for selecting and restoring snapshots  
Default: `C-f` (Ctrl+f)  
Value: a key string (set to empty string to disable)

- `@named-snapshot-fzf-save`  
Description: Key binding to open fzf menu for saving snapshots  
Default: `M`  
Value: a key string (set to empty string to disable)

- `@named-snapshot-delete-key`  
Description: Key binding inside fzf menu to delete selected snapshot  
Default: `ctrl-d`  
Value: a key string for fzf binding

### Examples

To setup the key bindings, the configuration should be put in `.tmux.conf`
file.

For example,

```
set -g @named-snapshot-save 'C-m:manual C-d:dev'
set -g @named-snapshot-restore 'C-n:manual N:* D:dev'
```

will setup the following key bindings

- `Prefix + Ctrl-m`: Save 'manual' snapshot
- `Prefix + M`: Open fzf menu to save snapshot
- `Prefix + Ctrl-d`: Save 'dev' snapshot
- `Prefix + Ctrl-n`: Restore 'manual' snapshot
- `Prefix + N`: Prompt for a name and restore the snapshot by that name
- `Prefix + D`: Restore 'dev' snapshot

You can also define a separate "namespace" for all save/restore bindings using `switch-client`
feature in `tmux`.

To do this, define the `@named-snapshot-switch-client` parameter with a value of type `N:tns`,
where `N` (stands for `Named`) is the preferred key to enter "Named Snapshot Mode" and `tns`
(stands for `tmux-named-snapshot`) is the name of the key-table for the switch-client.

For example,

```
set -g @named-snapshot-switch-client 'N:tns'
set -g @named-snapshot-save 'm:manual p:* d:dev'
set -g @named-snapshot-restore 'M:manual P:* D:dev'
```

will setup the following key bindings

- `Prefix + N`: To enter "Named Snapshot Mode"

While in this mode:

- `m`: Save 'manual' snapshot
- `p`: Prompt for a name and save the snapshot under that name
- `d`: Save 'dev' snapshot
- `M`: Restore 'manual' snapshot
- `P`: Prompt for a name and restore the snapshot by that name
- `D`: Restore 'dev' snapshot

## Installation

### Requirements

Please note that this plugin utilize multiple unix tools to deliver its
functionalities (most of these tools should be already installed on most unix systems)

- `sed`
- `cut`
- `readlink`
- `cmp`
- `fzf` (required for fzf menu feature)

### Using [TPM](https://github.com/tmux-plugins/tpm)

```
set -g @plugin 'yoomaxxx/fzf-tmux-named-snapshot'
```

### Manual

Clone the repo

```
$ git clone https://github.com/yoomaxxx/fzf-tmux-named-snapshot ~/target/path
```

Then add this line into your `.tmux.conf`

```
run-shell ~/target/path/named-snapshot.tmux
```

Once you reloaded your tmux configuration, all the format strings in the status
bar should be updated automatically.

## License

MIT
