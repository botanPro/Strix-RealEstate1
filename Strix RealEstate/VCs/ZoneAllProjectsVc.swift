//
//  ZoneAllProjectsVc.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/3/22.
//

import UIKit
import CRRefresh
class ZoneAllProjectsVc: UIViewController {

    
    var EmptyLable = ""
    
    
    var ZoneId = ""
    var ProjectId = ""
    var Array : [EstateObjects] = []
    @IBOutlet weak var AllEstatesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AllEstatesCollectionView.register(UINib(nibName: "AllEstatesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.GetEstates(id : self.ZoneId)
        if self.ZoneId != ""{
            self.AllEstatesCollectionView.cr.addHeadRefresh {
                self.GetEstates(id : self.ZoneId)
            }
            
        }
        
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        if lang == 1{
            EmptyLable = "Empty List"
        } else if lang == 2{
            EmptyLable = "قائمة فارغة"
        }else{
            EmptyLable = "لیستا بەتالە"
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
    
    
    
    func GetEstates(id : String){
        self.Array.removeAll()
        ZoneAPI.GetEstateByZone(Id: id) { estates in
            
            if estates.count == 0{
                self.showToast(controller: self, message : self.EmptyLable, seconds: 2.0)
            }else{
                self.Array = estates
                self.AllEstatesCollectionView.cr.endHeaderRefresh()
                self.AllEstatesCollectionView.reloadData()
            }
            
        }
    }
    

}




extension ZoneAllProjectsVc : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if Array.count == 0 {
                return 0
            }
        
        return Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AllEstatesCollectionViewCell
        cell.Delete.isHidden = true
        cell.update(self.Array[indexPath.row])
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
        if self.Array.count != 0 && indexPath.row <= self.Array.count{
        self.performSegue(withIdentifier: "Next", sender: Array[indexPath.row])
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
       
