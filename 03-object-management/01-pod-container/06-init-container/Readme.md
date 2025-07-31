Init Container is a special type of container that runs before the main application containers in a Pod. They are used to perform initialization tasks that must be completed before the main application containers can start. 

Features
- Init container only run once during the `start-up` process of pod.
- Init containers can contain `utilities` or `setup scripts` not present in am app image.
- User can define n number of init container in Pod.
- The multiple init containers and it will execute must in a sequence.
- App containers only start once all init containers completed.

User case
- Setup the application init or setup scripts for making lightweight application.
- In script may add require packages, libraries.
- After completing all requirement of init container the app container will be run. This is very useful feature.
- Its use for checking the connectivity of backend database to frontend application, then it will be works.
- Populate data at shared volume before application startup.