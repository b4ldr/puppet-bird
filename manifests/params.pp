#Class bird::params
#
class bird::params {
  $owner             = 'bird'
  $group             = 'bird'
  $package           = 'bird'
  $v4_service        = 'bird'
  $v6_service        = 'bird6'
  $v4_config_content = 'bird/etc/bird/bird.conf.erb'
  $v6_config_content = 'bird/etc/bird/bird6.conf.erb'
  $log_location      = 'syslog'
  $log_catagory      = 'warning'
  $router_id         = $::ipaddress
  $debug_protocols   = 'off'
  $debug_commands    = 0
  $mrtdump           = undef
  $mrtdump_protocols = 'off'
  $listen_bgp        = ['0.0.0.0']
  $restart_timeout   = 240
  $config_dir        = '/etc/bird'
  $v4_config_file    = "${config_dir}/bird.conf"
  $v6_config_file    = "${config_dir}/bird6.conf"
  $ipv4_enable       = true
  $ipv6_enable       = true
  $default_kernel    = true
  $default_device    = true
}
