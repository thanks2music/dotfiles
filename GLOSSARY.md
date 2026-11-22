# dotfiles

The shell, terminal and editor environment for the owner's Macs, kept reproducible through symlinks and setup scripts.

## Language

### Terminal workspace

**Main session**:
The one long-lived tmux session named `main`, holding the windows the owner works in every day. iTerm2 attaches to it on launch, and it is built from scratch only when it does not exist.
_Avoid_: workspace, session 0 / 1 / 2

**Window**:
A tmux window inside the main session, shown in the tmux status bar as `<index>:<name>` (for example `1:Revo`). The owner calls these "tabs"; they are not iTerm2 tabs.
_Avoid_: tab (when the tmux window is meant)

**Pane**:
One split region of a window, opened in a project directory.
_Avoid_: split, screen
