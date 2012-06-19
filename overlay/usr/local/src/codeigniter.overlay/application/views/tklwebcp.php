<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta http-equiv="Content-Style-Type" content="text/css">
        <meta http-equiv="Content-Script-Type" content="text/javascript">

        <title>TurnKey CodeIgniter</title>
        
        <link rel="stylesheet" href="/assets/css/ui.tabs.css" type="text/css" media="print, projection, screen"/>
        <link rel="stylesheet" href="/assets/css/base.css" type="text/css"/>

        <script src="/assets/js/jquery-1.2.6.js" type="text/javascript"></script>
        <script src="/assets/js/ui.core.js" type="text/javascript"></script>
        <script src="/assets/js/ui.tabs.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(function() {
                $('#container-1 > ul').tabs({ fx: { opacity: 'toggle'} });
            });
        </script>
    </head>

    <body>
        <h1>TurnKey CodeIgniter</h1>
        
        <div id="container-1">
            <ul>
                <li><a href="#cp"><span>Control Panel</span></a></li>
                <li><a href="#about"><span>About</span></a></li>
            </ul>

            <div id="cp">
                <div class="fragment-content">
                    <div>
                        <a href="https://<?php print
                        $_SERVER{'HTTP_HOST'}; ?>:12320"><img
                        src="/assets/images/shell.png"/>Web Shell</a>
                    </div>
                    <div>
                        <a href="https://<?php print
                        $_SERVER{'HTTP_HOST'}; ?>:12321"><img
                        src="/assets/images/webmin.png"/>Webmin</a>
                    </div>
                    <div>
                        <a href="https://<?php print
                        $_SERVER{'HTTP_HOST'}; ?>:12322"><img
                        src="/assets/images/phpmyadmin.png"/>PHPMyAdmin</a>
                    </div>
                    <div></div>
                    <div></div>

                    <h2>Resources and references</h2>
                    <ul>

                        <li>
                          <a href="/user_guide">CodeIgniter user guide</a>
                        </li>
                        <li>
                          <a href="http://codeigniter.com/">Official CodeIngiter website</a>
                        </li>
                        <li><a
                        href="http://www.turnkeylinux.org/codeigniter">
                        TurnKey CodeIgniter release notes</a></li>
                    </ul>

                </div>
            </div>
            <div id="about">
                <div class="fragment-content">
                    <h2>The page your looking at is dynamically generated</h2>
                    <br/>

                    <h3>Routing configuration</h3>
                    <pre>/var/local/codeigniter/application/config/routes.php</pre>

                    <h3>Controller code</h3>
                    <pre>/var/local/codeigniter/application/controllers/tklwebcp.php</pre>

                    <h3>View code</h3>
                    <pre>/var/local/codeigniter/application/views/tklwebcp.php</pre>
            
                    <h3>Stylesheets, javascript and images</h3>
                    <pre>/var/www/codeigniter/assets</pre>

                    <br/>
                    <h3>And the cherry: MySQL preconfigured to get you started</h3>
                    <pre>/var/local/codeigniter/application/config/database.php</pre>

                    <p style="font-size:80%;padding-top:30px;">Page rendered in <strong>{elapsed_time}</strong> seconds</p>

                </div>
            </div>

        </div>
    </body>
</html>
