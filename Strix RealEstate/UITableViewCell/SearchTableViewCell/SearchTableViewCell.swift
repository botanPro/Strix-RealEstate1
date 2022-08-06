//
//  SearchTableViewCell.swift
//  WomanApp
//
//  Created by botan pro on 9/4/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var Check: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var Name: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
