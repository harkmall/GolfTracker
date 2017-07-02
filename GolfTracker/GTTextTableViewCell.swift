//
//  GTTextTableViewCell.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-04-23.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit

class GTTextTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    var onChangeClosure: ((Void)->(Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inputField.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func inputChanged() {
        if let closure = onChangeClosure {
            closure()
        }
    }

}
