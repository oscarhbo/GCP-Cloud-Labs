from flask import Flask, render_template_string

app = Flask(__name__)

@app.route('/')
def hello():
    html_template = """
    <html>
    <head>
        <title>Hola Mundo desde APP Engine</title>
        <style>
            body {
                background: linear-gradient(to bottom right, #333, #000);
                color: white;
                font-size: 48px;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
        </style>
    </head>
    <body>
        <div>Hola Mundo desde APP Engine</div>
    </body>
    </html>
    """
    #return render_template_string(html_template)
    return "Hello World!"

if __name__ == '__main__':
    app.run(host="127.0.0.1", port=8080, debug=True)
