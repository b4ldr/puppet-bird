w
t
#bird::protocols::bgp::neighbor
#
define bird::protocols::bgp::neighbour (
  $template       = '',
  $ipv4_addresses = [],
  $ipv6_addresses = [],
  $multihop       = undef,
  $direct         = undef,
  $next_hop_self  = undef,
  $next_hop_keep  = undef,
  $missing_lladdr = undef,
  $gateway        = undef,
  $ttl_security   = undef,
  $password       = undef,
  $passive        = undef,
  $rs_client      = undef,
) {
  $asn = $name
  validate_string($template)
  validate_array($ipv4_addresses)
  validate_array($ipv6_addresses)
  if $multihop {
    validate_integer($multihop)
  }
  if $direct {
    validate_bool($direct)
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
