//
//  LocationListTableViewController.swift
//  On-The-Map
//
//  Created by Vasanth Kodeboyina on 7/3/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit

class LocationListTableViewController: UITableViewController {

    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }


    // MARK: - Table View data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        let object = User.sharedInstance
        return object.userJsonDetailsArray.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationListCell", forIndexPath: indexPath)
        
        let userFirstName = User.sharedInstance.userJsonDetailsArray[indexPath.row].valueForKey("firstName") as? String
        let userlastName = User.sharedInstance.userJsonDetailsArray[indexPath.row].valueForKey("lastName") as? String
        cell.textLabel?.text = "\(userFirstName!) \(userlastName!)"
        cell.imageView?.image = UIImage(named: "pin map icon")
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let userUrl = User.sharedInstance.userJsonDetailsArray[indexPath.row].valueForKey("mediaURL") as? String
        if let url = NSURL(string: userUrl!)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
 
    // MARK: - Pin Button Pressed Actions
    
    @IBAction func pinBarButtonIsPressed(sender: AnyObject)
    {
        performSegueWithIdentifier("TableViewToInfoViewSegueID", sender: nil)
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject)
    {
        let getUserLoc = UserLocationManager()
        getUserLoc.getUserLocations {
            self.tableView.reloadData()
        }
        // refresh button is pressed
    }
    
    
    // MARK: - Pin Button Pressed Actions

    @IBAction func LogoutButtonPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
