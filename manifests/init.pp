# == Class: kibana
#
# This class installs Kibana
#
# === Parameters
#
# [*install_path*]
#   Destination folder to install Kibana to. This folder must be shared by a
#   web server.
#
# [*git_revision*]
#   Revision on github to clone locally. Can be updated after a version is
#   well tested.
#
# [*git_clone_path"]
#   Kibana repository must be clone in an intermediate folder as only a
#   subdirectory holds the Kibana application itself.
#
# [*elasticsearch_url*]
#   Public URL of elasticsearch. This url must be accessible by client browsers
#   that run Kibana.
#
class kibana (
  $install_path,
  $git_revision      = '0f16e1cc6184ed101e63106b4b386cebc3e92652',
  $git_clone_path    = '/usr/src/kibana',
  $elasticsearch_url = 'https://"+window.location.hostname+"/elasticsearch/',
  $default_route     = '/dashboard/file/logstash.json',
) {

  vcsrepo {$git_clone_path:
    provider => 'git',
    revision => $git_revision,
    source   => 'git://github.com/elasticsearch/kibana.git',
  }

  file {$install_path:
    ensure   => directory,
    source   => "file://${git_clone_path}/src",
    recurse  => true,
    force    => true,
    require  => Vcsrepo[$git_clone_path],
  }

  file {"${install_path}config.js":
    ensure  => present,
    content => template("${module_name}/config.js.erb"),
  }

}
