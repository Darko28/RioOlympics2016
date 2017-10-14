//
//  EventsDetailViewController.swift
//  RioOlympics2016
//
//  Created by Darko on 2017/10/14.
//  Copyright © 2017年 Darko. All rights reserved.
//

import UIKit
import PersistenceLayer
import BusinessLogicLayer

class EventsDetailViewController: UIViewController {
    
    var event: Events!
    
    @IBOutlet weak var imgEventIcon: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var txtViewBasicsInfo: UITextView!
    @IBOutlet weak var txtViewKeyInfo: UITextView!
    @IBOutlet weak var txtViewOlympicInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imgEventIcon.image = UIImage(named: self.event.eventIcon as! String)
        self.lblEventName.text = self.event.eventName as! String
        self.txtViewBasicsInfo.text = self.event.basicsInfo as! String
        self.txtViewKeyInfo.text = self.event.keyInfo as! String
        self.txtViewOlympicInfo.text = self.event.olympicsInfo as! String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
