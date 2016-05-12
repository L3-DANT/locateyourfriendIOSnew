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
        tableView.backgroundView = UIImageView(image: UIImage(named: "fond"))


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 3
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
        
        let postEndpoint: String = "http://localhost:8080/locateyourfriend/rest/bienvenue/bienvenueJSON"
        
        let url = NSURL(string: postEndpoint)!
        
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: AnyObject] = ["email":userEmail!,"motDePasse":userPassword!]
        
        
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
            
            // On vérifie qu'on recoit une reponse et qu'on se connecte bien au serveurr
            
            guard let realResponse = response as? NSHTTPURLResponse where
                
                realResponse.statusCode == 200 else {
                    print("Ce n'est pas une réponse 200 -> Connexion au serveur ECHOUEE")
                    return
            }
            
            
            
            // On lit le json
            
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                
                
                
                print("le POST: " + postString)
                
                
                if(postString != "{Connexion ok}"){
                    self.afficheMessageAlert("Votre identifiant ou votre mot de passe est erroné")
                }else{
                    self.dismissViewControllerAnimated(true, completion: nil)
                    // on redirige vers la map
                    
                }
                //self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
                
            }
            
            
            
        }).resume()
        

        


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
