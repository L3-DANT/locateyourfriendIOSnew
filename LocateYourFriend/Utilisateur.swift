import CoreLocation
class Utilisateur {
    static let userSingleton = Utilisateur()
    
    var nom : String
    var prenom : String
    var email : String
    var motDePasse : String
    var mesAmis : Amis
    
    
    init(){
        nom = ""
        prenom = ""
        email = ""
        motDePasse = ""
        mesAmis = Amis()
        
    }
    
    func configureUserSingleton(param : [String : AnyObject]){
       
        print("on entre dans la fonction de configuration du singleton")
        if (param["nom"] != nil ){nom = param["nom"]! as! String}
        if (param["prenom"] != nil ){prenom = param["prenom"]! as! String}
        if (param["email"] != nil ){email = param["email"]! as! String}
        if (param["motDePasse"] != nil ){motDePasse = param["motDePasse"]! as! String}
        mesAmis = Amis()
        
        let isInscription = NSUserDefaults.standardUserDefaults().boolForKey("inscriptionConfig")
        print("isinscrio dans utilisateur :\(isInscription)")
       
        if(!isInscription){
            
            print("ce n'est pas inscription")
            //if( != nil){
        
            print("on est dans le if")
            
            
            let testtab : NSArray! = param["mesAmis"]!["listUtil"] as! NSArray
                print (testtab.count)
                if( testtab.count != 0){
                    print (testtab)
        
            let max : Int =  testtab.count - 1
            
            
            for index in 0...max{
                let emailDTO = param["mesAmis"]!["listUtil"]!![index]["email"] as! String
                let nomDTO = param["mesAmis"]!["listUtil"]!![index]["nom"] as! String
                let prenomDTO = param["mesAmis"]!["listUtil"]!![index]["prenom"] as! String
                
                self.mesAmis.mesAmis += [UtilisateurDTO(nom : nomDTO, prenom : prenomDTO, email : emailDTO, localisation: CLLocationCoordinate2D())]
                
            }

        }
        }
        
        
        SetFirstNSUserDefaultsForUser()
        SetNsUserDefaultsForUser(nom, prenomUser: prenom, emailUser: email, mdpUser: motDePasse)

        
    }
    
    private func SetFirstNSUserDefaultsForUser(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if((defaults.stringForKey("emailUser") != nil || defaults.stringForKey("prenomUser") != nil || defaults.stringForKey("nomUser") != nil || defaults.stringForKey("mdpUser") != nil)){
            
            SetEmptyNsUserDefaultsForUser()
            
            print("Mes cle/valeur existent")
            
        }else{
            
            print("Mes cle/valeur n'existent pas")
            //Pour créer clé/valeur vide
            let defaultValueEmail = ["emailUser" : ""]
            let defaultValuePrenom = ["prenomUser" : ""]
            let defaultValueNom = ["nomUser" : ""]
            let defaultValueMdp = ["mdpUser" : ""]
            defaults.registerDefaults(defaultValueEmail)
            defaults.registerDefaults(defaultValuePrenom)
            defaults.registerDefaults(defaultValueNom)
            defaults.registerDefaults(defaultValueMdp)

            
            defaults.synchronize()
            //Penser a supprimer sa lors de la déconnexion
            
            //Test
            //Pour la lire la valeur associé à la clé
            let tokenEmail3 : String = defaults.stringForKey("emailUser")!
            let tokenPrenom3 : String = defaults.stringForKey("prenomUser")!
            let tokenNom3 : String = defaults.stringForKey("nomUser")!
            
            print("SetFist Value : " + tokenNom3 + " " + tokenPrenom3 + " " + tokenEmail3)
            
        }
        
    }
    
    func SetEmptyNsUserDefaultsForUser(){
        //Pour garder des valeurs sur l'appareil
        
        //Pour créer clé/valeur vide
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("", forKey: "nomUser")
        defaults.setObject("", forKey: "prenomUser")
        defaults.setObject("", forKey: "emailUser")
        
        defaults.synchronize()
        //Penser a supprimer sa lors de la déconnexion
        
        //Test
        //Pour la lire la valeur associé à la clé
        let tokenEmail : String = defaults.stringForKey("emailUser")!
        let tokenPrenom : String = defaults.stringForKey("prenomUser")!
        let tokenNom : String = defaults.stringForKey("nomUser")!
        
        print("SetEmpty value : " + tokenNom + " " + tokenPrenom + " " + tokenEmail)

    }
    
    private func SetNsUserDefaultsForUser(nomUser : String, prenomUser : String, emailUser : String, mdpUser : String){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Pour sauver la valeur avec la clé
        defaults.setObject(nomUser, forKey: "nomUser")
        defaults.setObject(prenomUser, forKey: "prenomUser")
        defaults.setObject(emailUser, forKey: "emailUser")
        defaults.setObject(emailUser, forKey: "mdpUser")
        
        
        defaults.synchronize()
        
        //Test
        //Pour la lire la valeur associé à la clé
        let tokenEmail2 : String = defaults.stringForKey("emailUser")!
        let tokenPrenom2 : String = defaults.stringForKey("prenomUser")!
        let tokenNom2 : String = defaults.stringForKey("nomUser")!
        
        print("SetExisting value : " + tokenNom2 + " " + tokenPrenom2 + " " + tokenEmail2)

    }
    
    func configureUserSingleton(nomUser :String, prenomUser : String, emailUser :String, motDePasseUser : String){
        
        nom = nomUser
        prenom = prenomUser
        email = emailUser
        motDePasse = motDePasseUser
        mesAmis = Amis()
        
    }

    
}


