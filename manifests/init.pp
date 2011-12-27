class gosa (
  $ldap_bind_dn,
  $ldap_bind_pw,
) {
  
  include apache2::variables
  
  package { [ 'gosa', 'gosa-help-en', 'gosa-help-fr', 'gosa-plugin-dhcp', 'gosa-plugin-dns', 'gosa-plugin-log', 'gosa-plugin-mail', 'gosa-plugin-pureftpd', 'gosa-plugin-rsyslog', 'gosa-plugin-samba' ]:
    ensure  => present
  }

  file { '/etc/gosa/gosa.conf':
    ensure  => file,
    mode    => 0600,
    owner   => $apache2::variables::apache_user,
    group   => $apache2::variables::apache_group,
    content => template('gosa/gosa.conf.erb'),
    notify  => Exec['reload-apache2'],
    require => Package['apache2','gosa']
  }

  file { '/etc/gosa/gosa-apache.conf':
    ensure  => file,
    content => template('gosa/gosa-apache.conf.erb'),
    notify  => Exec['reload-apache2'],
    require => Package['gosa']
  }
  
  file { '/etc/gosa/shells':
    ensure  => file,
    source  => 'puppet:///modules/gosa/shells',
    notify  => Exec['reload-apache2']
  }

  #Might be better to provide a new package
  file { '/usr/share/gosa/plugins/personal/mail/class_mail-methods-cyrus.inc':
    ensure  => file,
    source  => 'puppet:///modules/gosa/class_mail-methods-cyrus.inc',
    require => Package['gosa']
  }
}

