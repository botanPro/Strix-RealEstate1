//
//  EstateSheetViewVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/7/22.
//

import UIKit

class EstateSheetViewVC: UIViewController {
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Dismisss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var SheetView: UIView!
    @IBOutlet weak var BackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        SheetView.clipsToBounds = false
        SheetView.layer.shadowColor = UIColor.black.cgColor
        SheetView.layer.shadowOpacity = 1
        SheetView.layer.shadowOffset = CGSize(width: 0, height: -4.0)
        SheetView.layer.shadowRadius = 8
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
