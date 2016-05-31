//
//  PhoneData.swift
//  LocateYourFriend
//
//  Created by Brandon Caurel on 31/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import Foundation

class PhoneData {
    
    var dataEmail = ""
    var dataPrenom = ""
    var dataNom = ""
    
    init(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Pour la lire la valeur associé à la clé
        let tokenEmail : String = defaults.stringForKey("emailUser")!
        let tokenPrenom : String = defaults.stringForKey("prenomUser")!
        let tokenNom : String = defaults.stringForKey("nomUser")!
        
        dataEmail = tokenEmail
        dataPrenom = tokenPrenom
        dataNom = tokenNom
        
        print("SetExisting value : " + tokenNom + " " + tokenPrenom + " " + tokenEmail)
        
        
    }
    
}