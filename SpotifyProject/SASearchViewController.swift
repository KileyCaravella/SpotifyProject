//
//  SASearchViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/6/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

class SASearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet var tableView: UITableView!
    var artists: NSArray = []
    var artistDictionaries: NSArray = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
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
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.artistName.text! = artists[indexPath.row] as! String
        }
        else {
        }
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let popup : SAArtistViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SAArtistViewController") as! SAArtistViewController
        let navigationController = UINavigationController(rootViewController: popup)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    
        let SAArtistDestination = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SAArtistViewController") as! SAArtistViewController
        let currentCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)! as! CustomCell
        let textFromCell = currentCell.artistName.text!
            
        //Getting the artist's dictionary value to send to VC
        for case let dictionaryValue in self.artistDictionaries {
            if (dictionaryValue.valueForKey("name") as! String == textFromCell) {
                SAArtistDestination.artistDictionary = dictionaryValue as! NSDictionary
                break
            }
        }

        //need to stop the search controller in order to present the other view
        searchController.searchBar.endEditing(true)
        searchController.active = false
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    //When searching for artist name
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchController.searchBar.text != "" && searchController.active {
            SARequestManager().searchArtists(searchController.searchBar.text,  completion: {artistNames, artistWebServiceDictionaries in
                
                self.artists = artistNames
                self.tableView.reloadData()
                self.artistDictionaries = artistWebServiceDictionaries
            })
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


