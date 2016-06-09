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
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    var artistDictionary: NSDictionary = [:]
    var delegate: communicationControllerArtist? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.addTarget(self, action: #selector(goBackToSearchVC), forControlEvents: .TouchUpInside)
        self.artistName.text = String(artistDictionary.valueForKey("name")!)
        chooseProfileImage(self.artistDictionary.valueForKey("images") as! NSArray)
        createBlurOnBackground()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("HAI!")
        let cell = self.tableView.dequeueReusableCellWithIdentifier("customSongCell", forIndexPath: indexPath) as! CustomSongCell
        
        cell.albumName.text! = "albumName"
        cell.songName.text! = "songName"
        cell.orderForTopTracks.text! = String(indexPath.row)
        
        return cell
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
        print(imageArray)
        if (imageArray.count == 0) {
            self.artistProfileImg.image = UIImage(named: "noPhotoAvailableImg.png")
        }
        //Do not need else becuase if count == 0 it will skip this loop
        for picture in imageArray {
            if picture.valueForKey("height") as! NSInteger == picture.valueForKey("width") as! NSInteger {
                SARequestManager().getArtistImg((picture.valueForKey("url") as! String), completion:{ data in
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


