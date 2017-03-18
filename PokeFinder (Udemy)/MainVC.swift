//
//  ViewController.swift
//  PokeFinder (Udemy)
//
//  Created by Mahmoud Hamad on 1/31/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
// The Application Has GeoFire and Firebase
//https://github.com/firebase/geofire-objc for geofire documentation


import UIKit
import MapKit
import FirebaseDatabase

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    //ChoosePokemon
    @IBOutlet weak var BlurEffect: UIVisualEffectView!

    
    @IBOutlet weak var ChoosePokemonView: ChoosePokemonView!
    var effect: UIVisualEffect!
    
    let locationManager = CLLocationManager()   //when working with location we need to use location manager
    
    var mapHasCenteredOnce = false
    
    var geoFire: GeoFire! //geoFire Object
    var geoFireRef: FIRDatabaseReference! //geoFire reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20.0))
        viewStatusBar.backgroundColor = .orange
        view.addSubview(viewStatusBar)
        
        self.view.addSubview(ChoosePokemonView)
        ChoosePokemonView.center = self.view.center
        ChoosePokemonView.isHidden = true
        
        effect = BlurEffect.effect
        BlurEffect.effect = nil
        BlurEffect.isHidden = true
        
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow //set tracking mode on the map (map will move with ur location if ur moving)
        
        
        geoFireRef = FIRDatabase.database().reference()
        //now this has nothing to do with Geofire at this point this is just a firebase database reference, a reference to general database your app is using we just has to grab it and store it somewhere, we using it here since our app has 1 screen
        
        geoFire = GeoFire(firebaseRef: geoFireRef)
        //now this is a geoFire Thing, pass FireBaseReference
        //now GeoFire is initialized which is great!
        
        
        parsePokemonCSV()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
        if ChoosePokemonView.isHidden == true { ChoosePokemonView.endEditing(true) }
    }
    
    //check the authorization
    func locationAuthStatus() { //when app in use not always to save battery
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true //need to show user location on map
            
        } else { // we haven't given permission yet
            locationManager.requestWhenInUseAuthorization()
            //if they yes (didChangeAuthorization status) will get called
        }
    }
    
    //Delegate Method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { //when they say yes or no
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {    //YES
            mapView.showsUserLocation = true
        
        }
    }
    
    //another thing is update the callback function for when user's location actually is updated
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //whenever GPS on the phone updates we want to center the map
        //as updates come in we always want to keep the map kind of centered on the user as well especially when location updates come in
        //make it once for this app 😅😅 not always
        if let loc = userLocation.location {
           
            if !mapHasCenteredOnce { //if it hasnt centered Once
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
            
        }
    }
    
    @IBAction func spotRandomPokemon(_ sender: Any) {
        /*
        //when we press the pokeball we will add the pokemon right in the middle of our map, so we can actually have location to put it in whatever users is currently looking at
        
        let randm = arc4random_uniform(150) + 1 //Hopefully thats right number 
        print(randm)
        
        createSighting(withPokemon: Int(randm))
        
        //pokeball pressed -> grab the location of the center of the map -> grab random pokemon number  -> create a sighting for that pokemon which calls GeoFire setLocation for it to Firebase database
        */
        chooseThePokemon()
    }

    func createSighting(withPokemon PokeId: Int){
        //when we press the pokeball we will add the pokemon right in the middle of our map, so we can actually have location to put it in whatever users is currently looking at
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        //grabing the center of the map
        
        
        //we just spotted pokemon (when we see pokemon we will call this function)
        geoFire.setLocation(location, forKey: "\(PokeId)") //string the pokeId
        
        //lets say u have Starbucks business and you have its own phone number and name and hours of operation etc. you've already saved it in your firebase database, what you're doing here is actually giving it GPS locations so you would grab 'the key' for your specific starbucks shop the unique key, thats what you would set at "forKey" and the location would be the location where it exists and then geoFire is smart enough to go in your database and find all database references that are in whatever geographical area you specify and thats where the magic is happening here , our app is alittle simple though but now you know how you might do it in a bigger app.
        //7e5osh edwar fl database 3le forkey w 7e7ot el location of gps m3 ba2e 7agat el far3
    }
    
    //when we get users location we want to see what pokemons in this location, Display them on the screen, we need to create a query for that
    //Called when first launch & when we set location
    func showSightingsOnMap(location: CLLocation) {
        
        let circleQuery = geoFire.query(at: location, withRadius: 2.5)
        //circle query can do rectangle one too, radius in kilometers
        

        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location { //not nil _both_ could be nil if so then it failed
                
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                //our Annotation class 😆, when we first saved them we made key = PokeId
                self.mapView.addAnnotation(anno)
                //add it to map || Automatically calls "viewFor annotation"
            
            }
            
            
        })
        //check geoFire gitHub documentation to know Keys (KeyEntered: The location of a key now matches the query criteria.)
        //observing whenever it finds a sighting, 1 thing important to know is if i had 50 pokemons this is going to be called 50 times, how it works
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: loc)
        
        UIView.animate(withDuration: 1.0) { //start 180
            self.refreshBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }
        UIView.animate(withDuration: 0.5, delay: 0.45, options: .curveEaseIn, animations: { //then do 360
            
            self.refreshBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*2))
        }, completion: nil)
    }
}

