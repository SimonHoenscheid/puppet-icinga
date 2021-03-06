# @summary
# This class manages the stages stable, testing and snapshot of packages.icinga.com repository
# and depending on the operating system platform some other repositories.
#
# @param [Boolean] manage_stable
#   Manage the Icinga stable repository. Disabled by setting to 'false'. Defaults to 'true'.
#
# @param [Boolean] manage_testing
#   Manage the Icinga testing repository to get access to release candidates.
#   Enabled by setting to 'true'. Defaults to 'false'.
#
# @param [Boolean] manage_nightly
#   Manage the Icinga snapshot repository to get access to nightly snapshots.
#   Enabled by setting to 'true'. Defaults to 'false'.
#
# @param [Boolean] configure_backports
#   Enables or Disables the backports repository. Has only an effect on plattforms
#   simular to Debian. To configure the backports repo uses apt::backports in hiera.
#
# @param [Boolean] manage_epel
#   Manage the EPEL (Extra Packages Enterprise Linux) repository that is needed for some package
#   like newer Boost libraries. Has only an effect on plattforms simular to RedHat Enterprise.
#
# @example
#   require icinga::repos
#
class icinga::repos(
  Boolean $manage_stable,
  Boolean $manage_testing,
  Boolean $manage_nightly,
  Boolean $configure_backports,
  Boolean $manage_epel,
) {

  $list    =  lookup('icinga::repos', Hash, 'deep', {})
  $enabled = {
    icinga-stable-release  => $manage_stable,
    icinga-testing-builds  => $manage_testing,
    icinga-snapshot-builds => $manage_nightly,
    epel                   => $manage_epel,
  }

  case $::facts['os']['family'] {

    'redhat': {
      contain ::icinga::repos::yum
    }

    'debian': {
      contain ::icinga::repos::apt
    }

    'suse': {
      contain ::icinga::repos::zypper
    }

    default: {
      fail('Your plattform is not supported to manage repositories.')
    }

  } # osfamily

}
