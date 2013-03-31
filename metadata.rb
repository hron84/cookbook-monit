name             "monit"
maintainer       "Gabor Garami"
maintainer_email "hron@hron.me"
license          "MIT"
description      "Installs/Configures ."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

provides         'monit'
provides         'monit::mmonit'

supports         'ubuntu'
supports         'debian'
supports         'fedora'
supports         'redhat'
supports         'gentoo'
supports         'centos'
supports         'suse'
supports         'scientific'

recipe           'monit::default', 'Monit client'
recipe           'monit::mmonit', 'M/Monit server'

## monit::mmonit

attribute        'mmonit/version',           :display_name => 'M/Monit version', 
                                             :type => 'string', 
                                             :required => 'optional', 
                                             :recipes => %w(monit::mmonit)

attribute        'mmonit/checksum',          :display_name => 'M/Monit checksum', 
                                             :description => 'Checksum of M/Monit package',
                                             :type => 'string',
                                             :required => 'optional',
                                             :recipes => %w(monit::mmonit)

## monit::default

attribute        'monit/check_interval',     :display_name => 'Check interval',
                                             :type => 'string',
                                             :required => 'required',
                                             :default => 120,
                                             :recipes => %w(monit::default)

attribute        'monit/log',                :display_name => 'Log file', 
                                             :description => "Location of the log, or 'syslog' if you want to redirect to syslog", 
                                             :type => 'string', 
                                             :required => 'required', 
                                             :default => '/var/log/monit.log', 
                                             :recipes => %w(monit::default)

attribute        'monit/mmonit_url',         :display_name => 'M/Monit server URL',
                                             :type => 'string',
                                             :required => 'optional',
                                             :recipes => %w(monit::default)

attribute        'monit/httpd/enable',       :display_name => 'Enable internal HTTP server',
                                             :type => 'string',
                                             :choices => %w(true false),
                                             :required => 'required',
                                             :default => 'false',
                                             :recipes => %w(monit::default)

attribute        'monit/httpd/address',      :display_name => 'HTTP server bind address',
                                             :type => 'string', 
                                             :required => 'optional',
                                             :default => 'localhost',
                                             :recipes => %w(monit::default)

attribute        'monit/httpd/port',         :display_name => 'HTTP server port',
                                             :type => 'string',
                                             :required => 'optional',
                                             :default => '2812',
                                             :recipes => %w(monit::default)

attribute        'monit/httpd/user',         :display_name => 'Authentication user',
                                             :type => 'string',
                                             :required => 'optional',
                                             :default => 'admin',
                                             :recipes => %w(monit::default)

attribute        'monit/httpd/password',     :display_name => 'Authentication password',
                                             :type => 'string',
                                             :required => 'optional',
                                             :default => 'monit',
                                             :recipes => %w(monit::default)

attribute        'monit/mailformat/from',    :display_name => 'Sender of alert e-mails',
                                             :type => 'string',
                                             :required => 'recommended',
                                             :recipes => %w(monit::default)

attribute        'monit/mailformat/subject', :display_name => 'Template of the subject of alert emails',
                                             :type => 'string',
                                             :required => 'optional',
                                             :recipes => %w(monit::default)

grouping         'monit/httpd', :title => "Options for Monit's internal HTTP server"

