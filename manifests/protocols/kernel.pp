#Bird::Filter
#
define bird::kernel (
  $table         = undef,
  $debug         = 'off',
  $learn         = true,
  $persist       = false,
  $scan_time     = 10,
  $import_filter = 'all',
  $export_filter = 'all',
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_bool($learn)
  validate_bool($persist)
  validate_integer($scan_time)
  validate_string($import_filter)
  validate_string($export_filter)
  file { "${bird::config_dir}/protocols/kernel.conf":
    ensure  => file,
    content => template('bird/etc/protocols/kernel.conf.erb'),
  }
}
