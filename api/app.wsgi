import logging
import sys
import os
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/var/www/api')
from app import app as application