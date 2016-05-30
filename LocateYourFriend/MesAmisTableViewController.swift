//
//  MesAmisTableViewController.swift
//  LocateYourFriend
//
//  Created by KhaoulaZitoun on 17/05/2016.
//  Copyright © 2016 KhaoulaZitoun. All rights reserved.
//

import UIKit
import CoreLocation

class MesAmisTableViewController: UITableViewController, UISearchResultsUpdating {


    var usr = Utilisateur.userSingleton
    var amisFiltres = [UtilisateurDTO]()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
  

    @IBOutlet weak var menuButton: UIBarButtonItem!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("nombre d'amis : \(usr.mesAmis.mesAmis.count)")
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController:self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        // Pour enlever l'espace du dessus
        definesPresentationContext = true
        
        
       /* usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "DUPONT",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]
           usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "MARTIN",prenom: "Laura",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]
           usr.mesAmis.mesAmis += [UtilisateurDTO(nom: "ZITOUN",prenom: "khaoula",email: "laura.dupont@gmail.com", localisation: CLLocationCoordinate2DMake(48.95,2.3833))]*/
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        
        self.amisFiltres = self.usr.mesAmis.mesAmis.filter { (ami:UtilisateurDTO) -> Bool in
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
        if (tableView != self.tableView){
            return self.amisFiltres.count
        }else{
            return usr.mesAmis.mesAmis.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        //var ami : UtilisateurDTO
        
        if (tableView != self.tableView){
            cell.textLabel?.text = self.amisFiltres[indexPath.row].prenom + " " + self.amisFiltres[indexPath.row].nom
        }else{
            cell.textLabel?.text =  self.usr.mesAmis.mesAmis[indexPath.row].prenom + " " + self.usr.mesAmis.mesAmis[indexPath.row].nom
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        performSegueWithIdentifier("showDetails", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var ami: UtilisateurDTO
        
        if (tableView != self.tableView){
            ami = self.amisFiltres[indexPath.row]
        }else{
            ami = self.usr.mesAmis.mesAmis[indexPath.row]
        }
        
        print(ami.nom + ami.prenom)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let rowSelected = (sender as! NSIndexPath).row
        if let destinationVC = segue.destinationViewController as? DetailsAmiViewController{
            destinationVC.usr = usr.mesAmis.mesAmis[rowSelected]
            
        }
    }
    


    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
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
