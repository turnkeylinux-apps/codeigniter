#!/bin/bash
set -Eeuo pipefail
umask 077

result=${TKL_TEST_RESULT:?TKL_TEST_RESULT is required}
page=/tmp/tkl-codeigniter-page.$$
spark_output=/tmp/tkl-codeigniter-spark.$$
policy=/tmp/tkl-codeigniter-policy.$$

report_error() {
    printf 'test_failure line=%s status=%s command=%q\n' \
        "$1" "$2" "$3" >&2
    exit "$2"
}

cleanup() {
    rm -f -- "$page" "$spark_output" "$policy"
}
trap 'report_error "$LINENO" "$?" "$BASH_COMMAND"' ERR
trap cleanup EXIT

systemctl --quiet is-active apache2.service mariadb.service postfix.service \
    multi-user.target
systemctl --quiet is-enabled apache2.service mariadb.service postfix.service
apache2ctl -t
apache2ctl -M 2>/dev/null | grep -q ' rewrite_module '
grep -Fxq 'VERSION_CODENAME=trixie' /etc/os-release
grep -Eq '^turnkey-codeigniter-19\.0' /etc/turnkey_version

. /usr/local/share/turnkey/codeigniter-release
[[ $VERSION == 4.7.4 ]]
[[ $TAG == v4.7.4 ]]
[[ $COMMIT == 2bd0f01d2813f9ec06db42643ce39d9f5428bf6d ]]
[[ $ARCHIVE_SHA256 == a28cf27e2fc0c7220b6212fa16aa396bf8bd1ad7150d996db1acfd39dee47e77 ]]
grep -Fq "CI_VERSION = '$VERSION'" \
    /var/local/codeigniter/system/CodeIgniter.php
grep -Fxq 'require "/var/local/codeigniter/app/Config/Paths.php";' \
    /var/www/codeigniter/public/index.php
grep -Fxq 'require "/var/local/codeigniter/app/Config/Paths.php";' \
    /var/www/codeigniter/spark
grep -Eq 'public string \$key = '\''[[:xdigit:]]{32}'\'';' \
    /var/local/codeigniter/app/Config/Encryption.php
db_password=$(sed -n '/public array \$default = \[/,/    \];/ s|.*'\''password'\''     => '\''\([^'\'']*\)'\''.*|\1|p' \
    /var/local/codeigniter/app/Config/Database.php)
[[ $db_password =~ ^[[:xdigit:]]{32}$ ]]

php_version=$(php --version | head -n 1)
[[ $php_version == 'PHP 8.4.'* ]]
for module in curl dom gd intl mbstring mysqli xml; do
    php -m | grep -Fxiq "$module"
done

curl --insecure --fail --silent --show-error https://127.0.0.1/ >"$page"
grep -Fq "Welcome to CodeIgniter $VERSION" "$page"
grep -Fq '/var/local/codeigniter/app/Views' "$page"
grep -Fq '/var/local/codeigniter/app/Config/Database.php' "$page"
grep -Fq ':12321' "$page"
grep -Fq ':12322' "$page"

MYSQL_PWD=$db_password mariadb --user=codeigniter codeigniter --batch \
    --execute "CREATE TABLE tkl_v19_acceptance (id INT PRIMARY KEY, message VARCHAR(64)); INSERT INTO tkl_v19_acceptance VALUES (1, 'turnkey-v19-database-round-trip');"
runuser --user www-data -- php /var/www/codeigniter/spark \
    db:table tkl_v19_acceptance --limit-field-value 64 >"$spark_output"
grep -Fq 'codeigniter' "$spark_output"
grep -Fq 'tkl_v19_acceptance' "$spark_output"
grep -Fq 'turnkey-v19-database-round-trip' "$spark_output"
MYSQL_PWD=$db_password mariadb --user=codeigniter codeigniter --batch \
    --skip-column-names --execute \
    "SELECT message FROM tkl_v19_acceptance WHERE id=1" |
    grep -Fxq 'turnkey-v19-database-round-trip'

dpkg-query -W adminer webmin-apache webmin-mysql webmin-phpini postfix \
    >/dev/null
curl --insecure --fail --silent --show-error --head \
    https://127.0.0.1:12321/ >/dev/null
curl --insecure --fail --silent --show-error --head \
    https://127.0.0.1:12322/ >/dev/null

before="$(dpkg-query -W -f='${Version}' php-cli)|$(dpkg-query -W -f='${Version}' mariadb-server)|$(dpkg-query -W -f='${Version}' apache2)"
apt-get update >/dev/null
for package in php-cli mariadb-server apache2; do
    apt-cache policy "$package" >"$policy"
    candidate=$(awk '/Candidate:/ {print $2}' "$policy")
    [[ -n $candidate && $candidate != '(none)' ]]
    grep -Eq 'trixie|deb13' "$policy"
done
after="$(dpkg-query -W -f='${Version}' php-cli)|$(dpkg-query -W -f='${Version}' mariadb-server)|$(dpkg-query -W -f='${Version}' apache2)"
[[ $after == "$before" ]]
grep -Rqs '^Suites: trixie' /etc/apt/sources.list.d
! grep -Rqi bookworm /etc/apt/sources.list /etc/apt/sources.list.d

latest_url=$(curl --head --location --fail --silent --show-error \
    --output /dev/null --write-out '%{url_effective}' \
    https://github.com/codeigniter4/CodeIgniter4/releases/latest)
latest_tag=${latest_url##*/}
[[ $latest_tag == v* ]]
dpkg --compare-versions "${latest_tag#v}" ge "$VERSION"

cat >"$result" <<EOF
package_source=Official CodeIgniter v$VERSION release archive pinned by SHA-256; PHP 8.4, MariaDB, Apache and extensions from Debian 13 Trixie
installed_version=CodeIgniter $VERSION ($COMMIT); $php_version; mariadb-server $(dpkg-query -W -f='${Version}' mariadb-server); apache2 $(dpkg-query -W -f='${Version}' apache2)
runtime_checks=normal init; Apache, MariaDB and Postfix supervision; firstboot database credential rotation; HTTPS CodeIgniter welcome page and TurnKey paths; CodeIgniter CLI and MariaDB create-read round trip; Adminer and Webmin HTTPS endpoints
updater_command=follow the official CodeIgniter 4 manual upgrade procedure after checking https://github.com/codeigniter4/CodeIgniter4/releases/latest
updater_result=official latest release resolved to $latest_tag without changing installed files; signed Debian metadata refreshed and installed packages remained unchanged
updater_channel=Official CodeIgniter GitHub releases and Debian Trixie APT repositories
integrity_evidence=Build archive matched SHA-256 $ARCHIVE_SHA256; release metadata records tag $TAG and commit $COMMIT; APT accepted signed Trixie metadata; no Bookworm source remained
EOF
