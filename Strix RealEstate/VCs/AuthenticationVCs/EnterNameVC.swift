//
//  EnterNameVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 6/2/22.
//

import UIKit
import MHLoadingButton
class EnterNameVC: UIViewController {
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Save: LoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Name.becomeFirstResponder()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        if lang == 2{
            self.Name.textAlignment = .right
            self.Save.setTitle("الحفظ")
        }else if lang == 3{
            self.Name.textAlignment = .right
            self.Save.setTitle("پاراستن")
        }
    }
    @IBAction func Save(_ sender: Any) {
        if self.Name.text! != ""{
            if self.Name.text!.trimmingCharacters(in: .whitespaces).isEmpty == false{
                guard let FireId = UserDefaults.standard.string(forKey: "FireId") else {return}
                guard let Phone = UserDefaults.standard.string(forKey: "PhoneNumber") else {return}
                UserObjectsAPI.SetUserInfo(full_name: self.Name.text!, address: "", phone1: Phone, phone2: "", about_me: "", img: "", fire_id: FireId, id: "") { Info in
                    UserObjectsAPI.GetUserInfo(FirebaseId: FireId) { UserInfo in
                        UserDefaults.standard.set(UserInfo.id, forKey: "UserId")
                    }
                    UserDefaults.standard.set(true, forKey: "Login")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVc")
                    vc!.modalPresentationStyle = .overFullScreen
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true)
                }
            }
            else {
                let alertController = UIAlertController(title: "", message: "Please write your currect name", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { UIAlertAction in }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
           
        }else{
            let alertController = UIAlertController(title: "", message: "Please enter your name", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { UIAlertAction in }
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}



//extension EnterNameVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        do {
//            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: [])
//            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
//                return false
//            }
//        }
//        catch {
//            print("ERROR")
//        }
//        return true
//    }
//}
