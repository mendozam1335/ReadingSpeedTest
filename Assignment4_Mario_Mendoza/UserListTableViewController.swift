//
//  UserListTableViewController.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/26/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import UIKit

/**Simple table view class that displays fullName of user onto a table view
 if no users made when opening up this table view, then simply does not display anything */
class UserListTableViewController: UITableViewController {

    var users: UserDB!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        let identifier = "userCell"
        

        if users.count() != 0{
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            let u = users.userAtIndex(indexPath.row)
            cell?.textLabel?.text = u.fullName()
        }
        // Configure the cell...

        return cell!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
