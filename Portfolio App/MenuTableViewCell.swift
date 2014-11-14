//
//  MenuTableViewCell.swift
//  Portfolio App
//
//  Created by Hooman Mardokhi on 15/11/2014.
//  Copyright (c) 2014 Hooman Mardokhi. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {



    @IBOutlet weak var menuCellImage: UIImageView!
    @IBOutlet weak var menuCellTitle: UILabel!
    @IBOutlet weak var menuCellSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
