//
//  EventsViewController.swift
//  RioOlympics2016
//
//  Created by Darko on 2017/10/14.
//  Copyright © 2017年 Darko. All rights reserved.
//

import UIKit
import PersistenceLayer
import BusinessLogicLayer

//private let reuseIdentifier = "Cell"

class EventsViewController: UICollectionViewController {
    
    // column number in one row
    // column number = 2 if it is iPhone device
    var COL_COUNT = 2
    
    var events: NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            // column number = 5 if it is iPad device
            COL_COUNT = 5
        }
        
        if (self.events == nil || self.events.count == 0) {
            let bl = EventsBL()
            // acquire all data
            let array = bl.readData()
            self.events = array
            self.collectionView?.reloadData()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.events.count / COL_COUNT
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return COL_COUNT
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EventsViewCell
        let index = indexPath.section * COL_COUNT + indexPath.row
        
        let event = self.events.object(at: index) as! Events
        cell.imageView.image = UIImage(named: event.eventIcon! as String)
    
        // Configure the cell
    
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let indexPaths = self.collectionView?.indexPathsForSelectedItems
            let indexPath = indexPaths![0]
            
            let event = self.events[indexPath.section * COL_COUNT + indexPath.row] as! Events
            
            let detailVC = segue.destination as! EventsDetailViewController
            detailVC.event = event
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
