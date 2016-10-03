# On-The-Map

This app contains a map which will show information posted by other students with authentication of udacity servers or Facebook. The map will contain pins that show the location where other students have reported studying. By tapping on the pin users can see a URL for something the student finds interesting. The user will be able to add their own data by posting a string that can be reverse geocoded to a location, and a URL.

App allows user to login through either Udacity or Facebook credentials. User will be able to see locations posted by other udacity users. Pins will be dropped on the map according to the latitude & longitude locations provided by other udacity users. User will be able to see other users posting on the map whenever user taps on the pin drop. User can also post his location and Weblink in the app & submit details    


## Installation
In order to run this app. Download the repository, open it on XCode, build & run.


### Screenshots
![alt tag](https://github.com/kak2008/On-The-Map/blob/master/Screen%20shots/Screen%20Shot.png)

## Implementation
This app has multiple view controllers:
- __Login View Controller__: - This view controller allows user to login either using Udacity or Facebook credentials. 

- __Map View Controller__: - This view controller will show map with drop pins of the other udacity users.   

- __Location List View Controller__: - This view controller will show details of the other udacity users postings in list format and when user tap on the cell, webpage will be opened accordingly.
 
- __Information posting View Controller__: - This view controller will let user to post their location in the textfield and post weblink.     

- Application uses MapKit, UIKit, Udacity & facebook authentication.

## Requirements
* Xcode 7.3
* Swift 2.0

## License
Copyright (c) 2016 Anish Kodeboyina.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
