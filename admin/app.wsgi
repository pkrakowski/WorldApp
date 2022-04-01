import logging
import sys
import os
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/var/www/admin')
from app import app as application
application.secret_key = os.getenv('SECRET_KEY')