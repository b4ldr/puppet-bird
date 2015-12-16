#Bird::Filter
#
define bird::protocols::device (
  $table         = undef,
  $debug         = 'off',
  $scan_time     = 10,
  $primary       = undef
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_integer($scan_time)
  if $primary {
    validate_string($primary)
  }
  file { "${bird::config_dir}/protocols/device.conf":
    ensure  => file,
    content => template('bird/etc/protocols/device.conf.erb'),
  }
}
