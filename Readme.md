# Photo Walking app

> The user opens the app and presses the start button. After that the user puts their phone into their pocket and starts walking. The app requests a photo from the flickr photo search api every 100 meters to add to the stream. New pictures are added on top. Whenever the user takes a look at their phone, they see the most recent picture and can scroll through a stream of pictures which shows where the user has been. It should work for at least a two-hour walk. 

## How it works

When you open the app for the first time, it will ask you for your permission to access 'Always' location, if user reject give the permissions, he will see an error and the start button is not going to work. 

If the user only give's the 'whenInUse' permission, he will see another message explaining that the app only is going to work in foreground since we will not receive the locations in the background. 

When the user taps the start button, the app will fetch a first image based on the location of the user from the Flickr API, and then will do the same when we get a new location greater than o equal to a distance of 100 meters.

If we get a coincidence from the Flickr API, and the image does not already exist, the object is saved in CoreData so you can kill the app and when you come back your images will still there.

## To improove 

- Since the images are stored in CoreData, it would be great to have a delete session button to start over, or even be able to delete one by one.
- I'm only storing the Photo object received from Flickr, we could maybe store the image blob so we can see the images without connexion
- As far as I understand the Flickr api search service, the minimun radio around the latitude and longitude coordinates that we are abble to use for filter the results is 1 kilometer, so it's possible that if you walk 100 meters the app fetch the same image than before so it will not be included in the list. 

## Used for this project:

- SwiftUI
- Combine
- Async/Await 
- CoreLocation
- CoreData
- URLSession

## Requirements

- iOS 15.0.0+.
- Developed with Xcode Version 13.2.1 (13C100).
- No 3rd party dependencies.

## Tests

 For this coding challenge I'd just test the ViewModel of the PhotosList module since I think is enough for demonstration purposes.

## A bit about structure and architecture

I'm working on MVVM + reactive programming to update the SwiftUI interface. The DataLayer group I usually have it in a separated framework, so I can include it among the different target's that we can have in a application (a widget for eg.) this way is easy to share the models, storage and the bussines logic, and also, the targets does not know nothing except the public models and repositories so you can change CoreData by Realm, or change the networking layer at any time and we don't need to touch the application targets.

You probably may see and wonder why the Network layer is not using async/await instead of closures, that's because I'm re-using it from other projects.

Bests, Paul