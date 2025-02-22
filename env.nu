$env.PATH = ($env.PATH | prepend ($env.HOME + "/.cargo/bin"))
$env.PATH = ($env.PATH | prepend ($env.HOME + "/bin"))
$env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/bin"))
$env.PATH = ($env.PATH | split row (char esep) | prepend "~/.rye/shims")
$env.FZF_DEFAULT_OPTS = "--bind=tab:down --bind='shift-tab:up' --bind='ctrl-a:toggle-all' --cycle"
