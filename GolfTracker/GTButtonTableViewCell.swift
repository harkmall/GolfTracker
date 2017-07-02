//
//  GTButtonTableViewCell.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-04-23.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit

class GTButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
