//
//  SASearchViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/6/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

class SASearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, communicationControllerArtist {

    @IBOutlet var tableView: UITableView!
    var artistDictionaries: NSArray = []
    var artistInfo: [Artist] = []
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
            return self.artistInfo.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSearchViewCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.artistName.text! = artistInfo[indexPath.row].name
        }
        else {
        }
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let SAArtistDestination : SAArtistViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SAArtistViewController") as! SAArtistViewController
        
        let currentCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)! as! CustomSearchViewCell
        let textFromCell = currentCell.artistName.text!
            
        //Getting the artist's dictionary value to send to VC
        for case let dictionaryValue in self.artistDictionaries {
            if dictionaryValue.valueForKey("name") as! String == textFromCell {
                SAArtistDestination.artistDictionary = dictionaryValue as! NSDictionary
                break
            }
        }

        //need to stop the search controller in order to present the other view
        searchController.searchBar.endEditing(true)
        searchController.active = false
        SAArtistDestination.delegate = self
        self.presentViewController(SAArtistDestination, animated: true, completion: nil)
    }
    
    func backFromArtist() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //When searching for artist name
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchController.searchBar.text != "" && searchController.active {
            SARequestManager().searchArtists(searchController.searchBar.text,  completion: {artistWebServiceDictionaries, artistInfo in
                self.tableView.reloadData()
                self.artistDictionaries = artistWebServiceDictionaries
                self.artistInfo = artistInfo as! [Artist]
                print(self.artistInfo[0])
            })
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


