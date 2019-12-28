###
# Do not use this file to override the mod_php7_apache2 cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "mod_php7_apache2/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'mod_php7_apache2/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

packages = []

case node[:platform_family]
when 'debian'
  packages = [

    "php7.2",
    "php7.2-common",
    "php7.2-opcache",
    "php7.2-cli",
    "php7.2-gd",
    "php7.2-curl",
    "php7.2-mysql",
    "php7.2-xml",
    "php7.2-xmlrpc",
    "php7.2-dev",
    "php7.2-imap",
    "php7.2-mbstring",
    "php7.2-opcache",
    "php7.2-soap",
    "php7.2-zip",
    "php7.2-intl",
    "libapache2-mod-php7.2"


    
  ]
when 'rhel'
  packages = [
    "php-xml",
    "php-common",
    "php-xmlrpc",
    "php-gd",
    "php-cli",
    "php-pear-Auth-SASL",
    "php-mcrypt",
    "php-pecl-memcache",
    "php-pear",
    "php-pear-XML-Parser",
    "php-pear-DB",
    "php-pear-HTML-Common",
    "php",
    "php-devel",
    "php-pear-Mail-Mime"
  ]
end

default[:mod_php7_apache2][:packages] = packages
