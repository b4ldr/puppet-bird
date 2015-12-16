#Bird::Filter
#
define bird::protocols::static (
  $table         = undef,
  $debug         = 'off',
  $routes        = [],
  $check_link    = false,
  $import_filter = 'all',
  $export_filter = 'all',
  $igp_table     = undef,
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_array($routes)
  validate_bool($check_link)
  validate_string($import_filter)
  validate_string($export_filter)
  if $igp_table {
    validate_string($igp_table)
  }
  file { "${bird::config_dir}/protocols/static.conf":
    ensure  => file,
    content => template('bird/etc/protocols/static.conf.erb'),
  }
}
