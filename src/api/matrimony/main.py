from flask import Flask, request, jsonify

app = Flask(__name__)

# Register blueprints
app.register_blueprint(user_blueprint, url_prefix='/user')

if __name__ == '__main__':
    app.run(debug=True)
