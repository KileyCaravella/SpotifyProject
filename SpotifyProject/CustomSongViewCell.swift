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
    @IBOutlet weak var durationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}