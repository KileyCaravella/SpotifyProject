//
//  SAArtistViewController.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/8/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

protocol communicationControllerArtist {
    func backFromArtist()
}

class SAArtistViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var artistBackgroundImg: UIImageView!
    @IBOutlet weak var artistProfileImg: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var SAArtistObj = SAArtist()
    var albumArray = []
    var SAArtistSongsArray: [SAArtistSongs] = []
    var delegate: communicationControllerArtist? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.addTarget(self, action: #selector(goBackToSearchVC), forControlEvents: .TouchUpInside)
        
        artistNameLbl.text = SAArtistObj.name
        followersLbl.text = String(SAArtistObj.followers) + " followers"
        
        chooseProfileImage(SAArtistObj.images)
        createBlurOnBackground()
        getSongs(SAArtistObj.id)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SAArtistSongsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSongViewCell
        cell.setupCellWithArtistSongs(SAArtistSongsArray[indexPath.row])
        cell.sequenceLbl.text = String(indexPath.row + 1)
        if (!SAArtistSongsArray[indexPath.row].explicit) {
            cell.albumNameLbl.translatesAutoresizingMaskIntoConstraints = true
            cell.albumNameLbl.frame = CGRect(x: cell.explicitLbl.frame.origin.x,
                                             y: cell.albumNameLbl.frame.origin.y,
                                             width: cell.albumNameLbl.frame.width,
                                             height: cell.albumNameLbl.frame.height)
            cell.explicitLbl.hidden = true
            cell.bulletForExplicitLbl.hidden = true
        }

        return cell
    }
    
    func goBackToSearchVC() {
        delegate?.backFromArtist()
    }
    
    func createBlurOnBackground () {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        view.sendSubviewToBack(self.artistBackgroundImg)
    }
    
    func chooseProfileImage(imageArray: NSArray) {
        artistProfileImg.clipsToBounds = true
        if (imageArray.count == 0) {
            artistProfileImg.image = UIImage(named: "noPhotoAvailableImg.png")
        }

        for picture in SAArtistObj.images {
            if picture.valueForKey("height") as! NSInteger == picture.valueForKey("width") as! NSInteger {
                SARequestManager().getImg((picture.valueForKey("url") as! String), completion:{ data in
                    self.artistProfileImg.image =  UIImage(data: data)
                    self.artistBackgroundImg.image = UIImage(data: data)
                })
                break
            }
            else {
                artistProfileImg.image = UIImage(named: "noPhotoAvailableImg.png")
                artistBackgroundImg.layer.backgroundColor = UIColor.blackColor().CGColor
            }
        }
    }
    
    func getSongs(id: String) {
        SARequestManager().getTopSongsOfArtist(id,  completion: {songs in
            self.SAArtistSongsArray = songs as! [SAArtistSongs]
            self.tableView.reloadData()
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}


