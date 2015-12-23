# Bash Home Environment
Ubuntu/Debian, CentOS, Fedora

* Configures Bash profile, Vim, etc.
* Install ruby and python development libraries.
* Install Docker and Vagrant.
* Install many other admin packages.

    setup_home.sh

My prompt tries to strike a balance between brevity and usefullness.

    [exit-code](HH:MM:SS)user@host:directory/$>

If you are in a git or hg repository it will show you which branch you are on.

    [0](00:00:00)user@host:directory/{branch}$>


## Minimal Installation
Ubuntu/Debian, CentOS, Fedora, FreeBSD

    for F in .bashrc .profile .inputrc .vimrc;do wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F;done

## Additional Configuration
xfce4

Use a window theme with larger borders for easier grabbing.

Settings -> Window Manager -> Style: Default

Note: You can also resize with ALT+R-click+drag

# Sublime Text
Ubuntu

* Install Sublime 3 PPA
* Install Sublime 3
* Install settings files

    setup_sublime.sh

## Additional Configuration

Install Package Control from: https://packagecontrol.io/installation
Sublime may need to restart several times.

CTRL+SHIFT+P, "Package Control: Install Package",

* GitGutter
* SideBarEnhancements
* SublimeLinter
* RuboCop
* Alignment (?)
* Syntax Matcher (?)
* Pretty YAML (?)
* Pretty JSON (?)
* JSON Lint (?)
* Rspec
* Puppet
* Chef
* Chefspec

Open the Folders tree:
    File -> Open Folder

# Puppet
Ubuntu/Debian, CentOS, Fedora

* Install Puppet
* Install Gems for Beaker, puppet-lint, rspec-puppet

    setup_puppet.sh

# Chef

TODO
