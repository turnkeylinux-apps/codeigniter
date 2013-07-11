CodeIgniter - Web application framework
=======================================

`CodeIgniter`_ is a powerful PHP framework with a small footprint and
exceptional performance, built for PHP coders who need a simple and
elegant toolkit to create full-featured web applications in the real
world of shared hosting accounts and clients with deadlines.

This appliance includes all the standard features in `TurnKey Core`_,
and on top of that:

- CodeIgniter configurations:
   
   - Installed from upstream source code to /var/www/codeigniter

- SSL support out of the box.
- `PHPMyAdmin`_ administration frontend for MySQL (listening on port
  12322 - uses SSL).
- Postfix MTA (bound to localhost) to allow sending of email (e.g.,
  password recovery).
- Webmin modules for configuring Apache2, PHP, MySQL and Postfix.

Credentials *(passwords set at first boot)*
-------------------------------------------

-  Webmin, SSH, MySQL, phpMyAdmin: username **root**


.. _CodeIgniter: http://codeigniter.com/
.. _TurnKey Core: http://www.turnkeylinux.org/core
.. _PHPMyAdmin: http://www.phpmyadmin.net
