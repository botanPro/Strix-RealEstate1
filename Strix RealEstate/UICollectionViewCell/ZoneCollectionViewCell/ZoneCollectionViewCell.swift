//
//  EstateTypeCollectionViewCell.swift
//  RealEstates
//
//  Created by botan pro on 5/2/21.
//

import UIKit

class ZoneCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var Vieww: UIView!
    
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.Vieww.layer.cornerRadius = 8
    }

}
