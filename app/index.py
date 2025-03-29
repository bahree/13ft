from flask import Flask, request, render_template
from portable import bypass_paywall

app = Flask(__name__, template_folder='templates')

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/proxy')
def proxy():
    url = request.args.get('url')
    if not url:
        return "Missing URL parameter", 400
    
    try:
        content = bypass_paywall(url)
        return content
    except Exception as e:
        return f"Error: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
