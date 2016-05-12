class Amis {
    var mesAmis : [UtilisateurDTO]
    
    init(){
        self.mesAmis = []
    }
    
    init(mesAmis : [UtilisateurDTO]){
        self.mesAmis = mesAmis
    }
}