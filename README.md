# ProjetS9-iOS

## What is it ? 
This is an iOS application providing usefull information during a conference.
For exemple the user can access the Conference's planning, he can also use the indoor map and the indoor localization to know where is the next talk.
Multiple beacons placed inside the building allow us to track user location (thanks to his phone's bluetooth) inside it using some kind of triangulation algorithm. 

![alt text](/doc/image08.png "Menu view")
![alt text](/doc/image04.png "Map view")
![alt text](/doc/image06.png "Calendar view")


## Documentation
You can find our academic report [here](/doc/Report.pdf), even if it is not really a technical documentation it describes how we implemented some of our algorithms. 

## Licensing
Please see the file called [LICENSE.md](/LICENSE.md).


## Installation
This project was developed under Xcode 6.1.1 using Swift 1.1 therefore if you're using another version you might get errors.

As the backend API was not developed, you will need to host and edit files within json folder. You also will need to edit the [URLFactory.swift](/Projet S9/URLFactory.swift) file with the correct URL.