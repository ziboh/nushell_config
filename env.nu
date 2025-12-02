if ($nu.os-info.name != "windows") and not ("ENV_LOADED" in $env) {
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.cargo/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME + "/.local/share/bob/nvim-bin"))
  $env.PATH ++= ["~/.yarn/bin"]
}

if ($nu.os-info.name != "windows") {
  $env.PROJECT_DIRS = ($env.HOME | path join Projects)
  $env.ProgramData = "/mnt/c/ProgramData"
  $env.SCOOP = "/mnt/d/scoop"
  $env.SSH_AUTH_SOCK = "/run/user/1000/ssh-agent.socket"
  $env.GP_DIR = ($env.HOME | path join .local share gp)
} else {
  $env.PROJECT_DIRS = "D:\\zibo\\Documents\\projects"
  $env.HOME = $env.HOMEDRIVE + $env.HOMEPATH
  $env.GP_DIR = ($env.HOME | path join AppData Local gp)
  let bash_path = which bash | get path
  if ($bash_path | is-not-empty) {
    $env.CLAUDE_CODE_GIT_BASH_PATH = $bash_path | get 0
  }
}

$env.TOPIARY_LANGUAGE_DIR = ($env.HOME | path join .config topiary languages)
$env.TOPIARY_CONFIG_FILE = ($env.HOME | path join .config topiary languages.ncl)
$env.FZF_DEFAULT_OPTS = "--bind=tab:down --bind='shift-tab:up' --bind='ctrl-a:toggle-all' --cycle"
$env.ENV_LOADED = true
