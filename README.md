Bash Evnironment
====

Home Bash Environment Happiness

*.bashrc* - The workhorse, make your shell happy.
*.profile* - Sources .bashrc for login shells.
*.inputrc* - Remaps the up and down arrows to history search,
*.vimrc* - Configuration file for vim.
*.conkyrc* - Conkey configuration
*setup.sh* - Install packages that I like. Ubuntu/Debian only.

Installation
====
Copy each of the adove files to your home directory.
Relog or 'source .bashrc' and grin.

for F in .bashrc .profile .inputrc .vimrc;do wget --no-check-certificate https://raw.github.com/apowers/home/master/$F -O ~/$F;done

Tested on Ubunu, CentOS, and FreeBSD

Features
====
Many features not listed here, read the comments.
Enables emacs style CLI editing.
Enables the vim editor with many useful features.
Enables the less pager with some useful features.

The look of your prompt is a very personal thing for most people.
This prompt tries to strike a balance between brevity and usefullness.

    [exit-code](HH:MM:SS)user@host:directory/#>

If you are in a git repository it will show you which branch you are on.

    [0](00:00:00)user@host:directory/{branch}$>

Suggestions are welcome.
