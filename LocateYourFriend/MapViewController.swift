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
    var usr = Utilisateur.userSingleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //locationManager(CLLocationManager, didUpdateLocations locations :<#T##[CLLocation]#>)
        
        //On récupère la valeur de la clé isUserLogin pour savoir si l'utilisateur est connecté
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
        
        //S'il n'est pas connecté, on le redirige vers la page de connexion
        
        if !isUserLoggedIn
        {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        
        // Pour la map
        if CLLocationManager.locationServicesEnabled() {//Verification
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        }
        
       
        
        
        
        //Pour le menu
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        //Pour afficher les amis
        
        //Liste factice d'amis
        usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "DUPONT",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(45.750000,4.850000))]//location Lyon
        usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "MARTIN",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(47.3590900,3.3852100))] //Location Varzy
        usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "ZITOUN",prenom: "khaoula",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]
       
        //print(usr.mesAmis.mesAmis)//Pour afficher la liste crée
        //print(usr.mesAmis.mesAmis[2].nom)
        
     
        
        /*for index in 0...2 {
            print(usr.mesAmis.mesAmis[index].nom)
        }*/
        
        for ami in usr.mesAmis.mesAmis{
            let testannotation = MKPointAnnotation()
            testannotation.title = ami.nom + " " + ami.prenom
            testannotation.subtitle = "Votre ami est la !"
            testannotation.coordinate = ami.localisation
            
            mapView.addAnnotation(testannotation)
        }
        
        //Marquer pour ma position
        /*let maPositionAnnotation = MKPointAnnotation()
        maPositionAnnotation.title = "Vous"
        maPositionAnnotation.subtitle = "Je suis la !"
        maPositionAnnotation.coordinate = (locationManager.location?.coordinate)!
        mapView.addAnnotation(maPositionAnnotation)*/
        
        /*func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last
            
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.map.setRegion(region, animated: true)
        }*/
        
        //Coder une fonction pour demander au serveur toutes les 5 mins la positions de mes amis
        
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    //Pour afficher ma position actuelle
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //var compareValue : CLLocationCoordinate2D
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        let maPosition = Localisation(localisation: locValue)
        
        //send au serveur puisque cette fonction est executé a chaque changement de positions
        
        
        // On fait la session
        
        let postEndpoint: String = "http://172.20.10.7:8080/locateyourfriendJAVA/rest/appli/localisation/"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["email":"test@test.fr", "motDePasse":Utilisateur.userSingleton.motDePasse,"nom":Utilisateur.userSingleton.nom,"prenom":Utilisateur.userSingleton.prenom, "latitude": maPosition.latitudeLoc, "longitude": maPosition.longitudeLoc]
       
        
        // On créé la requete
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            
        } catch {
            
            print("bad things happened")
            
        }
        
        // On appelle le post
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            do {
                
                // On vérifie qu'on recoit une reponse et qu'on se connecte bien au serveur
                
                guard let realResponse = response as? NSHTTPURLResponse where
                    
                    realResponse.statusCode == 200 else {
                        print("Ce n'est pas une réponse 200 -> Connexion au serveur ECHOUEE")
                        return
                }
                
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                
                
                if(json["error"] != nil){
                    //self.afficheMessageAlert("L'inscription n'a pas pu être effectuée, \(json["error"])")
                    return
                }else{
                    //Utilisateur.utilisateur.configureUtilisateur(json as! [String : AnyObject]) //Problème à regler
                    //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogin")
                    //self.dismissViewControllerAnimated(true, completion: nil)
                    //print("OK")
                    
                }
                
                
            } catch let error as JSONError {
                print(error.rawValue)
                print("on est dans le premier catch")
            } catch let error as NSError {
                print(error.debugDescription)
                print("on est dans le deuxieme catch")
            }
            }.resume()


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
        
        /*for amis in Utilisateur.utilisateur.mesAmis.mesAmis {
            
            let location : CLLocationCoordinate2D = amis.localisation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = amis.prenom + " " + amis.nom
            
            mapView.addAnnotation(annotation)
            
        }*/
        
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


