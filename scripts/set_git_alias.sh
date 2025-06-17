#!/bin/bash

git config --global alias.l "log --pretty=format:%C(yellow)%h% %ad%Cred%d% %Creset%s%Cblue% [%cn] --decorate --date=short"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.ci "commit"
git config --global alias.br "branch"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.history "log --oneline --graph --decorate"
git config --global alias.update "!git co main && git fetch upstream main && git rebase upstream/main"
git config --global alias.b "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"

echo "Git aliases set successfully."
