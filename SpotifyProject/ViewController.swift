//
//  ViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/6/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    static var artists = []
    
    //**This will be pulled from the API**//
    func pullFromWebService {
        let artists = [WebServices.getSeveralArtists()]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        cell.artistName.text = artists[indexPath.row] as? String
        
        return cell
    }


}

