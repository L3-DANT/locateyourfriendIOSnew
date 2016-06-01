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
    //let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
    //let partagePosition = NSUserDefaults.standardUserDefaults().boolForKey("partagePosition")
    var removedAnnotations = [MKPointAnnotation()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //On récupère la valeur de la clé isUserLogin pour savoir si l'utilisateur est connecté
        
        //S'il n'est pas connecté, on le redirige vers la page de connexion
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
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
        
        //Pour demander les nouvelles positions eventuelles de mes amis j'instancie un timer et je le lance
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.updateAmisPositions), userInfo: nil, repeats: true)
        timer.fire()
        //print("Timer lancé")
        
    }
    
    func updateAmisPositions(){//Fonction appellée à la fin du timer
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin") != false{
            
            print("coucou if")
            //print("Ca fait 10 secondes")
            
            //Je supprimes les anciennes annotations si il y en a
            //Pour supprimer des annotations
            
            mapView.removeAnnotations(removedAnnotations)
            
            //Je recupere mes positions amis via une requete
            //get.Amis
            //faire un if position amis == 0 pour savoir si ils sont connecté
            
            
            //REQUETE JE DEMANDE AU SERVEUR MES AMIS POUR AVOIR LEUR POSITIONS
            
            // On fait la session
            
            print("recup coordonées amis")
            
            let postEndpoint: String = "http://172.20.10.9:8080/locateyourfriendJAVA/rest/appli/listeAmis"
            
            let url = NSURL(string: postEndpoint)!
            
            let session = NSURLSession.sharedSession()
            
            let postParams : [String: AnyObject] = ["email":Utilisateur.userSingleton.email, "motDePasse":Utilisateur.userSingleton.motDePasse,"nom":Utilisateur.userSingleton.nom,"prenom":Utilisateur.userSingleton.prenom]
            
            
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
                        
                        
                        //print("ma liste d'utilisateurs \(json["Amis"]!["listUtil"])")
                        
                        
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

            
            
            
            
            //Et les inser dans mon user singleton
            
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
            
            //Je stocke ces annotations pour pouvoir les supprimer à la prochaine update de position
            
            removedAnnotations = UpdatedAnnotations
            
        }
        
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    
    
    //Pour afficher ma position actuelle
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValueCCL:CLLocationCoordinate2D = manager.location!.coordinate
        
        print(comparedPositionCCL)
        print(locValueCCL)
        
        if(comparedPositionCCL.latitude == 0.0 && comparedPositionCCL.longitude == 0.0){
            comparedPositionCCL = locValueCCL
            print("if compared == 00")
        }
        if(comparedPositionCCL.latitude != locValueCCL.latitude || comparedPositionCCL.longitude != locValueCCL.longitude){
            
            print("if compared != local")
            
            print("bool partagePosition : ")
            print(NSUserDefaults.standardUserDefaults().boolForKey("partagePosition"))
            print("bool isUserlogin : ")
            print(NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin"))
             
             //send au serveur puisque cette fonction est executé a chaque changement de positions
            
            if(NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin") == true && NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin") == true){
                
                //REQUETE ENVOI MA LOCALISATION POUR LE SERVEUR
                // On fait la session
                
                print("envoie coordonées")
                
                let postEndpoint: String = "http://172.20.10.9:8080/locateyourfriendJAVA/rest/appli/localisation/"
                
                let url = NSURL(string: postEndpoint)!
                
                let session = NSURLSession.sharedSession()
                
                let postParams : [String: AnyObject] = ["email":Utilisateur.userSingleton.email, "motDePasse":Utilisateur.userSingleton.motDePasse,"nom":Utilisateur.userSingleton.nom,"prenom":Utilisateur.userSingleton.prenom, "latitude": locValueCCL.latitude/*maLocActuelle.latitudeLoc*/, "longitude": locValueCCL.longitude/*maLocActuelle.longitudeLoc*/]
                
                
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
                
                //comparedPositionCCL = locValueCCL
                
            }//Fin if(isUserLoggedIn == true)
            
            // }// Fin if( difflatitude > diffMax || difflongitude > diffMax)
            
            //}// Fin if(maDerniereLoc.latitudeLoc != maLocActuelle.latitudeLoc || maDerniereLoc.longitudeLoc != maLocActuelle.longitudeLoc)
            
            comparedPositionCCL = locValueCCL
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        print("mon signle : \(usr.mesAmis.mesAmis.count)")
        
    }
    
    
    @IBAction func deconnexionAction(sender: AnyObject) {
        
        //QUand l'utilisateur se deconnexte il envoie en terme de localisation, une localisation à zero, comme ça lorqu'on le recoit si localisation ami == 0 il est deconnecté on ne l'affiche pas.
        
        // On fait la session
        
        print("envoie coordonées fon de connexion ")
        
        let postEndpoint: String = "http://172.20.10.9:8080/locateyourfriendJAVA/rest/appli/localisation/"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["email":Utilisateur.userSingleton.email, "motDePasse":Utilisateur.userSingleton.motDePasse,"nom":Utilisateur.userSingleton.nom,"prenom":Utilisateur.userSingleton.prenom, "latitude": 0, "longitude": 0]
        
        
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

        
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogin")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "inscriptionConfig")
        self.performSegueWithIdentifier("loginView", sender: self)
        
        //Lors de la déconnexion, les clés/valeurs enregistrées doivent être remise à zero
        Utilisateur.userSingleton.SetEmptyNsUserDefaultsForUser()
        
    }
    
}


