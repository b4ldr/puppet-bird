#Bird::Filter
#
define bird::protocols::direct (
  $table         = undef,
  $debug         = 'off',
  $import_filter = 'all',
  $export_filter = 'none',
  $interfaces    = [],
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_string($import_filter)
  validate_string($export_filter)
  validate_array($interfaces)
  file { "${bird::config_dir}/protocols/direct-${name}.conf":
    ensure  => file,
    content => template('bird/etc/bird/protocols/direct.conf.erb'),
  }
}
