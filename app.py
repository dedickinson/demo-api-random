from random import random
from flask import Flask

app = Flask(__name__)

@app.route('/')
def rdm():
    rdm = random()
    return {
        'value': rdm
    }

x=1
