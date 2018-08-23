//
//  MHNCell.swift
//  MHNDataBase
//
//  Created by mac on 22/08/18.
//  Copyright © 2018 mhn. All rights reserved.
//

import UIKit
import CoreData


class MHNCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCrose: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
