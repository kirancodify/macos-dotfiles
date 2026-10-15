# --- Navigation & files -----------------------------------------------------
alias ls='eza --group-directories-first'
alias ll='eza -lah --git --group-directories-first'
alias tree='eza --tree --level=2'
alias cat='bat --paging=never'
alias ..='cd ..'
alias ...='cd ../..'

# --- Git --------------------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias gco='git checkout'
alias gp='git push'
alias gpf='git push --force-with-lease'

# --- Kubernetes -------------------------------------------------------------
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes -o wide'
alias kd='kubectl describe'
alias kl='kubectl logs -f --tail=200'
alias kev='kubectl get events --sort-by=.lastTimestamp'
alias kbad='kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded'

# --- Terraform --------------------------------------------------------------
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan -out=tfplan'
alias tfa='terraform apply tfplan'
alias tff='terraform fmt -recursive'
alias tfv='terraform validate'

# --- Docker -----------------------------------------------------------------
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# --- Misc -------------------------------------------------------------------
alias reload='exec zsh'
alias path='echo $PATH | tr ":" "\n"'
alias myip='curl -s https://ifconfig.me; echo'
