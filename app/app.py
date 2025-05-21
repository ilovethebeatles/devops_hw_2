from flask import Flask, request, jsonify
import logging
import os
import yaml

config_path = '/app/config/config.yaml'
if os.path.exists(config_path):
    with open(config_path) as f:
        cfg = yaml.safe_load(f)
else:
    cfg = {}

app = Flask(__name__)

log_level = getattr(logging, cfg.get('log_level', 'INFO').upper(), logging.INFO)
logging.basicConfig(level=log_level, filename='/app/logs/app.log', filemode='a',
                    format='%(asctime)s - %(levelname)s - %(message)s')

greeting = cfg.get('greeting', 'Hello World')
port = cfg.get('port', 5000)

@app.route('/', methods=['GET'])
def home():
    return greeting

@app.route('/status', methods=['GET'])
def status():
    return jsonify(status='ok')

@app.route('/log', methods=['POST'])
def log_message():
    data = request.get_json()
    msg = data.get('message')
    app.logger.info(msg)
    return '', 204

@app.route('/logs', methods=['GET'])
def get_logs():
    if os.path.exists('/app/logs/app.log'):
        with open('/app/logs/app.log') as f:
            content = f.read()
        return content, 200, {'Content-Type': 'text/plain'}
    else:
        return '', 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)
