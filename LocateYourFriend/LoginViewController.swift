//
//  LoginViewController.swift
//  LocateYourFriend1
//
//  Created by m2sar on 11/02/2016.
//  Copyright (c) 2016 m2sar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail");
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword");
        
        if(userEmailStored == userEmail){
            if(userPasswordStored == userPassword){
                // Conenxion réussie
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogin");
                NSUserDefaults.standardUserDefaults().synchronize();
                
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
        
        /*if(userEmail.isEmpty || userPassword.isEmpty) { return }
        
        // On envoie les infos au serveur
        
        let myURL = NSURL(string: "http://132.227.125.151:/");
        let request = NSMutableURLRequest(URL : myURL!);
        request.HTTPMethod = "POST";
        
        let postString = "email=\(userEmail)&password=\(userPassword)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        //Requête à executer
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
        data, response, error in
        
        if error != nil{
        println("error=\(error)")
        return
        }
        
        
        //On converti la réponse du serveur en Json dans un dictionnaire
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
        
        //On récupère du dictionnaire les clés qui nous intéressent
        if let parseJSON = json {
        var resultValue = parseJSON["status"] as? String
        println("result: \(resultValue)")
        
        var isUserRegistrated:Bool = false;
        if(resultValue=="Success")
        {
        // Conenxion réussie
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogin");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        self.dismissViewControllerAnimated(true, completion: nil);
        }
        
        }
        }
        
        task.resume();*/
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
