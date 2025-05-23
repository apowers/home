## Bash Home Environment
Any

* Configures Bash profile, Vim, tmux, git, rubocop, etc.

    setup_home.sh

My prompt tries to strike a balance between brevity and usefullness.

    [exit-code](HH:MM:SS)user@host:directory/$>

If you are in a git or hg repository it will show you which branch you are on.

    [0](00:00:00)user@host:directory/{branch}$>


# Development Environment
Ubuntu/Debian, CentOS, Fedora, Arch

* Install ruby and python development libraries.
* Install Docker and Vagrant.
* Install many other useful packages.

    setup_system.sh

## VirtualBox Shared Folder
echo 'Documents /home/apowers/Documents vboxsf rw,uid=1000,gid=1000,noauto 0 0' >> /etc/fstab
mkdir -p ~/.profile.d
echo 'sudo mount Documents' > ~/.profile.d/mount_documents.sh

## Window Manager
Install xfce4

Use a window theme with larger borders for easier grabbing.

* Settings -> Window Manager -> Style: Default
* Settings -> Keyboard -> Layout -> English/English(Dvorak)
* Terminal -> Edit -> Preferences -> Colors -> Text Color -> #AFAFAF
* Terminal -> Edit -> Preferences -> Appearance ->
** Ubuntu: DejaVu Sans Mono Book 9
** Arch: Dina 9

Note: You can also resize with ALT+R + click-drag

# Sublime Text
Ubuntu, Arch

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
Ubuntu/Debian, CentOS, Fedorao, Arch
Any (Chef only via RubyGems)

* Install Chef Repo
* Install Chef Standalone, Chef DevKit

    setup_chef.sh

