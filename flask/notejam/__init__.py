from flask import Flask
<<<<<<< HEAD
from urllib.parse import urlparse
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from notejam.config import (
    Config,
    DevelopmentConfig,
    ProductionConfig,
    TestingConfig)
import os

from_env = {'production': ProductionConfig,
            'development': DevelopmentConfig,
            'testing': TestingConfig,
            'dbconfig': Config}

# @TODO use application factory approach
app = Flask(__name__)
app.config.from_object(from_env[os.environ.get('ENVIRONMENT', 'testing')])
=======
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail

# @TODO use application factory approach
app = Flask(__name__)
app.config.from_object('notejam.config.Config')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
>>>>>>> 8fecc935c6b6942feacba721851b964a00d8bdb1
db = SQLAlchemy(app)


@app.before_first_request
def create_tables():
    db.create_all()


login_manager = LoginManager()
login_manager.login_view = "signin"
login_manager.init_app(app)

mail = Mail()
mail.init_app(app)

from notejam import views
