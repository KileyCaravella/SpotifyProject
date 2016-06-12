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
    var artistInfoArray: [Artist] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSearchController () {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return self.artistInfoArray.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSearchViewCell
        if searchController.active && searchController.searchBar.text != "" {
            cell.artistName.text! = artistInfoArray[indexPath.row].name
        }
        else {
        }
        
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchController.searchBar.endEditing(true)
        searchController.active = false
        
        let SAArtistDestination = self.storyboard?.instantiateViewControllerWithIdentifier("SAArtistViewController") as! SAArtistViewController
        
        let currentCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)! as! CustomSearchViewCell
        let textFromCell = currentCell.artistName.text!
        
        //Sending the artist's instance to SAArtistVC
        for artistValue in self.artistInfoArray {
            if artistValue.name == textFromCell {
                SAArtistDestination.artistInfo = artistValue
            }
        }
        
        SAArtistDestination.delegate = self
        self.presentViewController(SAArtistDestination, animated: true, completion: nil)
    }
    
    //When searching for artist name
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchController.searchBar.text != "" && searchController.active {
            SARequestManager().searchArtists(searchController.searchBar.text,  completion: {artistInfo in
                self.artistInfoArray = artistInfo as! [Artist]
                self.tableView.reloadData()
            })
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func backFromArtist() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


