# goodmorning

**OBS! Storage doesn't work properly in Chrome. This is a Flutter limitation. Use Android/iOS.**
Good Morning App uses Flutter Shared Preferences to store data persistently, which uses different local storage methods for each platform. Every time a Flutter project runs in web debug mode, it creates a new port and new storage. 

Run the app in release mode, with the same port each time (flutter run -d web-server --web-port 3344) or use Android/iOS.

**OBS! If you are running the application on the web (not recommended), enable access to the proxy server first!**
Go to https://cors-anywhere.herokuapp.com/corsdemo and click the button to activate before running the application. 

**API keys required** 
We will provide a secrets.dart file to put in /lib/data_handling. 
