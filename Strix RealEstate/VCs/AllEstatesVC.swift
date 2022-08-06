//
//  AllEstatesVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 6/4/22.
//

import UIKit

class AllEstatesVC: UIViewController {
    var AllEstate : [EstateObjects] = []
    var EmptyLable = ""
    @IBOutlet weak var AllEstatesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        if lang == 1{
            EmptyLable = "Empty List"
        } else if lang == 2{
            EmptyLable = "قائمة فارغة"
        }else{
            EmptyLable = "لیستا بەتالە"
        }
        
        AllEstatesCollectionView.register(UINib(nibName: "AllEstatesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        if AllEstate.count == 0{
            self.showToast(controller: self, message : self.EmptyLable, seconds: 2.0)
        }
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    

}
extension AllEstatesVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.AllEstate.count == 0{
            return 0
        }
        return self.AllEstate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AllEstatesCollectionViewCell
        cell.Delete.isHidden = true
        cell.update(self.AllEstate[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 20.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.AllEstate.count != 0 && indexPath.row <= self.AllEstate.count{
        self.performSegue(withIdentifier: "Next", sender: self.AllEstate[indexPath.row])
        }
    }


override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let estate = sender as? EstateObjects{
        if let next = segue.destination as? EstateProfileVC{
            next.EstateProfileInfo = estate
        }
    }
}
    
}
