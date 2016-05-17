//
//  MesAmisTableViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 17/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit
import CoreLocation

class MesAmisTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet var myTableView: UITableView!
   var usr = Utilisateur.utilisateur
    var amisFiltres = [UtilisateurDTO]()
  

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "DUPONT",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]
           usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "MARTIN",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]
           usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "ZITOUN",prenom: "khaoula",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]
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
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return self.amisFiltres.count
        }
        else
        {
            return usr.mesAmis.mesAmis.count
        }

      
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.myTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var ami : UtilisateurDTO
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            ami = self.amisFiltres[indexPath.row]
        }
        else
        {
            ami = self.usr.mesAmis.mesAmis[indexPath.row]
        }
        
        
        cell.textLabel?.text = ami.prenom + " " + ami.nom
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var ami: UtilisateurDTO
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            ami = self.amisFiltres[indexPath.row]
        }
        else
        {
            ami = self.usr.mesAmis.mesAmis[indexPath.row]
        }
        
        print(ami.nom + ami.prenom)
        
        
    }
    
    
    
    
    func filterContetnForSearchText(searchText: String, scope: String = "Title")
        
    {
        
        self.amisFiltres = self.usr.mesAmis.mesAmis.filter({( ami : UtilisateurDTO) -> Bool in
            
            
            
            let categoryMatch = (scope == "Title")
            
            let rech : String = ami.prenom + " " + ami.nom
            
            let stringMatch = rech.rangeOfString(searchText)
            
            
            
            return categoryMatch && (stringMatch != nil)
            
            
            
        })
        
        
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool
        
    {
        
        
        
        self.filterContetnForSearchText(searchString!, scope: "Title")
        
        
        
        return true
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
        
    {
        
        
        
        self.filterContetnForSearchText(self.searchDisplayController!.searchBar.text!, scope: "Title")        
        
        return true
        
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
