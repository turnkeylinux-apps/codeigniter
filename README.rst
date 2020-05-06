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

     **Security note**: Updates to CodeIgniter may require supervision so
     they **ARE NOT** configured to install automatically. See `CodeIgniter
     documentation`_ for upgrading.

- SSL support out of the box.
- `Adminer`_ administration frontend for MySQL (listening on port
  12322 - uses SSL).
- Postfix MTA (bound to localhost) to allow sending of email (e.g.,
  password recovery).
- Webmin modules for configuring Apache2, PHP, MySQL and Postfix.

Credentials *(passwords set at first boot)*
-------------------------------------------

-  Webmin, SSH, MySQL: username **root**
-  Adminer: username **adminer**

.. _CodeIgniter: https://codeigniter.com/
.. _TurnKey Core: https://www.turnkeylinux.org/core
.. _CodeIgniter documentation: https://codeigniter4.github.io/userguide/installation/upgrading.html
.. _Adminer: https://www.adminer.org/
