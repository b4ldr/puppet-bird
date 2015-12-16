#Bird::Filter
#
define bird::protocols::static (
  $table         = undef,
  $debug         = 'off',
  $import_filter = 'all',
  $export_filter = 'none',
  $routes        = [],
  $check_link    = false,
  $igp_table     = undef,
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_string($import_filter)
  validate_string($export_filter)
  validate_array($routes)
  validate_bool($check_link)
  if $igp_table {
    validate_string($igp_table)
  }
  file { "${bird::config_dir}/protocols/static-${name}.conf":
    ensure  => file,
    content => template('bird/etc/bird/protocols/static.conf.erb'),
  }
}
