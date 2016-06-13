//
//  CustomSongCell.swift
//  SpotifyProject
//
//  Created by Kiley  Caravella on 6/9/16.
//  Copyright © 2016 Kiley Caravella. All rights reserved.
//

import UIKit

class CustomSongViewCell: UITableViewCell {
    
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var sequenceLbl: UILabel!
    @IBOutlet weak var explicitLbl: UILabel!
    @IBOutlet weak var albumNameLbl: UILabel!
    @IBOutlet weak var bulletForExplicitLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCellWithArtistSongs (artistSongs:SAArtistSongs) {
        self.songNameLbl.text = artistSongs.name
        self.albumNameLbl.text = artistSongs.albumName
        self.durationLbl.text = calculateSongDuration(artistSongs.durationMs)
    }
    
    func calculateSongDuration(ms: Int) -> String {
        let valueInSeconds = ms/1000
        let hours = Int(valueInSeconds/3600)
        let minutes = Int(valueInSeconds / 60)
        let seconds = Int(valueInSeconds % 60)
        
        if hours != 0 {
            return String(format: "%02d", hours) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
        }
            
        else {
            return String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
        }
    }
    
}