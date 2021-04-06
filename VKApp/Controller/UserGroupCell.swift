//
//  UserGroupCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

class UserGroupCell: UITableViewCell {

    @IBOutlet weak var groupCellText: UILabel!
    @IBOutlet weak var groupDescriptionText: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
