//
//  MesInformationsTableViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 16/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit

class MesInformationsTableViewController: UITableViewController {
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var nomField: UITextField!
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    var usr = Utilisateur.userSingleton
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }

    @IBAction func enregistrerModifs(sender: AnyObject) {
        
        let nom = nomField.text
        let prenom = prenomField.text
        let email = emailField.text
        
        var message : String = ""
        
        if(nom!.isEmpty || prenom!.isEmpty || email!.isEmpty){
            message = message + "Tous les champs doivent être remplis"
        }
        
        if(!validateEmail(emailField.text!)){
            message = message + "Votre adresse mail est invalide \n"
        }
        
        if(message != ""){
            self.afficheMessageAlert(message)
            return
        }
        
        
        // On fait la session
        
        /* CHANGER L URL UNE FOIS PRETE */
        
        let postEndpoint: String = "http://localhost:8080/locateyourfriend/rest/bienvenue/bienvenueJSON"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["nom": nom!,"prenom": prenom!,"email":email!]
        
        
        
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
                    self.afficheMessageAlert("La modification n'a pas pu être effectuée, \(json["error"])")
                }else{
                    Utilisateur.userSingleton.configureUserSingleton(json as! [String : String])
                   self.afficheMessageAlert("La modification a bien été prise en compte")
                }
                
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()

        
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    func afficheMessageAlert(message : String){
        let myAlert = UIAlertController(title:"Attention", message : message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Fermer",style:UIAlertActionStyle.Default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        //Pour la lire la valeur associé à la clé
        let defaults = NSUserDefaults.standardUserDefaults()
        let dataEmailUser : String = defaults.stringForKey("emailUser")!
        let dataPrenomUser : String = defaults.stringForKey("prenomUser")!
        let dataNomUser : String = defaults.stringForKey("nomUser")!
        
        nomField.text = dataNomUser
        prenomField.text = dataPrenomUser
        emailField.text = dataEmailUser
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
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
