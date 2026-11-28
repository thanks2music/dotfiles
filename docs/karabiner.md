# Karabiner-Elements の設定と判断の記録

Karabiner-Elements のルールと、それぞれをそう決めた理由をまとめる。
Karabiner の設定だけでなく、同じ目的で変えた Claude Code と Zed のキー設定もここに記録する。

## 方針

- **アプリの既定の操作は変えない。** カスタムは「Hyper キーを押しているときだけ」にする。人に操作を教えるとき、既定の挙動を覚えていないと困るため
- **例外は Esc だけ。** Claude Code の質問 UI や生成中に Esc を押すと、取り消しや停止が起きる。vim の癖で Esc を押すことが多く、誤操作が続いていたため、Esc では止めず、止めるときは Hyper+Esc を押すようにした

## 設定ファイルの置き場所

| 対象 | 実体 | 管理方法 |
|---|---|---|
| Karabiner | `config/karabiner/`（`karabiner.json` と `assets/`） | `~/.config/karabiner` を**ディレクトリごと** symlink する。`setup.sh` の `phase_config` が自動で張る |
| Zed のキー設定 | `config/zed/keymap.json` | ファイル単位で symlink する。`setup.sh` の `phase_zed` が張る |
| Claude Code のキー設定 | `~/.claude/keybindings.json` | dotfiles ではなく avengers が管理する（cp 同期）。編集後に `avengers/dot-claude/snapshot.sh` で吸い上げる |

- `karabiner.json` 単体を symlink にしてはいけない。Karabiner は親ディレクトリを監視しているため、ファイル単体の symlink では変更を検知できず、設定が再読み込みされない（[公式](https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/)）
- `config/karabiner/automatic_backups/` は Karabiner が自動で作る履歴なので、`.gitignore` で除外している
- 設定は GUI で編集しても、`karabiner.json` を直接編集してもよい。どちらも保存した時点で反映される。反映されたかどうかは `~/.local/share/karabiner/log/console_user_server.log` に出る `core_configuration is updated.` で確認できる
- 新しい Mac に設定を置いた直後に読み込まれない場合は、`launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server-v3` を実行する。Karabiner 15 以降はサービス名の末尾に `-v3` が付く。公式ドキュメントの例には `-v3` が無いので、そのままでは見つからない

## ルール一覧

上から順に評価される。

| ルール | 動作 |
|---|---|
| `cmd+q` 長押し | `cmd+q` を 1 秒押し続けたときだけアプリを終了する。短く押しても何も起きない |
| Hyper（Tab 長押し） | Tab を押している間は ⌘+ctrl+⌥+⇧ を同時に押した状態になる（Shift は右 Shift として押す）。単独で押して離すと Tab |
| Hyper + h/j/k/l | ← ↓ ↑ → |
| Hyper + Space / 左⇧+Space | PageDown / PageUp |
| Hyper + g g / 左⇧+g | Home / End（ページの最上部 / 最下部）。g g は 500ms 以内に 2 回押す。1 回だけでは何も起きない |
| Hyper + o / t / p | Obsidian / Todoist / 1Password を前面に出す。起動していなければ起動する |
| Hyper + Esc | iTerm が前面のときだけ `ctrl+]` に変換する。Claude Code の取り消しに使う |
| ⌘ 単独 | 左 ⌘ は英数、右 ⌘ はかな |
| Caps Lock → Control | 単純なキー変換。MacBook の内蔵キーボード向け。HHKB は元からこの位置が Control |

## 判断の経緯

### `cmd+q` を長押しのときだけ有効にした

iTerm を `cmd+q` で誤って閉じたことがきっかけ。tmux のセッションは残っていたので復旧できたが、再接続の手間がかかった。

以前は長押しで終了するアプリ（qblocker の類）を使っていたが、macOS の更新に追従しなくなったため、Karabiner の公式機能 `to_if_held_down` に置き換えた。別のアプリを入れずに済み、Karabiner の更新に乗れる。

