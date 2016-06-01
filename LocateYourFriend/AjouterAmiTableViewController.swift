//
//  AjouterAmiTableViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 30/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit
import CoreLocation

class AjouterAmiTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var listeUsr : [UtilisateurDTO] = [UtilisateurDTO]()
    var amisFiltres = [UtilisateurDTO]()
    var searchController : UISearchController!
    var resultsController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }

        
        // On récupère la liste des utilisateurs de l'application
        
        self.getListeUtilisateurs()
        

        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController:self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        // Pour enlever l'espace du dessus
        definesPresentationContext = true    }

    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func getListeUtilisateurs(){
        
        // On fait la session
        
        let postEndpoint: String = "http://5.51.52.0:8080/locateyourfriendJAVA/rest/appli/getUsers"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = [:]
        
        
        
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
                        print("Ce n'est pas une réponse 200 *-> Connexion au serveur ECHOUEE")
                        return
                }
                
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                
                
                let testtab : NSArray! = json 
                
                let max : Int =  testtab.count - 1
                
                
                for index in 0...max{
                    let emailDTO = json[index]["email"] as! String
                    let nomDTO = json[index]["nom"] as! String
                    let prenomDTO = json[index]["prenom"] as! String
                    
                    self.listeUsr += [UtilisateurDTO(nom : nomDTO, prenom : prenomDTO, email : emailDTO, localisation: CLLocationCoordinate2D())]
                    
                }
                
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        
        self.amisFiltres = self.listeUsr.filter { (ami:UtilisateurDTO) -> Bool in
            if(ami.nom.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString) || ami.prenom.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString) ){
                return true
            }else{
                return false
            }
        }
        
        self.resultsController.tableView.reloadData()
        
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.amisFiltres.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
         if (tableView != self.tableView){
            
        
        cell.textLabel?.text = self.amisFiltres[indexPath.row].prenom + " " + self.amisFiltres[indexPath.row].nom
        
        
        
        // Si l'utilisateur n'est pas son ami on affiche le bouton sinon on affiche une image
        
        
        
        if(Utilisateur.userSingleton.mesAmis.mesAmis.contains({ $0.email == self.amisFiltres[indexPath.row].email })){
            let dejaAmis : UILabel = UILabel()
            dejaAmis.text = "Déjà amis"
            dejaAmis.font = UIFont(name:"Chalkboard SE", size:16)
            dejaAmis.textColor = UIColor.grayColor()
            dejaAmis.frame = CGRectMake(270,10,100,25)
            cell.addSubview(dejaAmis)
            
        }else{
            let button : UIButton = UIButton(type: .Custom)
            button.frame = CGRectMake(325,10, 25, 25)
            button.setImage(UIImage(named: "addfriend"), forState: UIControlState.Normal)
            // button.setValue(self.amisFiltres[indexPath.row], forKey: "friendToAdd")
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(AjouterAmiTableViewController.buttonClicked(_:)), forControlEvents:UIControlEvents.TouchUpInside)

            cell.addSubview(button)
        }
        
        // Custumisation de la cellule
        
        cell.textLabel?.font = UIFont(name:"Chalkboard SE", size:16)
        cell.textLabel?.textColor = UIColor.orangeColor()
        }
        return cell
    }
    
    
    
    func buttonClicked(sender : UIButton){
        
        // On récupère l'ami à ajouter
        let usr : UtilisateurDTO = self.amisFiltres[sender.tag]
        
        // On fait la session
        
      
        let postEndpoint: String = "http://5.51.52.0:8080/locateyourfriendJAVA/rest/appli/addAmis?user1=\(Utilisateur.userSingleton.email)&user2=\(usr.email)"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = [:]
        
        
        
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
                print("Mon utilisateur renvoyé:\(json)")
                
                
                if(json["errorMessage"] != nil){
                    print("L'ajout d'ami n'a pas pu se faire : \(json["errorMessage"])")
                }else{
                    // On met à jour notre utilisateur
                    Utilisateur.userSingleton.configureUserSingleton(json as! [String : AnyObject])
                    
                    // On redirige
                     self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
        
        
    }
    
    
    func afficheMessageAlert(message : String){
        let myAlert = UIAlertController(title:"Attention", message : message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Fermer",style:UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
        
    }
    


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}