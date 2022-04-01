import os

class B2CDetail:
    B2CTENANT = os.getenv('B2CTENANT')
    CLIENT_ID = os.getenv('CLIENT_ID')
    CLIENT_SECRET = os.getenv('CLIENT_SECRET')
    ENDPOINT = ''
    SCOPE = []
    admin_users = os.getenv('ADMIN_ID')
    redirect_url = os.getenv('REDIRECT_URL')
    signupsignin_user_flow = "B2C_1_susi"
    authority_template = "https://{tenant}.b2clogin.com/{tenant}.onmicrosoft.com/{user_flow}"
    AUTHORITY = authority_template.format(tenant=B2CTENANT, user_flow=signupsignin_user_flow)

class DBDetail:
    user = os.getenv('MYSQL_USER')
    password = os.getenv('MYSQL_PASSWORD')
    host = os.getenv('MYSQL_HOST')
    dbname = os.getenv('MYSQL_DBNAME')

