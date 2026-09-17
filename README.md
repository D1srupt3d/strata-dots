# strata-dots

A small starter dotfiles repo for [strata](https://github.com/D1srupt3d/strata). Clone it, try it in a sandbox (your real home folder isn't touched), then make it your own.

It's deliberately tiny. Each file is here to show one strata feature, so you can see how it all works in five minutes and then swap in your own configs.

## 1. Try it (nothing in your home folder changes)

```sh
curl -fsSL https://raw.githubusercontent.com/D1srupt3d/strata/main/get.sh | sh   # install strata
git clone https://github.com/D1srupt3d/strata-dots.git && cd strata-dots
./try.sh            # sets up a fake home in ./.sandbox/ and applies the repo to it
./try.sh            # opens the strata TUI: layers, file states, variables
```

Things to try next:

```sh
ls -A .sandbox/home                          # what strata wrote
./try.sh edit .gitconfig                     # edit the source, see the diff, apply
echo "# hi" >> .sandbox/home/.zshrc          # change a file behind strata's back…
./try.sh status                              # …and it shows up as "drifted"
./try.sh apply                               # apply refuses to overwrite your edit
./try.sh add .zshrc                          # keep the edit: copy it into base/.zshrc
./try.sh reset && LAYERS=work ./try.sh       # start over as a "work" machine
```

`try.sh` just runs `strata` with three environment variables (`STRATA_HOME`, `STRATA_CONFIG`, `STRATA_STATE`) that point at `.sandbox/` instead of your real files. `./try.sh reset` deletes the sandbox.

## 2. Make it yours

1. On GitHub, click **Use this template → Create a new repository** (a private repo is a good idea). Or clone this repo and push it to a new one of your own.
2. Put your real configs in `base/`, using the same paths they have in your home folder: `~/.config/nvim/init.lua` goes in `base/.config/nvim/init.lua`. `strata add <file>` copies one in for you once strata is set up.
3. Set your git name and email under `[vars]` in `dots.toml`.
4. Delete anything you don't want. Every layer and every section of `dots.toml` is optional.

## 3. Use it for real

```sh
strata init git@github.com:<you>/<your-dotfiles>.git            # clones to ~/dotfiles and applies
strata init git@github.com:<you>/<your-dotfiles>.git --layers work   # a work machine
```

**This won't wipe your existing dotfiles.** If `~/.zshrc` already exists and differs from the repo, the first apply stops and lists it. Then, for each file:

```sh
strata diff              # compare your copy with the repo's
strata add .zshrc        # keep your copy (it goes into the repo)
strata apply --force     # or take the repo's copy for everything that's left
```

Day to day:

```sh
strata                   # TUI overview
strata edit .zshrc       # edit → diff → apply
strata status            # anything need attention?
strata sync              # on another machine: git pull + apply
```

strata doesn't commit or push anything for you. The repo is plain git, so commit and push the way you normally do.

## What's in here

```
dots.toml                     repo config: vars, permissions, hooks (all optional)
base/                         every machine gets these
  .zshrc  .bashrc             minimal shells; both load ~/.config/shell/*.sh
  .gitconfig                  uses {{git_name}} / {{git_email}} from dots.toml
  .config/git/ignore          global gitignore
  .config/shell/aliases.sh    aliases shared by zsh and bash
  .config/shell/os.sh         fallback, replaced by the OS layers below
mac/                          macOS only (picked automatically)
  .config/shell/os.sh         Homebrew setup — replaces base's os.sh
  .Brewfile                   packages (see the hook in dots.toml)
linux/                        Linux only (picked automatically)
  .config/shell/os.sh         Linux aliases — replaces base's os.sh
work/                         role layer: only machines that pick it at init
  .config/shell/work.sh
try.sh                        the sandbox runner (repo root, so never copied)
.github/workflows/check.yml   CI: dry-run apply on Linux + macOS
```

### The three ideas, and where each one shows up here

- **Layers replace whole files.** Layers stack as `base → OS → roles`. If two layers have the same path, the later layer's copy is used and the earlier one is ignored completely. For example, `mac/.config/shell/os.sh` replaces `base/.config/shell/os.sh` on a Mac. You can also add a distro layer next to `linux/` (such as `arch/` or `ubuntu/`), or a `windows/` layer.
- **Variables handle one-line differences.** If only an email address changes between machines, don't copy the whole file into another layer. Put `{{git_email}}` in the file, list the file in `substitute` in `dots.toml`, and set the value for each machine in `~/.config/strata/machine.toml`:
  ```toml
  [vars]
  git_email = "you@work.example"
  ```
- **Your local edits are safe.** strata remembers what it last wrote to each file. If you edit a file in your home folder yourself, apply won't overwrite it without `--force`.

## Tips and gotchas

- **Don't put secrets in this repo** (SSH private keys, tokens, `.env` files). Keep them only on the machine. Settings for one machine can go in files this repo doesn't track: `~/.zshrc.local`, `~/.bashrc.local` and `~/.gitconfig.local` are already loaded if they exist.
- **Files at the repo root are never copied.** strata only copies files that are inside a layer folder. So setup scripts, notes and this README are safe at the top level.
- **Hooks are real shell commands.** They run on `apply`, the same way a Makefile does. Only apply a dotfiles repo you trust.
- **Private files need a permissions rule.** git doesn't store file modes other than the executable bit, so `[permissions]` in `dots.toml` sets them instead. For example, `.ssh/**` gets `600`.
- **Keep CI turned on.** `check.yml` catches a broken `dots.toml`, an undefined `{{var}}` or a misspelled layer name before `strata sync` hits them on your machines. If you rename `work/` or add role layers, update `layers:` in the workflow too.

Full docs: [strata README](https://github.com/D1srupt3d/strata#readme).
