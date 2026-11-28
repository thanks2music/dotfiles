# iTerm2 のシェル統合と Claude Code 連携を試した記録

2026-11-28 に、iTerm2 の 2 つの機能（シェル統合と、Claude Code 連携）を入れて試した。シェル統合は残し、Claude Code 連携は外した。この文書は、何を試したかと、そう決めた理由をまとめる。

- 一次資料: [Shell Integration](https://iterm2.com/documentation-shell-integration.html) / [Claude Code Integration](https://iterm2.com/claude-code-integration.html)
- 前提: iTerm2 を開くと main セッション（tmux）に自動で入る（`dot.zshrc` の tmux の節、`bin/tmux-main`）。2 つ目以降の iTerm2 タブは tmux に入らない普通の zsh になる

## 結論

| 機能 | 判断 | 理由 |
|---|---|---|
| シェル統合 | **残す** | tmux の外のタブで効く。tmux の中では何もしないので害が無い |
| Claude Code 連携 | **外した** | 普通の tmux の中では Session Status も Workgroup も効かない。一方で hook は、どこで起動した Claude Code でも毎回走る |
| Python API | **OFF** | tmux の Claude には使い道が無く、ローカルのプログラムが iTerm2 を操作する入口が開くだけになる |

tmux での操作の方が使い慣れていて使いやすい。tmux で効かない機能は、深掘りしない。

## シェル統合

### 入れた物

- `curl -L https://iterm2.com/shell_integration/v2/install_shell_integration_and_utilities.sh | bash` で入れた（iTerm2 > Install Shell Integration のダイアログから）
- 本体: `~/.iterm2_shell_integration.zsh`（dotfiles では管理しない）
- ユーティリティ: `~/.iterm2/` に `imgcat`・`it2copy` などのスクリプトが 16 本。iTerm.app に同梱の同じ物（`/Applications/iTerm.app/Contents/Resources/utilities/`）以外とは、名前がぶつからない
  - `it2` だけはダウンロードが HTTP 500 で失敗した。iTerm.app に同梱の物があるので困らない
- `dot.zshrc` の末尾に読み込みの 1 行（PR #33）。`test -e` で守っているので、本体が無い Mac では何もしない
  - インストーラーは `iterm2_shell_integration` の文字列で既存の行を探す。行そのものを書き換えると、再インストールの時に行が重複する

### 試した結果

- **tmux の外のタブ**: プロンプトの左に青い三角のマークが出た。スクロールバーにも、マークの位置が横線で出る
- **tmux の中**: 効かない。公式の仕様どおり、既定で無効になっている。`ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1` を読み込みより前に export すると有効になるが、効くのは `tmux -CC`（iTerm2 の tmux 統合）の時だけで、普通の tmux の画面では動かない（公式）
- tmux の中でインストールすると、インストールのダイアログが回り続けて閉じない。ファイルは入り終わっているので、キャンセルで閉じてよい。ダイアログは新しいシェルからシェル統合の信号を待っているが、tmux の中では信号が届かないためと思われる（推測）

## Claude Code 連携

### 入れた物（外した後は残っていない）

- `~/.claude/settings.json` に、10 のイベント（SessionStart / SessionEnd / UserPromptSubmit / PreToolUse / PostToolUse / PermissionRequest / Notification / Stop / StopFailure / SubagentStop）の hook として `"~/.config/iterm2/it2" handle-agent-hook` が足された。既存の hook はすべて残っていた
- `~/.config/iterm2/it2` と `cc-status` は、iTerm.app の中のバイナリへの symlink。中に URL の文字列は無く、iTerm2 とはローカルのソケットでやりとりする。iTerm2 の外で動かしても exit 0 で終わり（約 0.25 秒）、Claude Code を止めない
- iTerm2 の設定に Workgroup と Session Status。Python API が ON になる

### 試した結果

| 起動した場所 | Session Status（⌘⇧B のツールベルト） | Workgroup（チャット / 差分 / コードレビューのバー） |
|---|---|---|
| tmux の外のタブ | （ツールベルトを開いていなかったので未確認） | 自動で入った。承認待ちの間は、ウィンドウのタイトルが「…への書き込み」に変わった |
| main セッションの中（ペインを 4 つにして 2 つで `claude`） | **何も出ない**。新しく起動しても出ない | 入らない（変な分割もできない） |

iTerm2 からは tmux 全体が 1 つのセッションに見えるので、ペインごとの Claude を区別できないためと思われる。

### 外した理由

- hook は `~/.claude/settings.json`（ユーザー全体の設定）に入るので、tmux・Zed・`claude -p` など、どこで起動した Claude Code でもイベントのたびに走る。tool を 1 回呼ぶと、前後で 2 回走る
- `~/.claude/settings.json` は avengers に吸い上げて管理している（`avengers/dot-claude/snapshot.sh`）。hook のパスはこの Mac の iTerm2 が作る symlink なので、連携を入れていない Mac では「コマンドが無い」エラーになる

### 外し方

1. iTerm2 > **Uninstall Claude Code Integration**。`settings.json` の hook、Workgroup、プロファイルの Enter/Exit のトリガーが消える
2. 続けて「Python API を無効にしますか」と聞かれるので、**無効にする**
3. 確認: `grep -c handle-agent-hook ~/.claude/settings.json` が 0、avengers のスナップショットとの差分が無い、`defaults read com.googlecode.iterm2 EnableAPIServer` が 0

`~/.config/iterm2/` の `it2`・`cc-status` の symlink は外した後も残るが、どこからも呼ばれないので害は無い。入れ直す時は、iTerm2 のメニューから再設定できる。

## 見直す時

- main セッションを `tmux -CC` に移すなら、シェル統合と Session Status がペインごとに効く可能性がある（公式の記述と推測。試していない）
- iTerm2 の Claude Code 連携が普通の tmux に対応したら、もう一度試す
