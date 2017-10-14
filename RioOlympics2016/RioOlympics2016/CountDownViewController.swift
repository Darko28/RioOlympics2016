//
//  CountDownViewController.swift
//  RioOlympics2016
//
//  Created by Darko on 2017/10/14.
//  Copyright © 2017年 Darko. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {

    @IBOutlet weak var lblCountDown: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // create NSDateComponents object
        let comps = NSDateComponents()
        // set NSDateComponents date
        comps.day = 5
        // set NSDateComponents month
        comps.month = 8
        comps.year = 2016
        
        // create calendar object
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        
        // obtain 2016-8-5's NSDate object
        let destinationDate = calendar!.date(from: comps as DateComponents)
        let date: NSDate = NSDate()
        
        // obtain the NSDate object from current date to 2016-8-5
        let components = calendar!.components(NSCalendar.Unit.day, from: date as Date, to: destinationDate!, options: NSCalendar.Options.wrapComponents)
        
        // obtain the period days from current date to 2016-8-5
        let days = components.day
        
        let strLabel = NSMutableAttributedString(string: String(format: "%i days", days!))
        
        strLabel.addAttribute(NSAttributedStringKey.font, value: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote), range: NSMakeRange(strLabel.length - 1, 1))
        
        self.lblCountDown.attributedText = strLabel
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
