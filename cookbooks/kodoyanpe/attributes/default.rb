default['kodoyanpe']['pkg_path'] = "http://pkgsrc-cdn-oregon.atalanta-systems.com"

case node['kernel']['machine']
when /sun/
  default['kodoyanpe']['binary_kit'] = "pkgsrc-sparc-bootstrap.tar.gz"
when /i86/
  default['kodoyanpe']['binary_kit'] = "pkgsrc-i86-bootstrap.tar.gz"
end

default['kodoyanpe']['pkgsrc_pkgs'] = %w{
  curl-7.25.0.tgz
  db4-4.8.30.tgz
  digest-20111104.tgz
  expat-2.1.0.tgz
  gcc34-3.4.6nb7.tgz
  gettext-lib-0.18.1.1.tgz
  gmake-3.82nb3.tgz
  heimdal-1.5.2nb2.tgz
  libgetopt-1.4.4.tgz
  libiconv-1.14nb2.tgz
  libidn-1.24.tgz
  libyaml-0.1.2.tgz
  nbpatch-20100124.tgz
  openssl-0.9.8w.tgz
  p5-Authen-SASL-2.15nb1.tgz
  p5-Digest-HMAC-1.03.tgz
  p5-Digest-MD5-2.51nb1.tgz
  p5-Digest-SHA-5.71.tgz
  p5-Error-0.17017.tgz
  p5-GSSAPI-0.28nb2.tgz
  p5-MIME-Base64-3.13nb1.tgz
  perl-5.14.2nb5.tgz
  readline-6.2.tgz
  ruby193-base-1.9.3p194.tgz
  scmgit-base-1.7.10.tgz
  sqlite3-3.7.11nb1.tgz
}

default['kodoyanpe']['pkg_share'] = "/export/home/pkgsrc"

default['kodoyanpe']['zone_pool'] = "nfs"
default['kodoyanpe']['zone_dataset'] = "zones"
default['kodoyanpe']['zone_mountpoint'] = "/usr/share/zones"

default['kodoyanpe']['master_zone_template'] = nil

default['kodoyanpe']['test_network_interface'] = "bge1"
default['kodoyanpe']['test_network'] = "10.10.10.0"
default['kodoyanpe']['test_ip'] = "10.10.10.1"
default['kodoyanpe']['test_netmask'] = "255.255.255.0"
