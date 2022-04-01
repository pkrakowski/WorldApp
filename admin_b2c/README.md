#### Azure B2C Integration

The majority of deployments use Admin service with Basic logon. If you'd like to play with B2C you'll need to create a new Azure B2C tenant.

Below Microsoft docs will walk you through the steps of creating the tenant and registering the application:

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
At the end of the tutorial, you will be creating a new account. Once that's done get its Object ID and pass it to the container using ADMIN_ID=[] env. This assigns Admin privileges to the account to access Admin portal. For any real deployments you'll probably want to move this to the database and updated logic to pull it from there.