iTerm 側にも Settings → General → Closing の「Confirm "Quit iTerm2 (⌘Q)"」がある。Karabiner を止めているときの保険になる。

### Hyper を Tab にした

Hyper は、物理キー 1 つで ⌘+ctrl+⌥+⇧ を同時に押した状態を作る仕組みである。この 4 つを同時に使うショートカットを持つアプリはほぼ無いため、「Hyper + 文字」は既存のショートカットとぶつからない。

候補と、採用しなかった理由:

| 候補 | 採用しなかった理由 |
|---|---|
| 右 Option | Typeless の音声入力に使っている |
| 右 ⌘ | 単独押しのかなと併用できるが、右手は vim の操作で塞がっていて押しにくい |
| 左 Option | 単語移動（⌥+←→）、単語削除（⌥+delete）、Rectangle Pro の既定のショートカット（ctrl+⌥+矢印）が使えなくなる。右 Option も使えないので、Option が実質なくなる |
| Tab | **採用**。左手で押せる |

Tab には既知の弱点がある。押した瞬間には、Tab として使うのか Hyper として使うのかが決まらない。そのため、Tab の入力は**キーを離したとき**に送られる。また、Tab を押したまますぐに次の文字を打つと、Hyper + 文字と判定されることがある。これらは承知のうえで採用した。

- `shift+tab`（Claude Code のモード切り替えなど）はルールの対象外にしてあり、従来どおり動く
- Tab を 1 秒以上押してから離すと、Tab は送られない（Karabiner の `to_if_alone` の既定のタイムアウト）

### Hyper の Shift を右 Shift にした（左 Shift で逆方向にするため）

Hyper + Space で PageDown、Hyper + Shift + Space で PageUp、のように Shift で逆方向にしたかった。ところが Hyper は Shift も押した状態を作るため、そのままでは Shift の有無を見分けられない。

Karabiner は修飾キーを左右別に、押されているかどうか（オン / オフ）だけで判定する。Hyper が左 Shift を押していると、物理の左 Shift を足しても `left_shift` はオンのままで状態が変わらない。そのため「Hyper + Space」と「Hyper + 左 Shift + Space」はルールから同じに見える。

Tab は左手で押すので、逆方向も左 Shift で押したい。そこで Hyper が押す Shift を右 Shift に変えた。物理の左 Shift を足すと `left_shift` が新たにオンになるので見分けられる。

- 既存の Hyper ルール（hjkl・o/t/p・Esc）は条件を「Shift（左右どちらでも可）」で書いているので、そのまま動く
- アプリには従来どおり ⌘+ctrl+⌥+⇧ として届く。Zed の `cmd-ctrl-alt-shift-escape` も変わらない
- 代わりに「Hyper + 右 Shift」は見分けられない。使わない前提である
- 採用しなかった案: Hyper を変数方式（Tab 長押しで変数を立てるだけ）に作り直す案。Shift は自然に区別できるが、既存ルールと Zed の割り当てをすべて書き直す必要があり、割り当てのない Hyper + 文字がそのまま入力されるようになる

### スクロールは物理キーを送るだけにした

Hyper + h/j/k/l を矢印キーにしたのと同じ考え方で、PageDown / PageUp / Home / End のキーを送るだけにし、どう動くかはアプリに任せた。HHKB に無いこれらのキーを Hyper で補う意味もある。

- ⌘+↑/↓ を送る案は採用しなかった。Finder の ⌘+↑ は「親フォルダへ移動」で、全アプリ共通にすると事故が起きる
- iTerm では Home / End がシェルの行頭・行末への移動になり、スクロールにはならない。承知のうえでアプリごとの分岐は入れていない
- g g は vim と同じく 2 回押しにした。1 回目の Hyper + g で変数 `hyper_g_pending` を立て、500ms（Karabiner の `to_delayed_action` の既定）以内に 2 回目が来たら Home を送る。間に別のキーを押すと待ちは取り消される

### Esc で止めず、Hyper+Esc で止めるようにした

