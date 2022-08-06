//
//  AllProjectsTableViewCell.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/3/22.
//

import UIKit

class AllProjectsTableViewCell: UITableViewCell {
    @IBOutlet weak var OverView: UIView!
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var Zone: UILabel!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Imagee.layer.cornerRadius = 8
        self.OverView.layer.cornerRadius = 8
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            self.Name.textAlignment = .right
            self.Zone.textAlignment = .right
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
