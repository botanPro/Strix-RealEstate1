//
//  MyProfileVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/2/22.
//

import UIKit
import BSImagePicker
import Photos
import CustomLoader
import SDWebImage
import Alamofire
import SwiftyJSON
import Firebase
class MyProfileVC: UIViewController {

    @IBOutlet weak var AboutMe: UITextView!
    @IBOutlet weak var Phone2: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var Namte: UITextField!
    @IBOutlet weak var Phone1: UITextField!
//    @IBOutlet weak var Image: UIImageView!
//    @IBOutlet weak var EditImage: UIButton!
    
    var UserId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let phone1 = UserDefaults.standard.string(forKey: "PhoneNumber") else{return}
        self.Phone1.text = phone1
        self.Phone1.isUserInteractionEnabled = false
        
        
        
        
        if UserDefaults.standard.bool(forKey: "Login") == true{
            UserObjectsAPI.GetUserInfo(FirebaseId: UserDefaults.standard.string(forKey: "FireId") ?? "") { UserInfo in
                self.UserId = UserInfo.id
                self.Namte.text = UserInfo.full_name
                self.Phone2.text = UserInfo.phone2
                self.Address.text = UserInfo.address
            }
        }
    }
    
    
    var SelectedAssets = [PHAsset]()
    var Images : [UIImage] = []
    var ImageUrl : [String] = []

    
    @IBOutlet weak var DeleteAccountView: UIView!
    
    
    
    @IBAction func DeleteMyAccount(_ sender: Any) {
        let myAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account", preferredStyle: UIAlertController.Style.alert)
        myAlert.addAction(UIAlertAction(title: "Sure", style: .default, handler: { (UIAlertActionn) in
            
            
            
            
            
            
            let myAlertin = UIAlertController(title: "Note", message: "After deleting your account, your Estates and Informaiton will not be shown in application, Note that you can not active your account after deleting.", preferredStyle: UIAlertController.Style.alert)
            myAlertin.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertActiokn) in

                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    UserDefaults.standard.set(false, forKey: "Login")
                    UserDefaults.standard.set("", forKey: "UserId")
                    UserDefaults.standard.set("", forKey: "FireId")
                    
                    let stringUrl = URL(string: API.URL);
                    let param: [String: Any] = [
                        "key":API.key,
                        "username":API.UserName,
                        "fun":"delete_profile",
                        "id": self.UserId
                    ]
                    
                    AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
                        switch respons.result{
                        case .success:
                            let jsonData = JSON(respons.data ?? "")
                            print(jsonData["insert"].string ?? "")
                            if jsonData["insert"].string ?? "" == "true"{
                                let myAlertin = UIAlertController(title: "", message: "Your account is deleted successfuly", preferredStyle: UIAlertController.Style.alert)
                                myAlertin.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(myAlertin, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            print(error);
                        }
                    }
                    
                    
                    
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                
            }))
            myAlertin.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
            self.present(myAlertin, animated: true, completion: nil)
            
            
            
            
            
        }))
        myAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    
