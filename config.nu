$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

def --env set-proxy [] {
  $env.http_proxy = "http://localhost:7890"
  $env.https_proxy = "http://localhost:7890"
}

def --env unset-proxy [] {
  hide-env -i http_proxy
  hide-env -i https_proxy
}

def is-running [cmd: string] {
  let command_str =  "ps | where name =~ '" + $cmd + "'"
  let processes = (nu.exe -c $command_str)
  let count = ($processes | lines | length)
  if ($count > 3) {
    true
  } else {
    false
  }
}

def is-wsl [] {
  $nu.os-info.name == "linux" and ('/proc/sys/fs/binfmt_misc/WSLInterop' | path exists)
}

if (is-wsl) {
  $env.WSL_ROUTER_IP = (ip route | grep default | awk '{print $3}')
  $env.GIT_SSH = "/mnt/c/Windows/System32/OpenSSH/ssh.exe"
} else if $nu.os-info.name == "linux" {
  $env.RIME_LS_SYNC_DIR = $env.HOME + "/rclone/rime_ls"
}

def --env clash [] {
  if not (is-wsl) {
    return
  }
  if (is-running clash-verge) {
    $env.http_proxy = ("http://" + $env.WSL_ROUTER_IP + ":7890")
    $env.https_proxy = ("http://" + $env.WSL_ROUTER_IP + ":7890")
  } else {
    unset-proxy
  }
}

$env.NVIM_DEFAULT_CONFIG = ""

# 检查并安装配置的函数
def check_and_install_config [config_name: string configs: list<string>] {
  let config_folder = if ($nu.os-info.name == "windows") {
    "C:\\Users\\" + $env.USERNAME + "\\AppData\\Local\\"
  } else {
    $env.HOME + "/.config/"
  }
  for cfg in $configs {
    let parts = ($cfg | split row "|")
    if (($parts | length) != 2) {
      continue
    }
    let name = $parts.0
    let repo = $parts.1
    if ($config_name == $name) and (not (($config_folder + $name) | path exists)) {
      print ($name + " config not found. Installing...")
      let full_repo = if ($repo =~ '://') {
        $repo
      } else {
        "https://github.com/" + $repo
      }
      git clone $full_repo ($config_folder + $name)
      break
    }
  }
}

def nvims [] {
  # 定义配置数组
  let configs = [
    "default"
    "LazyVim|LazyVim/starter"
    "AstroNvim|https://github.com/AstroNvim/template"
    "NormalNvim|NormalNvim/NormalNvim"
  ]
  # 提取配置名称用于fzf选择
  let items = (
    $configs | each {|it|
      if ($it =~ '|') {
        $it | split row "|" | get 0
      } else {
        $it
      }
    }
  )

  # 选择配置
  mut config = (echo ($items | str join "\n") | fzf --prompt=" Neovim Config »" --height "50%" --layout=reverse --border --exit-0)
  if ($config | is-empty) {
    return
  }

  # 处理default配置
  if ($config == "default") {
    $config = ''
  } else {
    check_and_install_config $config $configs
  }

  $env.NVIM_APPNAME = $config
  nvim
}

mkdir ($nu.data-dir | path join vendor autoload)
ls ($nu.data-dir | path join vendor autoload) | each {|it| rm $it.name }
mut custom_completions = [cargo git npm scoop rustup curl gh rg ssh rye]
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
alias lg = lazygit
open ($env.PROJECT_DIRS | path join nu_scripts modules fnm fnm.nu) | save -f ($nu.data-dir | path join vendor autoload fnm.nu)
zoxide init nushell | save -f ($nu.data-dir | path join vendor autoload zoxide.nu)
source ~/encrypt.nu
