#bird::protocols::bgp
#
define bird::protocols::bgp (
  $table          = undef,
  $debug          = 'off',
  $import_filter  = 'all',
  $export_filter  = 'none',
  $local_as       = undef,
  $multihop       = false,
  $next_hop_self  = false,
  $next_hop_keep  = false,
  $missing_lladdr = undef,
  $gateway        = undef,
  $ttl_security   = false,
  $password       = undef,
  $passive        = false,
  $rs_client      = false,
  $neighbours     = {},
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_integer($local_as)
  if $multihop {
    validate_integer($multihop)
  }
  validate_bool($next_hop_self)
  validate_bool($next_hop_keep)
  if $missing_lladdr {
    validate_re($missing_lladdr, '^(self|drop|ignore)$')
  }
  if $gateway {
    validate_re($gateway, '^(direct|recursive)$')
  }
  validate_bool($ttl_security)
  if $password {
    validate_string($password)
  }
  validate_bool($passive)
  validate_bool($rs_client)
  validate_hash($neighbours)
  validate_string($import_filter)
  validate_string($export_filter)
  if ! $import_filter in ['all', 'none'] and ! defined(Bird::Filter[$import_filter]) {
    fail("you must define bird::filter['${import_filter}']")
  }
  if ! $export_filter in ['all', 'none'] and ! defined(Bird::Filter[$import_filter]) {
    fail("you must define bird::filter['${export_filter}']")
  }

  if $bird::ipv4_enable and $bird::ipv6_enable {
    $notify = Service[$bird::v4_service, $bird::v6_service]
  } elsif $bird::ipv4_enable {
    $notify = Service[$bird::v4_service]
  } elsif $bird::ipv6_enable {
    $notify = Service[$bird::v6_service]
  } else {
    fail('ipv4 or ipv6 must be enabled')
  }

  file { "${bird::config_dir}/templates/bgp-${name}.conf":
    ensure  => present,
    content => template('bird/etc/bird/templates/bgp.conf.erb'),
    notify  => $notify,
  }
  create_resources('bird::protocols::bgp::neighbour', $neighbours)
  Bird::Protocols::Bgp::Neighbour[keys($neighbours)] { template => $name, }
}
