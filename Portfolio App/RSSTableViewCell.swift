//
//  RSSTableViewCell.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 19/12/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {

    @IBOutlet var rssCellTitle: UILabel!
    @IBOutlet var rssCellSubTitle: UILabel!
    @IBOutlet var rssCellFirstLetter: UILabel!
    @IBOutlet var rssCellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
