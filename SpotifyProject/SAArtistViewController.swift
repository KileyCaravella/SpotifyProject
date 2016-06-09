//
//  SAArtistViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/8/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit


class SAArtistViewController : UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var artistName: UILabel!
    var artistDictionary: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.addTarget(self, action: #selector(backBtnPressed), forControlEvents: .TouchUpInside)
        
        guard let name = self.artistDictionary.valueForKey("name") as? String else {print("ERROR"); return}
        
        self.artistName.text = name
        
//        
//        let thisStringVallue = ("hello, " + (self.artistDictionary.valueForKey("name") as! String))
//        print(thisStringVallue)
        
        
        
    }
    
    
    func backBtnPressed (sender: UIButton!) {
        let SASearchDestination = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SASearchViewController") as! SASearchViewController
        self.presentViewController(SASearchDestination, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


