# goodmorning

**OBS! Storage doesn't work properly in Chrome. This is a Flutter issue. Use Android/iOS.**

Good Morning App uses Flutter Shared Preferences to store data persistently, which uses different storage for each platform. Every time a Flutter project runs in debug, it creates a new port and new storage. 

Run the app in release mode, with the same port each time (flutter run -d web-server --web-port 3344) or on Android/iOS.

[Stack Overflow]([url](https://stackoverflow.com/questions/59503499/flutter-web-shared-preferences-not-available-when-tab-is-closed-and-reopened?fbclid=IwAR3pT_7iOQmRHN0ZX0trTZs2gZwI8RtT89izqpWGhDtxjw4XtCSB6Q7KXXk)https://stackoverflow.com/questions/59503499/flutter-web-shared-preferences-not-available-when-tab-is-closed-and-reopened?fbclid=IwAR3pT_7iOQmRHN0ZX0trTZs2gZwI8RtT89izqpWGhDtxjw4XtCSB6Q7KXXk)
