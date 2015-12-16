#Bird::Filter
#
define bird::protocols::device (
  $table         = undef,
  $debug         = 'off',
  $import_filter = 'all',
  $export_filter = 'none',
  $scan_time     = 10,
  $primary       = undef
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_string($import_filter)
  validate_string($export_filter)
  if ! $import_filter in ['all', 'none'] and ! defined(Bird::Filter[$import_filter]) {
    fail("you must define bird::filter['${import_filter}']")
  }
  if ! $export_filter in ['all', 'none'] and ! defined(Bird::Filter[$import_filter]) {
    fail("you must define bird::filter['${export_filter}']")
  }
  validate_integer($scan_time)
  if $primary {
    validate_string($primary)
  }
  file { "${bird::config_dir}/protocols/device-${name}.conf":
    ensure  => file,
    content => template('bird/etc/bird/protocols/device.conf.erb'),
  }
}
