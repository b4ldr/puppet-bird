#Bird::Filter
#
define bird::protocols::direct (
  $table         = undef,
  $debug         = 'off',
  $interfaces    = [],
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_array($interfaces)
  file { "${bird::config_dir}/protocols/direct-${name}.conf":
    ensure  => file,
    content => template('bird/etc/bird/protocols/direct.conf.erb'),
  }
}
