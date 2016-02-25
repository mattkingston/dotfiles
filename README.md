
# Dotfiles

### What is it?

A collection of starter dotfiles for OS level settings and applications.

## Usage

To setup the dotfiles just run the appropriate snippet in the terminal:

| OS | Snippet |
|:---:|:---|
| OS X | `bash -c "$(curl -kLsS https://raw.github.com/mattkingston/dotfiles/master/install)"` |
| Ubuntu | `bash -c "$(wget --no-check-certificate -qO - https://raw.github.com/mattkingston/dotfiles/master/install)"` |

### Install actions

1. Checks for suitable OS versions (Ubuntu >= 14.04 or OSX >= 10.9)
1. Downloads the dotfiles on your computer
1. Asks where to install the dotfiles project (by default it will suggest
  `~/projects/dotfiles`)
1. Creates some additional [directories](os/create_directories.sh)
1. [Symlink](os/create_symbolic_links.sh)s the
  [git](git),
  [shell](shell), and
  [vim](vim) files
1. Installs applications / command-line tools for
  [OS X](os/os_x/installs/main.sh) /
  [Ubuntu](os/ubuntu/installs/main.sh)
1. Sets custom
  [OS X](os/os_x/preferences/main.sh) /
  [Ubuntu](os/ubuntu/preferences/main.sh) preferences
1. Installs [vim plugins](vim/vim/plugins)

## Customize

### Local Settings

The dotfiles can be easily extended to suit additional local requirements by using the following files:

#### `~/.bash.local`

If the `~/.bash.local` file exists, it will be automatically sourced after all the other [bash related files](shell), thus, allowing its content to add to or overwrite the existing aliases, settings, PATH, etc.

#### `~/.gitconfig.local`

If the `~/.gitconfig.local` file exists, it will be automatically included after the configurations from `~/.gitconfig`, thus, allowing its content to overwrite or add to the existing `git` configurations.

__Note:__ Use `~/.gitconfig.local` to store sensitive information such as the `git` user credentials or proxy information, e.g.:

#### `~/.vimrc.local`

If the `~/.vimrc.local` file exists, it will be automatically sourced
after `~/.vimrc`, thus, allowing its content to add or overwrite the
settings from `~/.vimrc`.

#### `~/.gvimrc.local`

Same as `~/.vimrc.local` but for `~/.gvimrc`.

## Acknowledgements

Thanks to [Cătălin’s dotfiles](https://github.com/alrra/dotfiles) for the idea to make an automatic installer and the way in which that process happens. Also for the sane preferences and applications which has been copied in whole.

## License

The code is available under the [MIT license](LICENSE.txt).
