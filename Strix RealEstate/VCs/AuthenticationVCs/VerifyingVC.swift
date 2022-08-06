//
//  VerifyingVC.swift
//  RealEstates
//
//  Created by botan pro on 3/8/22.
//

import UIKit
import OTPTextField
import MHLoadingButton
import Firebase
import FirebaseAuth
class VerifyingVC: UIViewController {

    @IBOutlet weak var Verify: LoadingButton!
    @IBOutlet weak var OTPCode: OTPTextField!
    
    
    @IBAction func Dismis(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OTPCode.becomeFirstResponder()
        self.Verify.layer.cornerRadius = 8
        Verify.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        Verify.layer.shadowOpacity = 1
        Verify.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        Verify.layer.shadowRadius = 2
        Verify.indicator = MaterialLoadingIndicator(color: .gray)
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            let myMessage = "no virification code"
            let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            return
            
        }
        self.ver = verificationID
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2{
            self.Verify.setTitle("تحقیق الرمز")
        }else if lang == 3{
            self.Verify.setTitle("پشتراست کرن")
        }
    }
    var ver : String = ""
    var credential : PhoneAuthCredential!
    
    
    
    @IBAction func Verify(_ sender: Any) {
        if self.OTPCode.text! != ""{
            Verify.showLoader(userInteraction: true)
            credential = PhoneAuthProvider.provider().credential(
                withVerificationID: self.ver ,
                verificationCode: self.OTPCode.text!.convertedDigitsToLocale(Locale(identifier: "EN")))
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.Verify.hideLoader()
                    UserDefaults.standard.set(false, forKey: "Login")
                    let myMessage = error.localizedDescription
                    let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
                
                
                
                if ((authResult?.user) != nil){
                    guard let UserId = authResult?.user.uid else { return }
                    UserObjectsAPI.GetUserInfo(FirebaseId: UserId) { UserInfo in
                        UserDefaults.standard.set(UserId, forKey: "FireId")
                        self.Verify.hideLoader()
                        if UserInfo.IsArchived == "1"{
                            let myAlertin = UIAlertController(title: "Note", message: "The account associated with this number has been deleted before, do you want to create a new account?", preferredStyle: UIAlertController.Style.alert)
                            myAlertin.addAction(UIAlertAction(title: "Create new account", style: .default, handler: { (UIAlertActiokn) in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC")
                                vc!.modalPresentationStyle = .overFullScreen
                                vc!.modalTransitionStyle = .crossDissolve
                                self.present(vc!, animated: true)
                            }))
                            myAlertin.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
                            self.present(myAlertin, animated: true, completion: nil)
                        }else{
                            if UserInfo.full_name == ""{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC")
                                vc!.modalPresentationStyle = .overFullScreen
                                vc!.modalTransitionStyle = .crossDissolve
                                self.present(vc!, animated: true)
                            }else{
                                UserDefaults.standard.set(true, forKey: "Login")
                                UserDefaults.standard.set(UserInfo.id, forKey: "UserId")
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVc")
                                vc!.modalPresentationStyle = .overFullScreen
                                vc!.modalTransitionStyle = .crossDissolve
                                self.present(vc!, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
}

