//
//  CustomMainSectionTableViewCell.swift
//  TTOLC
//
//  Created by Dowon on 8/23/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit

class CustomMainSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionImage: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
