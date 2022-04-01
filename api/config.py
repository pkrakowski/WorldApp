import os

class DBDetail:
    user = os.getenv('MYSQL_USER')
    password = os.getenv('MYSQL_PASSWORD')
    host = os.getenv('MYSQL_HOST')
    dbname = os.getenv('MYSQL_DBNAME')