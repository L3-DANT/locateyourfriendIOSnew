//
//  RegisterTableViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 12/03/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userRetapePasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBAction func jaiUnCompte(sender: AnyObject) {
   dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 7
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBAction func registrationButtonTapped(unwindSegue: UIStoryboardSegue) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRetapePassword = userRetapePasswordTextField.text
        let userName = userNameTextField.text
        let userFirstName = userFirstNameTextField.text
        
        var message : String = ""
        
        if(userEmail!.isEmpty || userPassword!.isEmpty ||  userName!.isEmpty || userFirstName!.isEmpty ){
            message = message + "Tous les champs doivent être remplis \n"
        }
        
        if(userPassword != userRetapePassword){
            message = message + "Les mots de passe de correspondent pas \n"
        }
        
        if(userPassword?.characters.count < 8){
            message = message + "Le mot de passe doit avoir au moins 8 caractères \n"
        }
        
        if(userName?.characters.count < 2 || userFirstName?.characters.count < 2){
            message = message + "Le nom ou le prénom est trop court \n"
        }
        if(!validateEmail(userEmail!)){
            message = message + "Votre adresse mail est invalide \n"
        }
        
        if(message != ""){
            self.afficheMessageAlert(message)
            return
        }
        
        // On fait la session
        
        let postEndpoint: String = "http://5.51.52.0:8080/locateyourfriendJAVA/rest/appli/inscription/"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["email":userEmail!,"motDePasse":userPassword!,"nom":userName!,"prenom":userFirstName!]
        
        
        
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
                    print("Erreur lors de l'inscription : \(json["errorMessage"])")
                   
                }else{
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "inscriptionConfig")
                    Utilisateur.userSingleton.configureUserSingleton(json as! [String : AnyObject]) 
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogin")
                     NSUserDefaults.standardUserDefaults().setBool(false, forKey: "inscriptionConfig")
                    
                     let isInscription = NSUserDefaults.standardUserDefaults().boolForKey("inscriptionConfig")
                    print("isInscription : \(isInscription)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    
                }
                
                
            } catch let error as JSONError {
                print(error.rawValue)
                print("on est dans le premier catch")
            } catch let error as NSError {
                print(error.debugDescription)
                print("on est dans le deuxieme catch")
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