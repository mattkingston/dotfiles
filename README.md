
# Dotfiles

### What is it?

A collection of starter dotfiles for OS level settings and applications.

## Usage

To setup the dotfiles just run the appropriate snippet in the terminal:

| OS | Snippet |
|:---:|:---|
| OS X | `bash -c "$(curl -kLsSH 'Cache-Control: no-cache' https://raw.github.com/mattkingston/dotfiles/master/setup.sh)"` |
| Ubuntu | `bash -c "$(wget --no-check-certificate --no-cache -qO - https://raw.github.com/mattkingston/dotfiles/master/setup.sh)"` |

### Install actions

1. Checks for suitable OS versions (Ubuntu >= 14.04 or OSX >= 10.9)
1. Downloads the dotfiles tarball to your computer
1. Backs up existing dotfiles - Anything that gets modified by the installer is backed up if it exists
1. Allows you to set up proxy settings
1. Installs applications / command-line tools for
  [OS X](install/osx/install_applications.sh) /
  [Ubuntu](install/ubuntu/install_applications.sh)
1. Installs NVM to ~/.dotfiles/nvm
1. Installs default NPM global packages
1. Installs RVM to ~/.dotfiles/rvm
1. Installs [vim plugins](install/dotfiles/vimrc#L128-L165)
1. Sets custom
  [OS X](install/osx/preferences/set_preferences.sh) /
  [Ubuntu](install/ubuntu/preferences/set_preferencez.sh) preferences
1. Sets up Github SSH keys

## Customize

### Local Settings

The dotfiles can be easily extended to suit additional local requirements
by using the following files:

#### `~/.bashrc.local`

If the `~/.bashrc.local` file exists, it will be [automatically sourced](install/dotfiles/bash_profile#L6).

#### `~/.gitconfig.local`

If the `~/.gitconfig.local` file exists, it will be automatically
included after the configurations from `~/.gitconfig`, thus, allowing
its content to overwrite or add to the existing `git` configurations.

__Note:__ Use `~/.gitconfig.local` to store sensitive information such
as the `git` user credentials or proxy information, e.g.:

#### `~/.vimrc.local`

If the `~/.vimrc.local` file exists, it will be automatically sourced
after `~/.vimrc`, thus, allowing its content to add or overwrite the
settings from `~/.vimrc`.

#### `~/.gvimrc.local`

Same as `~/.vimrc.local` but for `~/.gvimrc`.

## Acknowledgements

I would like to thank the following superb developers for their ideas, and
great code which I was able to learn from, extend upon and in some areas
shamelessly copy.

* [Cătălin Mariș dotfiles](https://github.com/alrra/dotfiles)
* [Mathias Bynens dotfiles](https://github.com/mathiasbynens/dotfiles)
* [Paul Irish dotfiles](https://github.com/paulirish/dotfiles)
* [Ben Alman dotfiles](https://github.com/cowboy/dotfiles)

## License

The code is available under the [MIT license](LICENSE.txt).
