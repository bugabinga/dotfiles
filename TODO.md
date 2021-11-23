# To-Do

## Commands to remember

- sd: search and replace
- fd: find files recursively
- diskonaut: explore file system visually for large files
- btm (bottom): system overview
- rg: search file contents
- bat: show file content
- mdcat: render markdown in the terminal
- tokei: count lines of code
- hyperfine: benchmark tool
- menyoki: capture screenshots, record gifs
- rpick: Choose something out of predefined model using fancy algorithms
- tldr: tool documentation
- grex: regular expression pattern generator
- xh: make HTTP requests
- watchexec: filesystem watcher
- viu: view images in terminal (blocky approximation)
- licensor: print a license text
- pastel: manage colors
- hexyl: terminal hex viewer
- gib: generate gitignore files
- ix (indexa): global file search
- silicon: code pretty picture generator
- eva: calculator
- bandwhich: show network traffic information
- so: search Stack Exchange 
- linky: check markdown for broken links
- comrak: render markdown to html

## Stuff to do

- [ ] rewrite bootstripper and java commmands with zig. how to run them? precompile? zig run?
- [ ] encrypt box key
- [ ] get SIM card to work on x230
- [ ] disable syntax highlighting (treesitter) for inactive buffers and dim color
- [ ] port commands from vim-eunuch:
  - [ ] Delete
  - [ ] Move/Rename
  - [ ] Sudo/Doas
- [ ] LSP diagnostics only on BufWrite
- [ ] easier too read colors for lsp hovers
- [ ] crack nvim auto completion. how to configure it to my tastes?
- [ ] port keymaps in nvim config to cartographer
- [ ] test luadoc style docs. will it be rendered nicely in hovers?

## Done

- [x] how to abstract configs differences per platform? templates are painful to work with.
- [x] abstract indexa config for windows / linux
- [x] kill thy babbies: remove obsolete java commands. nu has builtins now for checksums and for random uuids
- [x] use [systemd user] instance to manage env vars
- [x] what to do about ssh and GPG keys? or secrets in general?
  - [x] say goodbye to GPG, too hard to manage.
- [x] how to handle java tools in `tools` cross platform?
- [x] sumneko on linux
- [x] is there something like glow but in rust?
- [x] get indexa config into dotfiles?

[systemd user]: https://wiki.archlinux.org/title/Systemd/User