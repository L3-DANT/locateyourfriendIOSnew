import CoreLocation
class Utilisateur {
    static let utilisateur = Utilisateur()
    
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
    
    
    func configureUtilisateur(param : [String : AnyObject]){
        
        nom = param["nom"]! as! String
        prenom = param["prenom"] as! String
        email = param["email"] as! String
        motDePasse = param["motDePasse"] as! String
        
        if(param["mesAmis"] == nil){
            //mesAmis = Amis()
            mesAmis = Amis(mesAmis: [UtilisateurDTO(nom: "DUPONT",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))])
            
        }else{
            mesAmis = Amis(mesAmis: param["mesAmis"]! as![UtilisateurDTO])
        }
        
        
    }
    
}