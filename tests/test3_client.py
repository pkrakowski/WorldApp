import os
import unittest

import requests

HOST = 'http://'+os.getenv('KUBE_IP')

class TestClient(unittest.TestCase):
    #Check if Client endpoint responds with 200
    def test_client_endpoint(self):
            url = HOST
            response = requests.get(url, verify=False)
            print(url, response.status_code)
            self.assertEqual(response.status_code, 200)
if __name__ == '__main__':
    unittest.main()
