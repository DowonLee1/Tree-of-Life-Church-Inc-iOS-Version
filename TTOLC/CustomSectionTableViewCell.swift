//
//  CustomSectionTableViewCell.swift
//  TTOLC
//
//  Created by Dowon on 5/21/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit

class CustomSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var sectionLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
