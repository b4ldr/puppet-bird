#bird::protocols::bgp
#
define bird::protocols::bgp (
  $local_as       = undef,
  $multihop       = false,
  $direct         = true,
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
  validate_integer($local_as)
  if $multihop {
    validate_integer($multihop)
  }
  validate_bool($direct)
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

  file { "${bird::config_dir}/templates/bgp-${name}.conf":
    ensure  => present,
    content => template('bird/etc/bird/templates/bgp.conf.erb'),
    notify  => Service[$bird::v4_service, $bird::v6_service],
  }
  create_resources('bird::protocols::bgp::neighbour', $neighbours)
}
