import os
import unittest

import requests

HOST = 'http://'+os.getenv('KUBE_IP')
endpoint = '/api/'

class TestAPI(unittest.TestCase):
    #Check if API can retrive data from the database
    def test_data_avability(self):
        url = HOST + endpoint
        response = requests.get(url+'United Kingdom', verify=False)
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
