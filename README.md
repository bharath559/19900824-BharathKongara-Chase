# Weather

Used SwifUI most of the project but to show an example of mixing UIKIT and SwiftUI I have created a navigation viewcontroller of UIKIT.

# Architecture
Followed MVVM architecture:


* ViewModel - Fetches data from Repository and updates the state objects which eventually updates the UI.
* Model - Holds the displayable Data
* Repository - Responsible to fetch data from server and store data into database if offline support is required 
* SwiftUI(views) - Controls refreshing and actions of view.

No External (3rd party) libraries are used to build this project

# Improvements

* Create separate swift package for screens/flows, utils, core things that can be resued in another places.
* Add Hourly data to the Weather details screen
* Add Reactive Database either Coredata/Realm instead of UserDefaults used to store City inform

* Create Flow Coordinators to separate flows and navigation stack
* Add Analytics/logger whereever required
* Build a cache layer for any resources