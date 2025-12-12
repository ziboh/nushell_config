$env.NVIM_DEFAULT_CONFIG = ""
$env.NVIM_APPNAME = "Mini"

def nvims [
  --cmd: string             # Execute <cmd> before any config
  -c: string                # Execute <cmd> after config and first file
  -l: string                # Execute Lua <script> (with optional args)
  -S: string                # Source <session> after loading the first file
  -s: string                # Read Normal mode commands from <scriptin>
  -u: string                # Use this config file
  -d                        # Diff mode
  --es                      # Silent (batch) mode
  --Es                      # Silent (batch) mode
  --help(-h)                # Print this help message
  -i: string                # Use this shada file
  -n                        # No swap file, use memory only
  -o: int                   # Open N windows (default: one per file)
  -O: int                   # Open N vertical windows (default: one per file)
  -p: int                   # Open N tab pages (default: one per file)
  -R                        # Read-only (view) mode
  --version(-v)             # Print version information
  -V: string                # Verbose [level][file]
  --api-info                # Write msgpack-encoded API metadata to stdout
  --clean                   # Factory defaults (skip user config and plugins, shada)
  --embed                   # Use stdin/stdout as a msgpack-rpc channel
  --headless                # Don't start a user interface
  --listen: string          # Serve RPC API from this address
  --remote: string          # Execute commands remotely on a server
  --server: string          # Connect to this Nvim server
  --startuptime: string     # Write startup timing messages to <file>
  ...files: path            # Files to open
] {
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
  
  mut nvim_args = []
  
  if $cmd != null { $nvim_args = ($nvim_args | append [--cmd $cmd]) }
  if $c != null { $nvim_args = ($nvim_args | append [-c $c]) }
  if $l != null { $nvim_args = ($nvim_args | append [-l $l]) }
  if $S != null { $nvim_args = ($nvim_args | append [-S $S]) }
  if $s != null { $nvim_args = ($nvim_args | append [-s $s]) }
  if $u != null { $nvim_args = ($nvim_args | append [-u $u]) }
  if $d { $nvim_args = ($nvim_args | append [-d]) }
  if $es { $nvim_args = ($nvim_args | append [-es]) }
  if $Es { $nvim_args = ($nvim_args | append [-Es]) }
  if $help { $nvim_args = ($nvim_args | append [--help]) }
  if $i != null { $nvim_args = ($nvim_args | append [-i $i]) }
  if $n { $nvim_args = ($nvim_args | append [-n]) }
  if $o != null { $nvim_args = ($nvim_args | append $"-o($o)") }
  if $O != null { $nvim_args = ($nvim_args | append $"-O($O)") }
  if $p != null { $nvim_args = ($nvim_args | append $"-p($p)") }
  if $R { $nvim_args = ($nvim_args | append [-R]) }
  if $version { $nvim_args = ($nvim_args | append [--version]) }
  if $V != null { $nvim_args = ($nvim_args | append [-V $V]) }
  if $api_info { $nvim_args = ($nvim_args | append [--api-info]) }
  if $clean { $nvim_args = ($nvim_args | append [--clean]) }
  if $embed { $nvim_args = ($nvim_args | append [--embed]) }
  if $headless { $nvim_args = ($nvim_args | append [--headless]) }
  if $listen != null { $nvim_args = ($nvim_args | append [--listen $listen]) }
  if $remote != null { $nvim_args = ($nvim_args | append [--remote $remote]) }
  if $server != null { $nvim_args = ($nvim_args | append [--server $server]) }
  if $startuptime != null { $nvim_args = ($nvim_args | append [--startuptime $startuptime]) }
  
  ^nvim ...$nvim_args ...$files
}

def nvim [
  --cmd: string             # Execute <cmd> before any config
  -c: string                # Execute <cmd> after config and first file
  -l: string                # Execute Lua <script> (with optional args)
  -S: string                # Source <session> after loading the first file
  -s: string                # Read Normal mode commands from <scriptin>
  -u: string                # Use this config file
  -d                        # Diff mode
  --es                      # Silent (batch) mode
  --Es                      # Silent (batch) mode
  --help(-h)                # Print this help message
  -i: string                # Use this shada file
  -n                        # No swap file, use memory only
  -o: int                   # Open N windows (default: one per file)
  -O: int                   # Open N vertical windows (default: one per file)
  -p: int                   # Open N tab pages (default: one per file)
  -R                        # Read-only (view) mode
  --version(-v)             # Print version information
  -V: string                # Verbose [level][file]
  --api-info                # Write msgpack-encoded API metadata to stdout
  --clean                   # Factory defaults (skip user config and plugins, shada)
  --embed                   # Use stdin/stdout as a msgpack-rpc channel
  --headless                # Don't start a user interface
  --listen: string          # Serve RPC API from this address
  --remote: string          # Execute commands remotely on a server
  --server: string          # Connect to this Nvim server
  --startuptime: string     # Write startup timing messages to <file>
  ...files: path            # Files to open
] {
  mut args = []
  
  if $cmd != null { $args = ($args | append [--cmd $cmd]) }
  if $c != null { $args = ($args | append [-c $c]) }
  if $l != null { $args = ($args | append [-l $l]) }
  if $S != null { $args = ($args | append [-S $S]) }
  if $s != null { $args = ($args | append [-s $s]) }
  if $u != null { $args = ($args | append [-u $u]) }
  if $d { $args = ($args | append [-d]) }
  if $es { $args = ($args | append [-es]) }
  if $Es { $args = ($args | append [-Es]) }
  if $help { $args = ($args | append [--help]) }
  if $i != null { $args = ($args | append [-i $i]) }
  if $n { $args = ($args | append [-n]) }
  if $o != null { $args = ($args | append $"-o($o)") }
  if $O != null { $args = ($args | append $"-O($O)") }
  if $p != null { $args = ($args | append $"-p($p)") }
  if $R { $args = ($args | append [-R]) }
  if $version { $args = ($args | append [--version]) }
  if $V != null { $args = ($args | append [-V $V]) }
  if $api_info { $args = ($args | append [--api-info]) }
  if $clean { $args = ($args | append [--clean]) }
  if $embed { $args = ($args | append [--embed]) }
  if $headless { $args = ($args | append [--headless]) }
  if $listen != null { $args = ($args | append [--listen $listen]) }
  if $remote != null { $args = ($args | append [--remote $remote]) }
  if $server != null { $args = ($args | append [--server $server]) }
  if $startuptime != null { $args = ($args | append [--startuptime $startuptime]) }
  
  let expanded_files = $files | each { |f| $f | path expand }
  
  if 'NVIM' in $env {
    ^nvim --server $env.NVIM --remote ...$args ...$expanded_files
  } else {
    ^nvim ...$args ...$expanded_files
  }
}

def my-command [
  --optimize(-O): int # 定义一个短标志 -O，它期望一个整数值
  message: string # 一个必需的位置参数
] {
  $"Optimized to level ($optimize) with message: ($message)"
}
