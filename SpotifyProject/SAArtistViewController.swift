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
    
    var artistInfo = Artist()
    var albumArray = []
    var songArray: [ArtistSongs] = []
    var delegate: communicationControllerArtist? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.addTarget(self, action: #selector(goBackToSearchVC), forControlEvents: .TouchUpInside)
        
        self.artistNameLbl.text = artistInfo.name
        self.followersLbl.text = String(artistInfo.followers) + " followers"
        
        chooseProfileImage(artistInfo.images)
        createBlurOnBackground()
        getSongs(artistInfo.id)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSongViewCell
        cell.songNameLbl.text = self.songArray[indexPath.row].name
        cell.sequenceLbl.text = String(indexPath.row + 1)
        cell.albumNameLbl.text = self.songArray[indexPath.row].albumName
        cell.durationLbl.text = calculateSongDuration(self.songArray[indexPath.row].durationMs)
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func calculateSongDuration(ms: Int) -> String {
        let valueInSeconds = ms/1000
        var minutes = 00
        var seconds = 00
        
        let hours = Int(valueInSeconds/60/60)
        minutes = Int((valueInSeconds/60/60 - hours) * 60)
        seconds = Int((valueInSeconds/60 - minutes) * 60)
        
        return String(hours) + ":" + String(minutes) + ":" + String(seconds)
    }
    
    func goBackToSearchVC() {
        self.delegate?.backFromArtist()
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
        self.artistProfileImg.clipsToBounds = true
        if (imageArray.count == 0) {
            self.artistProfileImg.image = UIImage(named: "noPhotoAvailableImg.png")
        }

        for picture in artistInfo.images {
            if picture.valueForKey("height") as! NSInteger == picture.valueForKey("width") as! NSInteger {
                SARequestManager().getImg((picture.valueForKey("url") as! String), completion:{ data in
                    self.artistProfileImg.image =  UIImage(data: data)
                    self.artistBackgroundImg.image = UIImage(data: data)
                })
                break
            }
            else {
                self.artistProfileImg.image = UIImage(named: "noPhotoAvailableImg.png")
                self.artistBackgroundImg.layer.backgroundColor = UIColor.blackColor().CGColor
            }
        }
    }
    
    func getSongs(id: String) {
        SARequestManager().getTopSongsOfArtist(id,  completion: {songs in
            self.songArray = songs as! [ArtistSongs]
            self.tableView.reloadData()
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


