### Application UI
The application is written in Dart using the Flutter SDK.

### Authentication
The authentication is based on an email/password account system, with the application linking to Firebase Authentication where this component is managed.

### Requests
The application connects to our API using GET/POST requests to obtain any necessary information.

### Information Storage
Credentials are stored in Firebase Authentication system. <br>
Videos and Images are stored in Firestore Database system. <br>
Remaining data is stored in a remote MySQL database. <br>
Caching on mobile uses shared preferences for key-value data and Hive package (NoSQL database) for more complex objects 

### Client Payment
Payments are made using Paypal 
