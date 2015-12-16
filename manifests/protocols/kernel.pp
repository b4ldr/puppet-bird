#Bird::Filter
#
define bird::protocols::kernel (
  $table         = undef,
  $debug         = 'off',
  $import_filter = 'all',
  $export_filter = 'none',
  $learn         = true,
  $persist       = false,
  $scan_time     = 10,
) {
  if $table {
    validate_string($table)
  }
  validate_re($debug,'^(all|off|states|routes|filters|events|packets)$')
  validate_string($import_filter)
  validate_string($export_filter)
  validate_bool($learn)
  validate_bool($persist)
  validate_integer($scan_time)
  file { "${bird::config_dir}/protocols/kernel-${name}.conf":
    ensure  => file,
    content => template('bird/etc/bird/protocols/kernel.conf.erb'),
  }
}
