//
//  ScheduleViewController.swift
//  RioOlympics2016
//
//  Created by Darko on 2017/10/14.
//  Copyright © 2017年 Darko. All rights reserved.
//

import UIKit
import PersistenceLayer
import BusinessLogicLayer

class ScheduleViewController: UITableViewController {
    
    // data used in tableView, save the data returned from the database
    var data: NSDictionary!
    // game data list
    var arrayGameDateList: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if self.data == nil || self.data.count == 0 {
            let bl = ScheduleBL()
            self.data = bl.readData()
            
            let keys = self.data.allKeys as NSArray
            // sort the keys
            self.arrayGameDateList = keys.sortedArray(using: "compare:") as NSArray
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let keys = self.data.allKeys as NSArray
        return keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // game date
        let strGameDate = self.arrayGameDateList[section] as! String
        // game schedule under the game date
        let schedules = self.data[strGameDate] as! NSArray
        
        return schedules.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // game date
        let strGameDate = self.arrayGameDateList[section] as! String
        return strGameDate
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // game date
        let strGameDate = self.arrayGameDateList[indexPath.section] as! String
        // game schedule under the game date
        let schedules = self.data[strGameDate] as! NSArray
        let schedule = schedules[indexPath.row] as! Schedule
        
        let subtitle = String(format: "%@ | %@", schedule.gameInfo!, schedule.event!.eventName!)
        
        cell.textLabel?.text = schedule.gameTime as String?
        cell.detailTextLabel?.text = subtitle

        // Configure the cell...

        return cell
    }

    // add index for the table
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var listTitles = [String]()
        // 2016-08-09 -> 08-09
        for item in self.arrayGameDateList {
            let title = (item as! NSString).substring(from: 5)
            listTitles.append(title)
        }
        return listTitles
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
