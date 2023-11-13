# Path: templates/index.html
# Description - HTML template file
# Author - Aaron C

from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return '<h1>About Page</h1>'

@app.route('/contact')
def contact():
    return '<h1>Contact Page</h1>'

if __name__ == '__main__':
    app.run(debug=True)

