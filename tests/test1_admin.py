import os
import unittest
from io import BytesIO

import requests

HOST = 'http://'+os.getenv('KUBE_IP')
endpoint = '/admin/'

class AdminTests(unittest.TestCase):
    #Check if Admin endpoint responds with 200
    def test_admin_endpoint(self):
            url = HOST + endpoint
            response = requests.get(url, verify=False)
            print(url, response.status_code)
            self.assertEqual(response.status_code, 200)

    #Check if login fails with wrong credentials
    def test_admin_login_invalid(self):
        url = HOST + endpoint
        response = requests.post(
            url,
            data=dict(username='wrong', password='wrong'),
            allow_redirects=True, verify=False
        )
        self.assertIn("Wrong Credentials!", response.text)

    #Check if login succeeded with correct credentials
        url = HOST + endpoint
        response = requests.post(
            url,
            data=dict(username='adminuser', password='adminpassword'),
            allow_redirects=True, verify=False
        )
        self.assertIn("Admin Panel", response.text)

    #Check if CSV upload works
    def test_uploadcsv(self):
        url = HOST + endpoint
        login = requests.post(
            url,
            data=dict(username='adminuser', password='adminpassword'),
            allow_redirects=True, verify=False
        )
        with open('./tests/test.csv', 'rb') as csv:
            files = {'file': ('test.csv', csv ,'text/csv')}
            response = requests.post(url+'/upload', files=files, allow_redirects=True, cookies=login.cookies, verify=False)
            self.assertIn("Data uploaded successfully", response.text)
        csv.close

if __name__ == '__main__':
    unittest.main()
