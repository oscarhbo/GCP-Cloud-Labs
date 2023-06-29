#!/bin/bash

apt-get update
apt-get install -y apache2

systemctl start apache2

echo "<html>
<head>
    <style>
        body {
            background-color: #f2f2f2;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 20px;
            text-align: center;
        }

        .container {
            margin: auto;
            width: 50%;
            border: 3px solid #2152ad;
            padding: 10px;
        }

        h1 {
            color: #2d2d2d;
        }
    </style>
</head>
<body>
    <div class='container'>
        <h1>Bienvenido al servidor Web $(hostname) con IP $(hostname -I) </h1>
    </div>
</body>
</html>" > /var/www/html/index.html
