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
    var albumArray: NSArray = []
    var delegate: communicationControllerArtist? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.addTarget(self, action: #selector(goBackToSearchVC), forControlEvents: .TouchUpInside)
        self.artistName.text = String(artistDictionary.valueForKey("name")!)
        
        chooseProfileImage(self.artistDictionary.valueForKey("images") as! NSArray)
        createBlurOnBackground()
        getJSONData(self.artistDictionary.valueForKey("id") as! String)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomAlbumViewCell
        cell.albumName.text = String(self.albumArray[indexPath.row].valueForKey("name")!)
        cell.typeOfAlbum.text = String(self.albumArray[indexPath.row].valueForKey("album_type")!)
        
        let albumImageArray = self.albumArray[indexPath.row].valueForKey("images") as! NSArray
        let image: UIImage = chooseAlbumImage(albumImageArray)
        cell.albumImg.image = image
        
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
        if (imageArray.count == 0) {
            self.artistProfileImg.image = UIImage(named: "noPhotoAvailableImg.png")
        }

        for picture in imageArray {
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
    
    func chooseAlbumImage(imageArray: NSArray) -> UIImage {
        var image: UIImage = UIImage(named: "noPhotoAvailableImg.png")!
        
        if (imageArray.count != 0) {
            SARequestManager().getImg((imageArray[0].valueForKey("url") as! String), completion: { data in
                 image = UIImage(data: data)!
            })
        }
        return image
    }
    
    func getJSONData(id: String) {
        SARequestManager().getAlbumOfArtist(id,  completion: {albums in
            self.albumArray = albums
        })
        self.tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


