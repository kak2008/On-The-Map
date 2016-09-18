# On-The-Map

This app contains a map which will show information posted by other students with authentication of udacity servers or Facebook. The map will contain pins that show the location where other students have reported studying. By tapping on the pin users can see a URL for something the student finds interesting. The user will be able to add their own data by posting a string that can be reverse geocoded to a location, and a URL.

App allows user to login through either Udacity or Facebook credentials. User will be able to see locations posted by other udacity users. Pins will be dropped on the map according to the latitude & longitude locations provided by other udacity users.  



## Installation
In order to run this app. Download the repository, open it on XCode, build & run.


### Screenshots
![alt tag](https://github.com/kak2008/On-The-Map/blob/master/Screen%20shots/Screen%20Shot.png)

## Implementation
This app has two view controllers:
- __Travel Location View Controller__: - This view controller shows the map and allows user to drop pins all over the world. Whenever user tap on dropped pin, photos are fetched from flickr at that particular location coordinates. User can delete pins in edit mode of this view controller.

- __Photo Album View Controller__: - This view controller will show map with selected drop pin and photo album. All the downloaded photos will be updated in the photo album for selected pin location. New collection button will fetch new photos for the location. User has a chance to delete photos in the edit mode of this view controller.   

- Application uses CoreData, MapKit, UIKit.

## Requirements
* Xcode 7.3
* Swift 2.0

## License
Copyright (c) 2016 Anish Kodeboyina

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
