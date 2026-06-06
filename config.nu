$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.completions.quick = true
$env.config.completions.sort = "alphabetical"

def --env set-proxy [] {
  $env.http_proxy = "http://localhost:7890"
  $env.https_proxy = "http://localhost:7890"
}

def --env unset-proxy [] {
  hide-env -i http_proxy
  hide-env -i https_proxy
}

def is-wsl [] {
  $nu.os-info.name == "linux" and ('/proc/sys/fs/binfmt_misc/WSLInterop' | path exists)
}

def is-win [] {
  $nu.os-info.name == "windows"
}

def is-linux [] {
  $nu.os-info.name == "linux"
}

def is-running-wsl [cmd: string] {
  let command_str = "ps | where name =~ '" + $cmd + "'"
  let processes = (nu.exe -c $command_str)
  let count = ($processes | lines | length)
  if ($count > 3) {
    true
  } else {
    false
  }
}

def is-running [cmd: string] {
  let cmd_base = $cmd | str replace -r '\.exe$' ''
  let processes = (ps)

  let matching_processes = $processes | where {|proc|
      let proc_name = $proc.name | str replace -r '\.exe$' ''
      ($proc_name | str downcase) == ($cmd_base | str downcase)
    }

  ($matching_processes | length) > 0
}

if (is-wsl) {
  $env.WSL_ROUTER_IP = (ip route | grep default | awk '{print $3}')
  $env.GIT_SSH = "/mnt/c/Windows/System32/OpenSSH/ssh.exe"
} else if $nu.os-info.name == "linux" {
  $env.RIME_LS_SYNC_DIR = $env.HOME + "/rclone/rime_ls"
}

def --env clash [] {
  if (is-wsl) {
    if (is-running-wsl clash-verge) {
      $env.http_proxy = ("http://" + $env.WSL_ROUTER_IP + ":7890")
      $env.https_proxy = ("http://" + $env.WSL_ROUTER_IP + ":7890")
    } else {
      unset-proxy
    }
  } else if (is-win) or (is-linux) {
    if ((is-running flclash) or (is-running clash-verge)) {
      set-proxy
    } else {
      unset-proxy
    }
  }
}

clash

mkdir ($nu.data-dir | path join vendor autoload)
ls ($nu.data-dir | path join vendor autoload) | each {|it| rm $it.name }
mut custom_completions = [scoop rustup adb uv]
if ($nu.os-info.name != "windows") {
  $custom_completions = $custom_completions | append tar
}
for completion in $custom_completions {
  open ($env.PROJECT_DIRS | path join nu_scripts custom-completions $completion $"($completion)-completions.nu") | save -f ($nu.data-dir | path join vendor autoload $"($completion)-completions.nu")
}

starship init nu | save -f ($nu.data-dir | path join vendor autoload starship.nu)
if (which tree-sitter | is-not-empty) and ($nu.default-config-dir | path join completions tree-sitter.nu | path exists) {
  open ($nu.default-config-dir | path join completions tree-sitter.nu) | save -f ($nu.data-dir | path join vendor autoload tree-sitter.nu)
}
open ($env.PROJECT_DIRS | path join nu_scripts modules fnm fnm.nu) | save -f ($nu.data-dir | path join vendor autoload fnm.nu)
zoxide init nushell | save -f ($nu.data-dir | path join vendor autoload zoxide.nu)

# 从encrypt.json文件设置环境变量
def --env load-encrypt-env [] {
  let encrypt_file = ($env.HOME | path join "encrypt.json")
  if ($encrypt_file | path exists) {
    let env_vars = (open $encrypt_file)
    for key in ($env_vars | columns) {
      load-env {($key): ($env_vars | get $key)}
    }
  } else {
    print "encrypt.json not found in user directory"
  }
}

# 加载encrypt.json中的环境变量
load-encrypt-env

# 命令别名
alias lg = lazygit
alias top = btm
alias vim = nvim
alias v = nvim
alias nano = nvim
alias ff = fastfetch
alias yay = paru
alias yadm = chezmoi
alias ll = lsd

if (is-linux) {
  $env.config.keybindings ++= [
    {
      name: toggle_sudo
      modifier: alt
      keycode: char_/
      mode: [emacs vi_insert vi_normal]
      event: {
        send: executehostcommand
        cmd: "let cmd = (commandline); commandline edit (if $cmd starts-with sudo { $cmd | str replace -r '^sudo ' '' } else { 'sudo ' ++ $cmd });"
      }
    }
  ]
}

def wtedit [] {
  if ($nu.os-info.name == "windows") {
    let wt_config = "~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    chezmoi edit $wt_config; chezmoi apply $wt_config
  } else {
    print "This command is only available on Windows"
  }
}

mkdir ($nu.data-dir | path join vendor completions)
bob complete nushell | save -f ($nu.data-dir | path join "vendor/autoload/bob.nu")
carapace _carapace nushell | save --force ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# fzf 配置
$env.FZF_DEFAULT_OPTS = "--bind=tab:down --bind=shift-tab:up --bind=ctrl-j:down --bind=ctrl-k:up --cycle"

source nvim.nu
