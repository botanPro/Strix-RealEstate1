//
//  ProfileVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import UIKit
import UIView_Shimmer
import SDWebImage
import SwiftyJSON
import Firebase
import Alamofire
import EFInternetIndicator


extension UILabel: ShimmeringViewProtocol { }
extension UISwitch: ShimmeringViewProtocol { }
extension UIProgressView: ShimmeringViewProtocol { }
extension UITextView: ShimmeringViewProtocol { }
extension UIStepper: ShimmeringViewProtocol { }
extension UISlider: ShimmeringViewProtocol { }


class ProfileVC: UITableViewController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var HomeTitle: UIBarButtonItem!
    @IBOutlet weak var MyImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserPhone: UILabel!
    @IBOutlet weak var ImageBackView: UIView!
    @IBOutlet weak var Language: UILabel!
    @IBOutlet weak var MyProfileData: UITableViewCell!
    @IBOutlet weak var AddProperties: UITableViewCell!
    @IBOutlet weak var MyProperties: UITableViewCell!
    @IBOutlet weak var Saved: UITableViewCell!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    
    
    
    @IBOutlet weak var profilerighticon: UIImageView!
    
    
    @IBOutlet weak var LoginLogoutImage: UIImageView!
    @IBOutlet weak var LogOutLogInLable: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        if lang == 1{
            self.Language.text = "English"
        }else if lang == 2{
            self.Language.text = "العربية"
        }else{
            self.Language.text = "کوردی"
        }
        
        if UserDefaults.standard.bool(forKey: "Login") == true{
        if lang == 1{
            self.LogOutLogInLable.text = "LogOut"
        } else if lang == 2{
            self.LogOutLogInLable.text = "تسجيل خروج"
        }else{
            self.LogOutLogInLable.text = "چوونە دەر"
        }
        }
        
        HomeTitle.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: "rudawregular", size: 24)!,
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1399560869, green: 0.2036496699, blue: 0.2750037014, alpha: 1)
            ], for: .normal)
        self.MyImage.layer.cornerRadius = self.MyImage.bounds.width / 2
        self.ImageBackView.layer.cornerRadius = self.ImageBackView.bounds.width / 2
        GetAboutUs()
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL)
        }
    }
    
    var CountactUs = ""
    var AboutObject : AboutUsObject?
    func GetAboutUs(){
        let stringUrl = URL(string: API.URL);
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_about",
            "lang" : lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                for (_,val) in jsonData{
                    self.AboutObject = AboutUsObject(about_us: val["about_us"].string ?? "", phone: val["phone"].string ?? "", instagram: val["instagram"].string ?? "", facebook: val["facebook"].string ?? "", twitter: val["twitter"].string ?? "", youtube: val["youtube"].string ?? "")
                    self.CountactUs = val["phone"].string ?? ""
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    var shimmeringAnimatedItems: [UIView] {
           [
            ImageBackView,
            UserPhone,
            UserName,
           ]
       }
    

    
    @objc func IfNotLogined(){
        self.MyProfileData.setTemplateWithSubviews(true, animate: true, viewBackgroundColor: #colorLiteral(red: 0.7080472112, green: 0.793538034, blue: 0.8778640628, alpha: 1))
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        if lang == 1{
            self.LogOutLogInLable.text = "LogIn"
        } else if lang == 2{
            self.LogOutLogInLable.text = "تسجيل الدخول"
        }else{
            self.LogOutLogInLable.text = "چونه‌ ژوور"
        }
       
        self.MyImage.image = UIImage()
        self.LoginLogoutImage.image = UIImage(named: "vuesax-linear-login")
        self.MyProfileData.contentView.alpha = 0.5
        self.MyProfileData.isUserInteractionEnabled = false
        self.AddProperties.contentView.alpha = 0.5
        self.AddProperties.isUserInteractionEnabled = false
        self.MyProperties.contentView.alpha = 0.5
        self.MyProperties.isUserInteractionEnabled = false
        self.Saved.contentView.alpha = 0.5
        self.Saved.isUserInteractionEnabled = false
        self.MyProfileData.reloadInputViews()
    }
    
    var option = "1"
    var UserId = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startMonitoringInternet()
        self.profilerighticon.isHidden = true
        if CheckInternet.Connection() == false{
            self.MyProfileData.setTemplateWithSubviews(true, animate: true, viewBackgroundColor: #colorLiteral(red: 0.7080472112, green: 0.793538034, blue: 0.8778640628, alpha: 1))
        }else{
            self.MyProfileData.setTemplateWithSubviews(false)
            self.MyProfileData.reloadInputViews()
        }
        if UserDefaults.standard.bool(forKey: "Login") == false {
            IfNotLogined()
        }else{
            if let FireId = UserDefaults.standard.string(forKey: "FireId"){
                UserObjectsAPI.GetUserInfo(FirebaseId: FireId) { UserInfo in
                    self.UserId = UserInfo.id
                    self.UserName.text = UserInfo.full_name
                    self.UserPhone.text = UserInfo.phone1
                    self.option = UserInfo.option
                    
                    if self.option == "0"{
                        self.profilerighticon.isHidden = false
                    }
                }
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.option == "0"{
        if indexPath.section == 0 && indexPath.row == 0{
               self.performSegue(withIdentifier: "GoToReg", sender: nil)
            }
        }
        
        
        if indexPath.section == 2 && indexPath.row == 2{
            if UserDefaults.standard.bool(forKey: "Login") == true{
                if XLanguage.get() == .Arabic{
                    let myAlert = UIAlertController(title: "تسجيل الخروج.", message: "هل أنت متأكد؟", preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (UIAlertAction) in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            UserDefaults.standard.set(false, forKey: "Login")
                            UserDefaults.standard.set("", forKey: "UserId")
                            UserDefaults.standard.set("", forKey: "FireId")
                            self.IfNotLogined()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }))
                    myAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }else if XLanguage.get() == .Kurdish{
                    let myAlert = UIAlertController(title: "دەرچوون.", message: "تو یێ پشت راستی تە دڤێت دەرکەڤی؟ ", preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "بەڵێ", style: .default, handler: { (UIAlertAction) in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            UserDefaults.standard.set(false, forKey: "Login")
                            UserDefaults.standard.set("", forKey: "FireId")
                            UserDefaults.standard.set("", forKey: "PhoneNumber")
                            self.IfNotLogined()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }))
                    myAlert.addAction(UIAlertAction(title: "نەخێر", style: .cancel, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }else{
                    let myAlert = UIAlertController(title:"LogOut", message: "Are you sure you wan to logout?", preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            UserDefaults.standard.set(false, forKey: "Login")
                            UserDefaults.standard.set("", forKey: "UserId")
                            UserDefaults.standard.set("", forKey: "FireId")
                            self.IfNotLogined()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }))
                    myAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }
        if indexPath.section == 2 && indexPath.row == 0{
            print(self.AboutObject?.youtube ?? "hello")
            self.performSegue(withIdentifier: "Next", sender: self.AboutObject)
        }
        print("[][]]][]-----========")
        print(indexPath.section)
        print(indexPath.row)
        if indexPath.section == 2 && indexPath.row == 1{
                self.makePhoneCall(phoneNumber: self.CountactUs)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let info = sender as? AboutUsObject{
            if let next = segue.destination as? AboutUsVc{
                next.AboutObject = info
            }
        }
    }
}




class AboutUsObject{
    var about_us = ""
    var phone = ""
    var instagram = ""
    var facebook = ""
    var twitter = ""
    var youtube = ""
    
    init(about_us : String,phone : String,instagram : String,facebook : String,twitter : String,youtube : String) {
        self.phone = phone
        self.about_us = about_us
        self.facebook = facebook
        self.twitter = twitter
        self.instagram = instagram
        self.youtube = youtube
    }
}
