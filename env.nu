if ($nu.os-info.name != "windows") and not ("ENV_LOADED" in $env) {
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.cargo/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/bin"))
  $env.PATH = ($env.PATH | split row (char esep) | prepend "~/.rye/shims")
}

if ($nu.os-info.name != "windows") {
  $env.PROJECT_DIRS = ($env.HOME | path join projects)
} else {
  $env.PROJECT_DIRS = "D:\\ziboh\\Documents\\projects"
}

$env.TOPIARY_LANGUAGE_DIR = ($env.HOME | path join .config topiary languages)
$env.TOPIARY_CONFIG_FILE = ($env.HOME | path join .config topiary languages.ncl)
$env.FZF_DEFAULT_OPTS = "--bind=tab:down --bind='shift-tab:up' --bind='ctrl-a:toggle-all' --cycle"
$env.ENV_LOADED = true
