//
//  HomeProjectCollectionViewCell.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/23/22.
//

import UIKit

class HomeProjectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var OverView: UIView!
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var Zone: UILabel!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Imagee.layer.cornerRadius = 8
        self.OverView.layer.cornerRadius = 8
        // Initialization code
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            self.Name.textAlignment = .right
            self.Zone.textAlignment = .right
        }
    }
        func update(_ cell: ProjectObjects){
            let imagrUrl = "\(API.IMAGEURL)\(cell.project_img)";
            print(imagrUrl)
            let url = URL(string: imagrUrl) 
            self.Imagee.sd_setImage(with: url, completed: nil)
            self.Name.text = cell.title
            self.Zone.text = cell.zone_name
        }
}