//    func getAllImages() -> Void {
//        if SelectedAssets.count != 0{
//            for i in 0..<SelectedAssets.count{
//                let manager = PHImageManager.default()
//                let option = PHImageRequestOptions()
//                var thumbnail = UIImage()
//                option.isSynchronous = true
//                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
//                    thumbnail = result!
//                })
//                self.Image.image = thumbnail
//                self.Images.append(thumbnail)
//            }
//        }
//    }
    
    
    
    
//        func uploadManyImage(complition : @escaping (_ URLs: [String])->()){
//            var uploadedImages : [String] = []
//            for one in self.Images{
//                one.upload { (url) in
//                    uploadedImages.append(url)
//                    if self.Images.count == uploadedImages.count{
//                        complition(uploadedImages)
//                    }
//                }
//            }
//        }
//
//
//
//
    
    
    var Messagee = ""
    var Actionn = ""
    var Title = ""
    var message = ""
    var action = ""
    var cancel = ""
    func Insert(_ insert : String){
        if insert == "true"{
            if XLanguage.get() == .English{
                self.Actionn = "Ok"
                self.Messagee = "Your experience is uploaded succsesfully، We will answer you within 24 hours, thank you for waiting."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn)
            }
            
            if XLanguage.get() == .Arabic{
                self.Actionn = "حسنا"
                self.Messagee = "تم رفع خبرتك الخاصة بك بنجاح، سنقوم بالرد عليك في غضون 24 ساعة، شكرا لك على الانتظار."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn)
            }
            
            if XLanguage.get() == .Kurdish{
                self.Actionn = "بەلێ"
                self.Messagee = "شارازاییا تە ب سەرکەفتیانە هاتنە بلند کرن، دێ بەرسڤا تە دەین د 24 دەمژمێران دا، سوپاس."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn)
            }
        }else{
            if XLanguage.get() == .English{
                self.Actionn = "Ok"
                self.Messagee = "Your experience is not uploaded, please try later."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn)
            }
            
            if XLanguage.get() == .Arabic{
                self.Actionn = "حسنا"
                self.Messagee = "لم يتم رفع خبرتك، يرجى المحاولة لاحقًا."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn)
            }
            
            if XLanguage.get() == .Kurdish{
                self.Actionn = "بەلێ"
                self.Messagee = "شارازاییا تە نە هاتنە بلند کرن، هیڤیە دوبارە بکە."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn)
            }
        }
    }
    
    
    
    
    
    func empty(){
        if XLanguage.get() == .English{
            Actionn = "Ok"
            Messagee = "Please write all your informations."
            Alert(title: "", message: Messagee, action: Actionn)
        }
        
        if XLanguage.get() == .Arabic{
            Actionn = "حسنا"
            Messagee = "الرجاء اكتب كل المعلوماتك."
            Alert(title: "", message: Messagee, action: Actionn)
        }
        
        if XLanguage.get() == .Kurdish{
            Actionn = "بەلێ"
            Messagee = "هیڤیە هەمی زانیاریان بنڤیسە."
            Alert(title: "", message: Messagee, action: Actionn)
        }
    }
    

    func Alert(title : String , message:String , action :String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: action, style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func EditImage(_ sender: Any) {
//        self.SelectedAssets.removeAll()
//        let vc = BSImagePickerViewController()
//        vc.maxNumberOfSelections = 1
//        bs_presentImagePickerController(vc, animated: true,
//                                        select: { (asset: PHAsset) -> Void in
//        }, deselect: { (asset: PHAsset) -> Void in
//        }, cancel: { (assets: [PHAsset]) -> Void in
//        }, finish: { (assets: [PHAsset]) -> Void in
//            for i in 0..<assets.count{
//                self.SelectedAssets.append(assets[i])
//                print(self.SelectedAssets)
//            }
//            self.getAllImages()
//        }, completion: nil)
    }
    
    
    @IBAction func Save(_ sender: Any) {
        guard let FireId = UserDefaults.standard.string(forKey: "FireId") else {return}
        if  self.Namte.text != "" && self.Phone2.text != "" && self.Address.text != ""{
            if let UserId = UserDefaults.standard.string(forKey: "UserId"){
                _ = LoadingView.standardProgressBox.show(inView: self.view)
                UserObjectsAPI.SetUserInfo(full_name: self.Namte.text!, address: self.Address.text!, phone1: self.Phone1.text!, phone2: self.Phone2.text!, about_me: self.AboutMe.text!, img: "", fire_id: FireId, id: UserId) { info in
                    //self.Insert(info)
                    self.view.removeLoadingViews(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
//            }else if UserDefaults.standard.string(forKey: "UserId") == ""{
//                _ = LoadingView.standardProgressBox.show(inView: self.view)
//                self.uploadManyImage { URLs in
//                    UserObjectsAPI.SetUserInfo(full_name: self.Namte.text!, address: self.Address.text!, phone1: self.Phone1.text!, phone2: self.Phone2.text!, about_me: self.AboutMe.text!, img: URLs[0], fire_id: FireId, id: "") { info in
//                        UserObjectsAPI.GetUserInfo(FirebaseId: FireId) { UserInfo in
//                            UserDefaults.standard.set(UserInfo.id, forKey: "UserId")
//                        }
//                        self.Insert(info)
//                        self.view.removeLoadingViews(animated: true)
//                    }
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
        }else{
            self.empty()
        }
    }
}
