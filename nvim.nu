$env.NVIM_DEFAULT_CONFIG = ""
$env.NVIM_APPNAME = "Mini"

def nvims [...args] {
  # 定义配置数组
  let configs = [
    "default"
    "Mini|ziboh/nvim-mini"
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
  ^nvim ...$args
}

def "nu-complete nvim" [spans: list<string>] {  
    carapace $spans.0 nushell ...$spans | from json  
}  
  
@complete "nu-complete nvim"  
def nvim [...rest: string ] {
  if 'NVIM' in $env {
    let absolute_rest = $rest | each { |arg|
      if ($arg | str starts-with '-') {
        $arg  # 保留选项
      } else {
        $arg | path expand  # 转换为绝对路径
      }
    }
    ^nvim --server $env.NVIM --remote ...$absolute_rest
  } else {
    ^nvim ...$rest
  }
}