Claude Code は、iTerm でも Zed のエージェントパネルでも、Esc で質問 UI の取り消しや生成の停止が起きる。vim の癖で Esc を押してしまい、回答の途中で質問が閉じる事故が何度も起きていた。

Karabiner は画面の状態（いま質問 UI が出ているか）を知ることができない。そのため、Esc を無効にする設定は Claude Code と Zed の側に書き、Karabiner は Hyper+Esc を各アプリが受け取れるキーに変換するだけにした。

- **iTerm の Claude Code**（`~/.claude/keybindings.json`）
  - `Select` コンテキストで `escape` を `null` にし、`ctrl+]` を `select:cancel` に割り当てた
  - 端末には ⌘ を含む組み合わせが届かないため、Karabiner で Hyper+Esc を `ctrl+]` に変換している
  - `ctrl+\` は使わない。Claude Code 以外のプログラムが前面にあると SIGQUIT が送られ、そのプロセスが終了するため
  - 制約: 複数選択の質問は、割り当てたキーでは取り消せない（[公式](https://code.claude.com/docs/en/keybindings): "in a question where you can select several options, the bound key doesn't cancel, so cancel with Escape instead"）。Esc を外したので、複数選択の質問は回答して閉じる
  - 生成中の停止（`Chat` コンテキストの Esc）は既定のまま残している。停止がどのアクションに当たるかが公式ドキュメントに書かれておらず、確かめられていないため
- **Zed のエージェントパネル**（`config/zed/keymap.json`）
  - 質問カード（`Elicitation`）、vim ノーマルモードの入力欄、スレッド全体（`AcpThread`）で `escape` を `null` にした
  - Hyper+Esc（`cmd-ctrl-alt-shift-escape`）を、入力欄では `editor::Cancel`、スレッドでは `menu::Cancel` に割り当てた。どちらも生成の停止と質問の取り消しにつながる
  - vim の挿入モードからノーマルモードに戻る Esc（`vim::NormalBefore`）は壊さないよう、入力欄全体の Esc は `null` にしていない
  - コンテキスト名とアクション名は、Zed v1.30.2 のソース（`crates/agent_ui/src/message_editor.rs`、`assets/keymaps/default-macos.json`、`assets/keymaps/vim.json`）で確かめた。Zed の公式ドキュメントにはエージェントパネルのキー設定がほぼ書かれていない

### Zed でも `ctrl+j` で改行できるようにした

iTerm の Claude Code では、`ctrl+j` で送信せずに改行する（`chat:newline` の既定）。Zed のエージェントパネルは `shift+enter` / `ctrl+enter` で改行する。両方を使い分けるのが手間なので、Zed のエージェント入力欄に `ctrl-j` → `editor::Newline` を追加した。Zed の既定の `shift+enter` / `ctrl+enter` も残っている。

### 入れなかったもの

- **日本語入力の自動英数化**（Esc やアプリの切り替えで英数に戻す）: 今は ⌘ 単独押しで足りている
- **Rectangle Pro の操作を Hyper に集約する**: 今のショートカットで困っていない
- **アプリ切り替え全般**: macOS のデスクトップをアプリごとに分け、`ctrl+数字` で切り替えている。Hyper でのアプリ切り替えは、`cmd+tab` で探しにくい「常駐しているが、たまにしか使わないアプリ」だけにした

## 参考

- [Karabiner-Elements: 設定ファイルの場所と symlink](https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/)
- [Karabiner-Elements: to_if_held_down](https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/to-if-held-down)
- [Karabiner-Elements: 外部の JSON 生成ツール](https://karabiner-elements.pqrs.org/docs/json/external-json-generators/)（ルールが増えて JSON が読みにくくなったら karabiner.ts などを検討する）
- [Claude Code: keybindings](https://code.claude.com/docs/en/keybindings)
- [Zed: Key bindings](https://zed.dev/docs/key-bindings)（`null` で既定の割り当てを外せること）
- [HHKB / Karabiner の Mac 移行時の教訓](hhkb-karabiner-migration.md)
