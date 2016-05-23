//
//  DetailsAmiViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 18/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit

class DetailsAmiViewController: UIViewController {
    
    @IBOutlet weak var nomLabel: UILabel!
    
    @IBOutlet weak var prenomLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    var usr : UtilisateurDTO?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        nomLabel.text = usr?.nom
        prenomLabel.text = usr?.prenom
        emailLabel.text = usr?.email
        positionLabel.text = "en cours"
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
