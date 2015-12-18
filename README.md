Bash Evnironment
====

Home Bash Environment Happiness

*.bashrc* - The workhorse, make your shell happy.

*.profile* - Sources .bashrc for login shells.

*.inputrc* - Remaps the up and down arrows to history search,

*.vimrc* - Configuration file for vim.

*.conkyrc* - Conkey configuration

*setup_home.sh* - Install packages that I like. (Ubuntu/Debian, CentOS, Fedora)

Installation
====
Copy each of the adove files to your home directory.
Relog or 'source .bashrc' and grin.

    for F in .bashrc .profile .inputrc .vimrc;do wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F;done

Tested on Ubunu, CentOS, and FreeBSD

For full install:

    wget --no-check-certificate https://raw.github.com/apowers/home/master/setup_home.sh -O ~/setup_home.sh;sudo sh ~/setup_home.sh

Features
====
* Configures Bash profile, Vim, etc.
* Install ruby and python development libraries.
* Install Docker and Vagrant

The look of your prompt is a very personal thing for most people.
This prompt tries to strike a balance between brevity and usefullness.

    [exit-code](HH:MM:SS)user@host:directory/#>

If you are in a git or hg repository it will show you which branch you are on.

    [0](00:00:00)user@host:directory/{branch}$>

Suggestions are welcome.

Sublime
===

    add-apt-repository ppa:webupd8team/sublime-text-2
    apt-get install sublime-text


Package Control
https://packagecontrol.io/installation

CTRL+SHIFT+P, "Package Control: Install Package", "Puppet", "Sublimelint", "GitGutter"

Puppet
===
* Install Puppet
* Install Gems for Beaker, puppet-lint, rspec-puppet

    setup_puppet.sh

Chef
===
TODO
