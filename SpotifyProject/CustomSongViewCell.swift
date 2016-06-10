//
//  CustomSongCell.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/9/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

class CustomAlbumViewCell: UITableViewCell {
    

    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var typeOfAlbum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}