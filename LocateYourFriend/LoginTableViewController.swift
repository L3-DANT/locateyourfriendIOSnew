//
//  LoginTableViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 12/03/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultValueEmail = ["emailUser" : ""]
        let defaultValuePrenom = ["prenomUser" : ""]
        let defaultValueNom = ["nomUser" : ""]
        let defaultValueMdp = ["mdpUser" : ""]
        let defaultValuePartagePosition = ["partagePosition" : true]
        defaults.registerDefaults(defaultValueEmail)
        defaults.registerDefaults(defaultValuePrenom)
        defaults.registerDefaults(defaultValueNom)
        defaults.registerDefaults(defaultValueMdp)
        defaults.registerDefaults(defaultValuePartagePosition)
        
        defaults.synchronize()

        
        //let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin")
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin"){
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        print(NSUserDefaults.standardUserDefaults().boolForKey("partagePosition"))
        print(NSUserDefaults.standardUserDefaults().boolForKey("isUserLogin"))
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
        return 4
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        if(userEmail!.isEmpty || userPassword!.isEmpty){
            // Affiche un message d'erreur
            afficheMessageAlert("Tous les champs doivent être remplis");
            return;
        }
        
        
        
        // On fait la session
        
        /* CHANGER L URL UNE FOIS PRETE */
        
        let postEndpoint: String = "http://172.20.10.9:8080/locateyourfriendJAVA/rest/appli/authentification"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["email":userEmail!,"motDePasse":userPassword!]
        
        print("mon email "+userEmail! + "mon mdp " + userPassword!)
        
        
        
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
                
                
                
                
                if(json["errorMessage"] != nil){
                    print("erreur json")
                    
                    //Attention si le mot de passe est pas bon on passe quand même sur la map view correction rapide le afficheMessageAlert bug
                    //self.afficheMessageAlert("La connexion n'a pas pu être effectuée, \(json["errorMessage"])")

                }else{
                    Utilisateur.userSingleton.configureUserSingleton(json as! [String : AnyObject])
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogin")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    print(Utilisateur.userSingleton.email)
                    
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
