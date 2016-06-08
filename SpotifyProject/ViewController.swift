//
//  ViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/6/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet var tableView: UITableView!
    var artists: NSArray = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.artists = WebServices().getSeveralArtists("a")
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return self.artists.count
        }
        else {
            return self.artists.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.artistName.text! = artists[indexPath.row] as! String
        }
        else {
            cell.artistName.text! = artists[indexPath.row] as! String
        }
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        print("This is happening")
        if searchController.searchBar.text != "" {
            self.artists = WebServices().getSeveralArtists(searchText)
            tableView.reloadData()
        }
    }
        
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        print(";", searchController.searchBar.text)
    }
}


