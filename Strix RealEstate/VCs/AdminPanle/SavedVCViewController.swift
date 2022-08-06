//
//  SavedVCViewController.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/3/22.
//

import UIKit
import CustomLoader
import CRRefresh
import AlertToast
class SavedVCViewController: UIViewController {
    var Array : [EstateObjects] = []
    var EmptyLable = ""
    
    @IBOutlet weak var SavedTableViewView: UITableView!{didSet{GetEstates()}}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SavedTableViewView.delegate = self
        self.SavedTableViewView.dataSource = self
        SavedTableViewView.register(UINib(nibName: "MyPropertiesTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        SavedTableViewView.cr.addHeadRefresh {
            self.GetEstates()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetEstates()
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
    
    func GetEstates(){
        self.Array.removeAll()
        if UserDefaults.standard.bool(forKey: "Login") == true{
            UserObjectsAPI.GetUserInfo(FirebaseId: UserDefaults.standard.string(forKey: "FireId") ?? "") { UserInfo in
                EstateApi.GetSaved(Id: UserInfo.id) { estates in
                    if estates.count == 0{
                        self.showToast(controller: self, message : self.EmptyLable, seconds: 2.0)
                    }else{
                        self.Array = estates
                        self.SavedTableViewView.reloadData()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.SavedTableViewView.cr.endHeaderRefresh()
                }
            }
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    @objc func remove(sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "Login") == true{
            UserObjectsAPI.GetUserInfo(FirebaseId: UserDefaults.standard.string(forKey: "FireId") ?? "") { UserInfo in
                    _ = LoadingView.standardProgressBox.show(inView: self.view)
                UserObjectsAPI.SaveUnSave(add_dell: "0", saved_pro_id: sender.accessibilityIdentifier!, id: UserInfo.id) { Info in
                        self.GetEstates()
                        self.SavedTableViewView.reloadData()
                        self.view.removeLoadingViews(animated: true)
                    }
            }
        }
        
    }
    
}




extension SavedVCViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Array.count == 0{
            return 0
        }
        return self.Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyPropertiesTableViewCell
        cell.Edit.isHidden = true
        cell.PendingView.isHidden = true
        cell.update(self.Array[indexPath.row])
        cell.Delete.accessibilityIdentifier = self.Array[indexPath.row].id
        cell.Delete.addTarget(self, action: #selector(self.remove(sender:)), for:.touchUpInside)
        cell.Delete.setTitle("Remove From Saved")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
