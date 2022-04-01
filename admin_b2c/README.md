#### Azure B2C Integration

The majority of deployments use Admin service with Basic Login. If you'd like to play with B2C you'll need to deploy a new Azure B2C tenant to your environment.

To register and configure follow these guides in order:

https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-tenant

https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications?tabs=app-reg-ga

https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-user-flows?pivots=b2c-user-flow >> *Name your signup flow "B2C_1_susi"*


Once completed you should have all the required detail which is your:
```
B2CTENANT=
CLIENT_ID=
CLIENT_SECRET=
REDIRECT_URL=
```
At the end of the tutorial, you will be creating an account. Once that's done get its Object ID and pass it to the container with env ADMIN_ID=[] this assigns Admin privileges to the account to upload sample data. For any real deployments you'll probably want to move this to the database and updated logic to pull it from there.