extension MainVC {
    
    //Create custom annotation (the images on map) (called for every annotation on map)
    //Delegate Method || Customize the annotation before putting it on map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //called whenever we add annotation
        
        var annotationView: MKAnnotationView?
        
        //if kind of class MKUser.Self = User
        //means if this is a user location annotation we want to change what is happening inside
        if annotation.isKind(of: MKUserLocation.self) { //USER
          
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
        
            
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: C.PokemonAnnoIdentifier) { //Pokemon (reUse annotation if needed)
            
            
            annotationView = deqAnno
            annotationView?.annotation = annotation
            
            
        }//whenever you are working with annotations you need to create a custom annotation class for it
        else { //incase deque fails, then we need to create it! Default Anno
            
            let MKAnnoView = MKAnnotationView(annotation: annotation, reuseIdentifier: C.PokemonAnnoIdentifier)
            MKAnnoView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = MKAnnoView
            
        }

        
        //Now customize it Any of the cases, anno view not nil & anno is poke anno
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation  {
            
            annotationView.canShowCallout = true //indicating show extra information in a bubble.
            //if u didn't set title in annoClass and made this true, App will crash
            
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)") //annotation image
            
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = button    //destination button
        }
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { //destination pressed button
        //tap the button in popup and show the destination through apple map
        //Configuering the map before loading it

        
        if let anno = view.annotation as? PokeAnnotation {
            //there is staring point and ending point apple map
            
            var place: MKPlacemark!
            
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate) //where u finish
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            
            let destination = MKMapItem(placemark: place)
            
            destination.name = C.PokemonDestinationName //what is goona show up on apple maps
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            //how much of map show, how far zoomed out, we configuering our map to looks nice
            //region Distance and Region Span in order to use Apple maps
            
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                           MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
                           MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                           ] as [String : Any]
            
            
            //these are key values this is dictionary of keys and values, these are options we can pass into apple maps so 1st where we want to center it (center of region),2nd how far you wanna span out when we load the map,3rd make it showing driving directions could make it walking if we wanted just change it
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
            //just 1 destination could do more
        }
    }
    
    //when user keep panning(swiping) and region changes 'Update Map'
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showSightingsOnMap(location: loc)
    }
    
    //Whenever the user first loads we wants to zoom the map in or eventually for future button to show/get the map on you
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        //CLLocationCoordinate2D, latitudialMeters and longitudialMeters (how zoomed is it) 2000Meters
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func chooseThePokemon(){
        
        UIView.animate(withDuration: 0.4) {
            self.ChoosePokemonView.isHidden = false
            
            self.BlurEffect.isHidden = false
            self.BlurEffect.effect = self.effect
        }
    
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows

            for row in rows {
                
                let pokeName = row["identifier"]! as String
                let pokeID = Int(row["id"]! as String)!
                
                //normaly we dont want to force & wrap these but in this case its eiter have it or dont have it
                
                let poke = Pokemon(pokeName: pokeName, pokeId: pokeID)
                PokemonsArray.append(poke)
            
            }
        
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
}












