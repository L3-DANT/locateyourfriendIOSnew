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
    var comparedPositionCCL : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
    var removedAnnotations = [MKPointAnnotation()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //On récupère la valeur de la clé isUserLogin pour savoir si l'utilisateur est connecté
        
       // print(isUserLoggedIn)
        
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
        /*usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "DUPONT",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(45.750000,4.850000))]//location Lyon
        usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "MARTIN",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(47.3590900,3.3852100))] //Location Varzy
        usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "ZITOUN",prenom: "khaoula",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]*/
       
        //print(usr.mesAmis.mesAmis)//Pour afficher la liste crée
        //print(usr.mesAmis.mesAmis[2].nom)
        
        /*for index in 0...2 {
            print(usr.mesAmis.mesAmis[index].nom)
        }*/
        
        //Affichage sur la map de mes amis
        /*for ami in usr.mesAmis.mesAmis{
            //let testannotation = MKPointAnnotation()
            testannotation.title = ami.nom + " " + ami.prenom
            testannotation.subtitle = "Votre ami est la !"
            testannotation.coordinate = ami.localisation
            
            mapView.addAnnotation(testannotation)
        }*/
        
        //Marquer ma position
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
        
        //Pour demander les nouvelles positions eventuelles de mes amis j'instancie un timer et je le lance
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.updateAmisPositions), userInfo: nil, repeats: true)
        timer.fire()
        //print("Timer lancé")
        
    }
    
    func updateAmisPositions(){//Fonction appellée à la fin du timer
        
        if isUserLoggedIn != false{
            
            //print("coucou if")
            
            //print("Ca fait 10 secondes")
            
            //Je supprimes les anciennes annotations si il y en a
            
            //Pour supprimer des annotations
            mapView.removeAnnotations(removedAnnotations)
            
            //Je recupere mes positions amis via une requete
            //get.Amis
            
            //Et les inser dans mon user singleton
            
            //Liste factice d'amis qui change a chaque appel
         /*   usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "DUPONT",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(44.750000,5.850000))]//location Lyon
            usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "MARTIN",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(46.3590900,2.3852100))] //Location Varzy
            usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "ZITOUN",prenom: "khaoula",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(49.95,3.3833))]*/
            
            //J'ajoute mes positions en annotations
            var UpdatedAnnotations = [MKPointAnnotation()]
            
            for ami in usr.mesAmis.mesAmis{
                
                let UpdatedAnnotation = MKPointAnnotation()
                UpdatedAnnotation.title = ami.nom + " " + ami.prenom
                UpdatedAnnotation.subtitle = "Votre ami est la !"
                UpdatedAnnotation.coordinate = ami.localisation
                
                UpdatedAnnotations.append(UpdatedAnnotation)
                
            }
            
            mapView.addAnnotations(UpdatedAnnotations)
            
            //Je stocke ces annotations pour pouvoir les supprimer
            
            removedAnnotations = UpdatedAnnotations
            
        }
        
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    
    
    //Pour afficher ma position actuelle
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //var compareValue : CLLocationCoordinate2D
        
        //UpdateLocation sans le controle d'envoi de position
        //let locValueCCL:CLLocationCoordinate2D = manager.location!.coordinate
        //let maLocalisationActuelle = Localisation(localisation: locValueCCL)
        //Et enlever la requête du if
        
        
        let locValueCCL:CLLocationCoordinate2D = manager.location!.coordinate
        let maLocActuelle = Localisation(localisation: locValueCCL)
        let maDerniereLoc = Localisation(localisation: comparedPositionCCL)
        
       // print(comparedPositionCCL)
        
        if(comparedPositionCCL.latitude == 0.0 && comparedPositionCCL.longitude == 0.0){
            comparedPositionCCL = locValueCCL
        }
        
     /*   print("Ma derniere localisation : " + String(maDerniereLoc.latitudeLoc) + "," + String(maDerniereLoc.longitudeLoc))
        print("Ma nouvelle position : " + String(maLocActuelle.latitudeLoc) + "," + String(maLocActuelle.longitudeLoc) )*/
        
        
        if(maDerniereLoc.latitudeLoc != maLocActuelle.latitudeLoc || maDerniereLoc.longitudeLoc != maLocActuelle.longitudeLoc){
            let difflatitude : Float = abs(maDerniereLoc.latitudeLoc - maLocActuelle.latitudeLoc)
            let difflongitude : Float = abs(maDerniereLoc.longitudeLoc - maLocActuelle.longitudeLoc)
            let diffMax : Float = 0.00010 //10 mètres
            
          /*  print(difflongitude)
            print( abs(difflongitude))
            print(diffMax)*/
            
            if( difflatitude > diffMax || difflongitude > diffMax){
            
                //send au serveur puisque cette fonction est executé a chaque changement de positions
                
                let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
                
                if(isUserLoggedIn == true){
                    
                    // On fait la session
                    
                    let postEndpoint: String = "http://5.51.52.0:8080/locateyourfriendJAVA/rest/appli/localisation/"
                    
                    let url = NSURL(string: postEndpoint)!
                    
                    let session = NSURLSession.sharedSession()
                    
                    let postParams : [String: AnyObject] = ["email":"test@test.fr", "motDePasse":Utilisateur.userSingleton.motDePasse,"nom":Utilisateur.userSingleton.nom,"prenom":Utilisateur.userSingleton.prenom, "latitude": maLocActuelle.latitudeLoc, "longitude": maLocActuelle.longitudeLoc]
                    
                    
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
                           // print(json)
                            
                            
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
                    
                    comparedPositionCCL = locValueCCL
                    
                }//Fin if(isUserLoggedIn == true)
                
            }// Fin if( difflatitude > diffMax || difflongitude > diffMax)
        
        }// Fin if(maDerniereLoc.latitudeLoc != maLocActuelle.latitudeLoc || maDerniereLoc.longitudeLoc != maLocActuelle.longitudeLoc)
        
    }
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        print("mon signle : \(usr.mesAmis.mesAmis.count)")
        
    }
    
    
    @IBAction func deconnexionAction(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogin")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "inscriptionConfig")
        self.performSegueWithIdentifier("loginView", sender: self)
        
        //Lors de la déconnexion, les clés/valeurs enregistrées doivent être remise à zero
        Utilisateur.userSingleton.SetEmptyNsUserDefaultsForUser()
        
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


