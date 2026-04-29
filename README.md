# croc-send.yazi
Send selected files using croc

## Demo

<video src="https://github.com/user-attachments/assets/1c1dc456-2435-4543-8b5f-dade890f8da4" controls></video>

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) ≥ 25.5.28
- [croc](https://github.com/schollz/croc) installed and available in `$PATH`

## Installation

```sh
ya pkg add tasnimAlam/croc-send
```

Or clone manually:

```sh
git clone https://github.com/tasnimAlam/croc-send.yazi \
  ~/.config/yazi/plugins/croc-send.yazi
```

## Usage

Add a keybinding in `~/.config/yazi/keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["c", "s"]
run  = "plugin croc-send"
desc = "Send files with croc"
```

### Behaviour

- If files are **selected** (multi-select), all selected files are sent.
- If nothing is selected, the **hovered** file is sent.
- Yazi hands the terminal to croc so its passphrase and progress bar are fully visible.
- After the transfer completes, Yazi is restored.

The receiver runs:

```sh
croc <passphrase>
```
