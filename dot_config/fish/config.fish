set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

fish_add_path --path --move ~/.local/bin

if test -x ~/.local/bin/mise
    ~/.local/bin/mise activate fish --shims | source
end

if command -q hx
    set -gx EDITOR hx
else if command -q nvim
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end
set -gx VISUAL $EDITOR

if status is-interactive
    if test -x ~/.local/bin/mise
        ~/.local/bin/mise activate fish | source
    end

    if command -q starship
        starship init fish | source
    end

    if command -q zellij
        abbr -a tmux zellij
    end

    if command -q zoxide
        zoxide init fish | source
        abbr -a cd z
    end

    if command -q eza
        abbr -a ls eza
        abbr -a la 'eza -la'
        abbr -a larg 'eza -la | rg'
        abbr -a ll 'eza -l'
        abbr -a tree 'eza --tree -L 2'
        abbr -a treee 'eza --tree -L 3'
    end

    if command -q bat
        abbr -a cat bat

        function h
            $argv --help 2>&1 | bat --language=help --style=plain
        end
    end

    if command -q chezmoi
        abbr -a cz chezmoi
    end

    set -g fish_greeting
    set -g fish_key_bindings fish_vi_key_bindings
    set -Ux COLORTERM truecolor
    # run ssh-agent
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    if not test -S "$SSH_AUTH_SOCK"
        ssh-agent -c -a "$SSH_AUTH_SOCK" | source
    end
end
