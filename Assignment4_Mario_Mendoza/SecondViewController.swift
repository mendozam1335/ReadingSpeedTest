//
//  SecondViewController.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/24/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import UIKit
/**Table view controller with 2 different tables.
 One shows the current user and their top 3 scores if does not have 3 entries, then will simply display as many attempts as they have up till 3
 The second view controller displays all users and their top scores */
class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: UserDB!
    
    @IBOutlet weak var CurrentUser: UITableView!
    @IBOutlet weak var AllUser: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.CurrentUser.reloadData()
        self.AllUser.reloadData()
        
    }
    /**First table view will have only one section always for the current user
     Second table view will have one section for each user to allow for a tittle for their name*/
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 1
        if tableView == self.CurrentUser{
            count = 1
        }
        if tableView == self.AllUser{
            count = user.count()
            //print("User Count: \(count)")
        }
        return count
    }
    /**First table will have anywhere from 0 to 3 rows to allow for users top three scores
     Will choose based on how many attempts user has made
     Second table will will one row alwasy for each section to allow for top score*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        var max: Int
        if user.count() != 0{
            max = min(user.getCurrentUser().count(), 3)
        }else{
            max = 0
        }
        if tableView == self.CurrentUser{
            count = max
            //print("current user rows: \(count)")
        }
        
        if tableView == self.AllUser {
            count = 1
        }
        
        return count
    }
    /** For first table, retreive current user and then retreive their top three scores
     place top three scores into each row
     For second table retrieve each row will get users top score only and place it into cell
     will also place users attempts of that score into table
     If no user created by this point, will simply be empty tables*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactId1 = "currentUser"
        let contactId2 = "allUser"
        var cell: UITableViewCell?
        let keys: [Double]
        var topScore : Double
        if user.count() != 0{
            if tableView == self.CurrentUser{
                cell = tableView.dequeueReusableCell(withIdentifier: contactId1, for:   indexPath)
                let u = user.getCurrentUser()
                if u.count() != 0{
                    keys = u.getTopThree()
                    cell!.textLabel!.text = String(keys[indexPath.row])
                    cell!.detailTextLabel!.text = String(u.attempts[keys[indexPath.row]]!)
                }
            }
            
            if tableView == self.AllUser{

                cell = tableView.dequeueReusableCell(withIdentifier: contactId2, for: indexPath)
                let u = user.sortedUserAtIndex(indexPath.section)
                if u.count() != 0{
                    topScore = u.getTopScore()
                    cell!.textLabel!.text = String(topScore)
                    cell!.detailTextLabel!.text = String(u.attempts[topScore]!)
                }
            }
        }
        
        return cell!
    }
    /** Will place users full name as title to show whose score belongs to*/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if user.count() != 0{
            if tableView == self.CurrentUser{
                return user.getCurrentUser().fullName()
            }
            if tableView == self.AllUser{
                return user.sortedUserAtIndex(section).fullName()
            }
        }
        return ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.CurrentUser.dataSource = self
        self.CurrentUser.delegate = self
        
        self.AllUser.dataSource = self
        self.AllUser.delegate = self
        let navContr = self.tabBarController?.viewControllers![0] as! UINavigationController
        user = (navContr.topViewController as! FirstViewController).users
    }


}

