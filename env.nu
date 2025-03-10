if ($nu.os-info.name != "windows") and not ("ENV_LOADED" in $env) {
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.cargo/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/bin"))
  $env.path ++= ["~/.yarn/bin"]
  $env.PATH = ($env.PATH | split row (char esep) | prepend "~/.rye/shims")
}

if ($nu.os-info.name != "windows") {
  $env.PROJECT_DIRS = ($env.HOME | path join projects)
  $env.ProgramData = "/mnt/c/ProgramData"
  $env.SCOOP = "/mnt/d/scoop"
  $env.GP_DIR = ($env.HOME | path join .local share gp)
} else {
  $env.PROJECT_DIRS = "D:\\ziboh\\Documents\\projects"
  $env.HOME = $env.HOMEDRIVE + $env.HOMEPATH
  $env.GP_DIR = ($env.HOME | path join AppData Local gp)
}

$env.TOPIARY_LANGUAGE_DIR = ($env.HOME | path join .config topiary languages)
$env.TOPIARY_CONFIG_FILE = ($env.HOME | path join .config topiary languages.ncl)
$env.FZF_DEFAULT_OPTS = "--bind=tab:down --bind='shift-tab:up' --bind='ctrl-a:toggle-all' --cycle"
$env.ENV_LOADED = true
