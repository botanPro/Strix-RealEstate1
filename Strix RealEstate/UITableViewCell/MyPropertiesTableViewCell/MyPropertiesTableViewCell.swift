//
//  MyPropertiesTableViewCell.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/3/22.
//

import UIKit

class MyPropertiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var PendingView: UIVisualEffectView!
    
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var StackView: UIStackView!
    @IBOutlet weak var Delete: UIButton!
    @IBOutlet weak var Edit: UIButton!
    @IBOutlet weak var ProjectName: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            self.Name.textAlignment = .right
            self.Location.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update(_ cell: EstateObjects){
        let imagrUrl = cell.image;
        let url = URL(string: imagrUrl)
        self.Imagee.sd_setImage(with: url, completed: nil)
        self.Name.text = cell.project_title
        self.Location.text = cell.zone_name
        self.Price.text = cell.price.description.currencyFormatting()
    }

}
