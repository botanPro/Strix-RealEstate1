//
//  MyPropertiesVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/3/22.
//

import UIKit
import CustomLoader
import Alamofire
import SwiftyJSON
import CRRefresh

class MyPropertiesVC: UIViewController {

    
    var EmptyLable = ""
    
    
    var Array : [EstateObjects] = []
    @IBOutlet weak var MyPropertiesTableViewView: UITableView!{didSet{self.GetUserId()}}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MyPropertiesTableViewView.delegate = self
        self.MyPropertiesTableViewView.dataSource = self
        MyPropertiesTableViewView.register(UINib(nibName: "MyPropertiesTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.MyPropertiesTableViewView.cr.addHeadRefresh {
            self.GetUserId()
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

    
    var UserId = ""
    
    func GetUserId(){
        self.Array.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.MyPropertiesTableViewView.cr.endHeaderRefresh()
        }
        if let UserId = UserDefaults.standard.string(forKey: "UserId"){
            print(UserId)
            EstateApi.GetEstateByUserId(Id: UserId) { Info in
                if Info.count == 0{
                    self.showToast(controller: self, message : self.EmptyLable, seconds: 1.5)
                }else{
                    self.Array = Info
                    self.MyPropertiesTableViewView.cr.endHeaderRefresh()
                    self.MyPropertiesTableViewView.reloadData()
                }
            }
        }
    }
    
    
    
    
    @objc func remove(sender: UIButton) {
        let myAlert = UIAlertController(title:"Delete", message: "Are you sure you wan to Delete?", preferredStyle: UIAlertController.Style.alert)
        myAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            if UserDefaults.standard.bool(forKey: "Login") == true{
                UserObjectsAPI.GetUserInfo(FirebaseId: UserDefaults.standard.string(forKey: "FireId") ?? "") { UserInfo in
                    _ = LoadingView.standardProgressBox.show(inView: self.view)
                let stringUrl = URL(string: API.URL);
                let param: [String: Any] = [
                    "key":API.key,
                    "username":API.UserName,
                    "fun" : "delete_estate_by_id",
                    "id" : sender.accessibilityIdentifier!
                ]
                AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                    switch response.result
                    {
                    case .success(_):
                        let jsonData = JSON(response.data ?? "")
                         print(jsonData)
                        self.GetUserId()
                        self.view.removeLoadingViews(animated: true)
                    case .failure(let error):
                        print(error);
                    }
                }
                    
            }
        }
        }))
        myAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    @objc func GoToEdit(sender: UIButton) {
        for estate in self.Array{
            if sender.accessibilityIdentifier! == estate.id{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "AddPropertiesVC") as! AddPropertiesVC
                myVC.ComingEstate = estate
                myVC.IsUpdate = true
                self.navigationController?.pushViewController(myVC, animated: true)
            }
        }
    }
    
    

    
}





extension MyPropertiesVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Array.count == 0{
            self.GetUserId()
         return 0
        }
        return self.Array.count
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyPropertiesTableViewCell
        cell.update(self.Array[indexPath.row])
        cell.Delete.accessibilityIdentifier = self.Array[indexPath.row].id
        cell.Edit.accessibilityIdentifier = self.Array[indexPath.row].id
        cell.Delete.addTarget(self, action: #selector(self.remove(sender:)), for:.touchUpInside)
        cell.Edit.addTarget(self, action: #selector(self.GoToEdit(sender:)), for:.touchUpInside)
        print("[]][][][]]]=====-------")
        print(self.Array[indexPath.row].active)
        if self.Array[indexPath.row].active == "1"{
            cell.PendingView.isHidden = true
        }else{
            cell.PendingView.isHidden = false
        }
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
