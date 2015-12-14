#Bird::Filter
#
class bird::filter (
  $content = undef,
) {
  validate_string($content)
}
