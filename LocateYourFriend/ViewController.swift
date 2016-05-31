//
//  ViewController.swift
//  LocateYourFriend1
//
//  Created by m2sar on 09/02/2016.
//  Copyright (c) 2016 m2sar. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    
    let dataphone = PhoneData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (Utilisateur.userSingleton.email == ""){
            
            Utilisateur.userSingleton.configureUserSingleton(dataphone.dataNom, prenomUser: dataphone.dataPrenom, emailUser: dataphone.dataEmail, motDePasseUser: "")
        }

    }

    
   /* @IBAction func loggoutButtonTapped(sender: AnyObject) {
        
        // On passe le booléen à false
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogin")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //On redirige vers la page de connexion de l'appli
        
        self.performSegueWithIdentifier("loginView",sender:self)
    }*/
    
    /*func sideBarDidSelectButtonAtIndex(index: Int) {
        
    }*/
    
}

