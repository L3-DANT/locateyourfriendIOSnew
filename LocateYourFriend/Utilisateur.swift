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
        
       
        if (param["nom"] != nil ){nom = param["nom"]! as! String}
        if (param["prenom"] != nil ){prenom = param["prenom"]! as! String}
        if (param["email"] != nil ){email = param["email"]! as! String}
        if (param["motDePasse"] != nil ){motDePasse = param["motDePasse"]! as! String}
        
        if(param["listUtil"] == nil){
            mesAmis = Amis()
        }else{
            mesAmis = Amis(mesAmis: param["listUtil"]! as![UtilisateurDTO])
        }
        
        //Pour garder les valeurs sur l'appareil
        
        //Pour créer clé/valeur vide
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultValueEmail = ["emailUser" : ""]
        let defaultValuePrenom = ["prenomUser" : ""]
        let defaultValueNom = ["nomUser" : ""]
        defaults.registerDefaults(defaultValueEmail)
        defaults.registerDefaults(defaultValuePrenom)
        defaults.registerDefaults(defaultValueNom)
        
        //Pour la lire la valeur associé à la clé
        //let defaults = NSUserDefaults.standardUserDefaults()
        //let token : String = defaults.stringForKey("MyKey")!
        
        //Pour sauver la valeur avec la clé
        if(nom != ""){defaults.setObject(nom, forKey: "nomUser")}
        if(prenom != ""){defaults.setObject(prenom, forKey: "prenomUser")}
        if(email != ""){defaults.setObject(email, forKey: "emailUser")}
        
        defaults.synchronize()
        //Penser a supprimer sa lors de la déconnexion 
        
        
    }
    
    /*func configureUserSingleton(nomUser :String, prenomUser : String, emailUser :String, motDePasseUser : String){
        
        
        self.nom = nomUser
        prenom = prenomUser
        email = emailUser
        motDePasse = motDePasseUser
        mesAmis = Amis()
        
    }*/

    
}


