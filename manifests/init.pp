# == Class: bird
#
class bird (
  $owner             = $::bird::params::owner,
  $group             = $::bird::params::group,
  $package           = $::bird::params::package,
  $v4_service        = $::bird::params::v4_service,
  $v6_service        = $::bird::params::v6_service,
  $v4_config_content = $::bird::params::v4_config_content,
  $v6_config_content = $::bird::params::v6_config_content,
  $log_location      = $::bird::params::log_location,
  $log_catagory      = $::bird::params::log_catagory,
  $router_id         = $::bird::params::router_id,
  $debug_protocols   = $::bird::params::debug_protocols,
  $debug_commands    = $::bird::params::debug_commands,
  $mrtdump           = $::bird::params::mrtdump,
  $mrtdump_protocols = $::bird::params::mrtdump_protocols,
  $listen_bgp        = $::bird::params::listen_bgp,
  $restart_timeout   = $::bird::params::restart_timeout,
  $config_dir        = $::bird::params::config_dir,
  $v4_config_file    = $::bird::params::v4_config_file,
  $v6_config_file    = $::bird::params::v6_config_file,
  $ipv4_enable       = $::bird::params::ipv4_enable,
  $ipv6_enable        = $::bird::params::ipv6_enable,
  $protocols_bgp     = {}
) inherits bird::params {

  validate_string($owner)
  validate_string($group)
  validate_string($package)
  validate_string($v4_service)
  validate_string($v6_service)
  validate_string($log_location)
  validate_re($log_catagory, '^(info|warning|error|fatal|debug|trace|remote|auth|bug)$')
  validate_absolute_path("/${v4_config_content}")
  validate_absolute_path("/${v6_config_content}")
  validate_ipv4_address($router_id)
  validate_re($debug_protocols, '^(all|off|states|routes|filters|interfaces|events|packets)$')
  validate_integer($debug_commands)
  if $mrtdump {
    validate_absolute_path($mrtdump)
  }
  validate_re($mrtdump_protocols, '^(all|off|states|messages)$')
  validate_array($listen_bgp)
  validate_integer($restart_timeout)
  validate_absolute_path($config_dir)
  validate_absolute_path($v4_config_file)
  validate_absolute_path($v6_config_file)
  validate_hash($protocols_bgp)

  ensure_packages([$package])
  file{ ["${config_dir}/protocols", "${config_dir}/templates"]:
    ensure  => directory,
    recurse => true,
    purge   => true,
  }
  file{ "${config_dir}/envvars":
    ensure  => file,
    content => "BIRD_RUN_USER=${owner}\nBIRD_RUN_GROUP=${group}\n",
  }
  file { $v6_config_file:
    ensure  => file,
    content => template($v6_config_content),
  }
  file { $v4_config_file:
    ensure  => file,
    content => template($v4_config_content),
  }
  if $ipv6_enable {
    service { $v6_service:
      ensure    => running,
      enable    => true,
      subscribe => File[$v6_config_file],
    }
  }
  if $ipv4_enable {
    service { $v4_service:
      ensure => running,
      enable => true,
      subscribe => File[$v4_config_file],
    }
  }
  create_resources('bird::protocols::bgp', $protocols_bgp)
}
