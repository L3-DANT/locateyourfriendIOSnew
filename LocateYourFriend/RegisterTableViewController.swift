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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "fond"))
        
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
        return 6
    }
    
    
    @IBAction func registrationButtonTapped(unwindSegue: UIStoryboardSegue) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRetapePassword = userRetapePasswordTextField.text
        let userName = userNameTextField.text
        let userFirstName = userFirstNameTextField.text
        
        
        if(userEmail!.isEmpty || userPassword!.isEmpty ||  userName!.isEmpty || userFirstName!.isEmpty ){
            // Affiche un message d'erreur
            afficheMessageAlert("Tous les champs doivent être remplis");
            return;
        }
        
        if(userPassword != userRetapePassword){
            afficheMessageAlert("Les mots de passe ne sont pas identiques")
            return
        }
        
        // On fait la session
        
        let postEndpoint: String = "http://172.20.10.3:8080/locateyourfriend/rest/bienvenue/bienvenueJSON"
        
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
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // On vérifie qu'on recoit une reponse et qu'on se connecte bien au serveur
            
         /*   guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    print("Ce n'est pas une réponse 200 -> Connexion au serveur ECHOUEE")
                    return
            }*/
            
            
            
            // On lit le json
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                
                
                print("le POST: " + postString)
                
                
                if(postString != "{Inscription ok}"){
                    self.afficheMessageAlert("L'inscription n'a pas pu être effectuée")
                }else{
                     NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogin")
                     self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                //self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
                
            }
            
            
            
        }).resume()
        
        
        
    }
    
    
    @IBAction func jaiUnCompte(unwindSegue: UIStoryboardSegue) {
    }
        func afficheMessageAlert(message : String){
        let myAlert = UIAlertController(title:"Alert", message : message, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"ok",style:UIAlertActionStyle.Default, handler:nil);
        
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