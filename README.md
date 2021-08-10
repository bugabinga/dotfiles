# bugabingas personal dotfiles, 33rd attempt

Shared configuration files between some Linux and some Windows hosts.

## bootstrapping a new host

1. Install git
1. Install a JDK
1. git clone git@github.com:bugabinga/dotfiles
1. `cd dotfiles`
1. `java bootstripper.java .`

> Pay attention to already existing symlinks!

## rough goals

- minimal amount of dependencies
  This helps in setting up new host.
  But it is really hard to achieve when hosts are allowed to be Windows and Linux AND [OpenBSD] ...
  The current state is a compromise reached after some experimentation.
- editing and applying configs is "natural"
  Natural in this context is to mean: as if there was no dotfiles repository used for sharing.
  This is achieved by symlinking the files from the dotfiles repository into their normal locations.
  So when it comes time to edit a confg file, you can stay blissfully unaware of the dotfiles repository.

## handling per host differences

There are two classes of differences in configurations between platforms (specifically Linux and Windows in my case).

### differing locations of config files

For example, [NeoVim] stores its configuration at `~/.config/nvim` in Linux and at `~/AppData/Roaming/nvim` in Windows.
In order to handle theses differences each host gets its own symlink file wiht the naming pattern `(hostname).symlinks`.
The format of this file is:
```
path to configuration file/directory relative to dotfiles root
absolute path of symlink on host
```
Each symlink path pair is to be delimited by a newline.
Example:
```
neovim
~/.config/nvim

foo/bar.conf
~/.config/foobar.conf
```
This file will be parsed by [bootstripper] in order to create those symlinks.

### differing values in configration files

Most often, these come down to different paths of stuff, that get refered to in config files.
For example, [topgrade], an abstraction over a bunch of package managers and updaters, might want to know the location of your git repositories, so it can pull them for you.
Some programs, e.g. [NeoVim], have rich configuration languages that are powerful enough for you to resolve those differences with conditionals.
However some programs, e.g. [topgrade], offer only declarative configuration languages, which make it impossible to resolve this problem in the config.
I tried solving this problem with some kind of a templating engine.
But I quickly gave up on that, because it was too annoying to manage.
Specifically, editing configuration stopped being "natural", meaning you cannot simply open and edit the file at the location you expect the config to be anymore.
This natural flow is the reason symlinks are used.
With templating in the mix, an intermediary step is necessary, between editing and applying config.
Too much work.
Instead, I use the `(hostname).symlink` files to resolve such cases.
That means, that config files are completely independent per host, and as such some duplication of configuration occurs.
A tradeoff well worth it in my opinion.

## secrets

Secrets are encrypted and saved as file into the `tresor` folder.
The name of these file is a random UUID, which I map to their original purpose somewhere else.
Those secret files are decrypted either by [bootstripper] or on demand in my scripts.

## the trouble with bootstrapping dotfiles

Most of my previous attempts at managing my configuration files failed because it is tricky to share them between Windows and Unix systems.
If all my hosts were Unix(y), I would write a POSIX shell script and be done with it.
But that does not work for Windows.

Since I find it important to be able to setup my configuration files on any fresh new host, it is important to have as few dependencies as possible.
However, with Windows in the mix, this is pretty hard, so I settled on a compromise: JDK.

Things I tried in the past to solve this problem:

- dotfiles managers (e.g. [chezmoi])
  > too much work
- writing a bootstrap/installer with [cosmopolitan]
  > extremely cool tech. unfortunatelly I am not a C programmer so I struggled a lot.
  > also, the resulting binary rewrites itself on first run. How do I keep a file version controlled that is allowed to change on first use, but should not result in a new modification...?
  > furthermore, managing the [cosmopolitan] toolchain for windows made extra work.
- use POSIX shell for Unix, use PowerShell for Windows
  > too much work. maintaining the same program in 2 different languages ... depressing not because you have to write twice, but because you have to test twice.
- Pretend Windows is Unix by only interfacing with it through [WSL].
  > Windows is not Unix. [WSL] is cute, even useful for cross-compilation and testing. But when I am on Windows I want to use Windows, when I am on Linux I want to use Linux. Fighting the platform constantly is too tiring.

Things I have not tried (yet?):

- Use a language with a pleasant cross-compile story ([golang], [Rust], [ziglang]) and version control a binary for those platforms I care about.
- Use [PowerShell Core] and maybe a script per platform to install it. This could be nice if [PowerShell Core] would replace [PowerShell Windows] and it was my main shell.

[NeoVim]: https://neovim.io/
[topgrade]: https://github.com/r-darwish/topgrade
[bootstripper]: https://github.com/bugabinga/dotfiles/blob/trunk/bootstripper.java
[chezmoi]: https://github.com/twpayne/chezmoi
[golang]: https://golang.org/
[Rust]: https://www.rust-lang.org/
[ziglang]: https://ziglang.org/
[WSL]: https://docs.microsoft.com/en-us/windows/wsl/about
[PowerShell Core]: https://github.com/PowerShell/PowerShell
[PowerShell Windows]: https://de.wikipedia.org/wiki/PowerShell
[OpenBSD]: https://www.openbsd.org/
