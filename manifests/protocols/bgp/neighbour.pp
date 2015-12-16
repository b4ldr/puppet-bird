w
t
#bird::protocols::bgp::neighbor
#
define bird::protocols::bgp::neighbour (
  $table         = undef,
  $debug         = undef,
  $template       = '',
  $ipv4_addresses = [],
  $ipv6_addresses = [],
  $multihop       = undef,
  $next_hop_self  = undef,
  $next_hop_keep  = undef,
  $missing_lladdr = undef,
  $gateway        = undef,
  $ttl_security   = undef,
  $password       = undef,
  $passive        = undef,
  $rs_client      = undef,
  $import_filter  = undef,
  $export_filter  = undef,
) {
  $asn = $name
  if $table {
    validate_string($table)
  }
  if $debug {
    validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  }
  validate_string($template)
  validate_array($ipv4_addresses)
  validate_array($ipv6_addresses)
  if $multihop {
    validate_integer($multihop)
  }
  if $next_hop_self {
    validate_bool($next_hop_self)
  }
  if $next_hop_keep {
    validate_bool($next_hop_keep)
  }
  if $missing_lladdr {
    validate_re($missing_lladdr, '^(self|drop|ignore)$')
  }
  if $gateway {
    validate_re($gateway, '^(direct|recursive)$')
  }
  if $ttl_security {
    validate_bool($ttl_security)
  }
  if $password {
    validate_string($password)
  }
  if $passive {
    validate_bool($passive)
  }
  if $rs_client {
    validate_bool($rs_client)
  }
  if $import_filter {
    validate_string($import_filter)
    if ! ( $import_filter in ['all', 'none'] ) 
        and ! defined(Bird::Filter[$import_filter]) {
      fail("you must define bird::filter['${import_filter}']")
    }
  }
  if $export_filter {
    validate_string($export_filter)
    if ! ( $export_filter in ['all','none'] ) 
        and ! defined(Bird::Filter[$import_filter]) {
      fail("you must define bird::filter['${export_filter}']")
    }
  }

  if $bird::ipv4_enable {
    file { "${bird::config_dir}/protocols/v4-bgp-${name}.conf":
      ensure  => present,
      content => template('bird/etc/bird/protocols/v4-bgp-neighbour.conf.erb'),
      notify  => Service[$bird::v4_service],
    }
  }
  if $bird::ipv6_enable {
    file { "${bird::config_dir}/protocols/v6-bgp-${name}.conf":
      ensure  => present,
      content => template('bird/etc/bird/protocols/v6-bgp-neighbour.conf.erb'),
      notify  => Service[$bird::v6_service],
    }
  }
}
