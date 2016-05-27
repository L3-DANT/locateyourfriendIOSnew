import CoreLocation
class UtilisateurDTO{
    
    //UserDTO est un user sans mot de passe
    //C'est le modèle d'un user dans une liste d'amis
    
    var nom : String
    var prenom : String
    var email : String
    var localisation : CLLocationCoordinate2D
    
    init(){
        nom = ""
        prenom = ""
        email = ""
        localisation = CLLocationCoordinate2D()
    }
    
    init(utilisateurDTO : UtilisateurDTO){
        self.nom = utilisateurDTO.nom
        self.prenom = utilisateurDTO.prenom
        self.email = utilisateurDTO.email
        self.localisation = utilisateurDTO.localisation
    }
    
    init(nom : String, prenom : String, email : String, localisation : CLLocationCoordinate2D){
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.localisation = localisation
    }
    
}