//
//  ViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 12/03/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //On récupère la valeur de la clé isUserLogin pour savoir si l'utilisateur est connecté
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
        
        //S'il n'est pas connecté, on le redirige vers la page de connexion
        
        if !isUserLoggedIn
        {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        
        // Pour la map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        //Pour le menu
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
       /* let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = (locationManager.location?.coordinate)!
        myAnnotation.title = "Ma position"
        
        mapView.addAnnotation(myAnnotation)*/
        
        for amis in Utilisateur.utilisateur.mesAmis.mesAmis {
            
            let location : CLLocationCoordinate2D = amis.localisation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = amis.prenom + " " + amis.nom
            
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    
    @IBAction func deconnexionAction(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogin")
        self.performSegueWithIdentifier("loginView", sender: self)
        
    }
    
    
    /* func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
     {
     let location = locations.last
     
     let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
     
     let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
     
     self.mapView.setRegion(region, animated: true)
     
     self.locationManager.stopUpdatingLocation()
     }
     
     func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
     {
     print("Errors: " + error.localizedDescription)
     }*/
    
    
}


