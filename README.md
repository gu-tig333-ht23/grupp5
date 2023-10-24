# goodmorning

**OBS! Storage doesn't work properly in Chrome. This is a Flutter limitation. Use Android/iOS.**

Good Morning App uses Flutter Shared Preferences to store data persistently, which uses different storage for each platform. Every time a Flutter project runs in debug, it creates a new port and new storage. 

Run the app in release mode, with the same port each time (flutter run -d web-server --web-port 3344) or on Android/iOS.
