//
//  LoginVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import UIKit
import PhoneNumberKit
import MHLoadingButton
import Firebase
import FirebaseAuth

class LoginVC: UIViewController ,UITextFieldDelegate{

        @IBOutlet weak var Login: LoadingButton!
        @IBOutlet weak var View1: UIView!
        @IBOutlet weak var Dismiss: UIButton!
        @IBOutlet weak var PhoneNumber: PhoneNumberTextField!
        
        @IBAction func Dismiss(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
        var TextLength = 0
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            TextLength = textField.text?.count ?? 0
            return false
        }
        
        
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.PhoneNumber.becomeFirstResponder()
    }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.PhoneNumber.becomeFirstResponder()
            self.Login.layer.cornerRadius = 8
            self.View1.layer.cornerRadius = 8
            self.View1.layer.borderWidth = 1.5
            self.View1.layer.borderColor = #colorLiteral(red: 0.002777122427, green: 0.4764660597, blue: 0.9986379743, alpha: 1)
            
            View1.clipsToBounds = false
            View1.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            View1.layer.shadowOpacity = 1
            View1.layer.shadowOffset = .zero
            View1.layer.shadowRadius = 3
            
            Login.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            Login.layer.shadowOpacity = 1
            Login.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            Login.layer.shadowRadius = 2
            
            self.PhoneNumber.keyboardType = .asciiCapable
            self.PhoneNumber.withPrefix = true
            self.PhoneNumber.withFlag = true
            self.PhoneNumber.withExamplePlaceholder = true
            self.PhoneNumber.phoneNumberKit.allCountries()
            Login.indicator = MaterialLoadingIndicator(radius: 10, color: .gray)

            let lang = UserDefaults.standard.integer(forKey: "Lang")
            
            if lang == 2{
                self.Login.setTitle("تسجیل الدخول")
            }else if lang == 3{
                self.Login.setTitle("چوونە ژوور")
            }
        }
        
        var phone = ""
        @IBAction func Login(_ sender: Any) {
            print(self.PhoneNumber.text!)
            if self.PhoneNumber.text != "+964"{
                print(self.PhoneNumber.text![5])
                
                if self.PhoneNumber.text![5] == "0"{
                    self.phone = self.PhoneNumber.text!
                    let i = self.phone.index(self.phone.startIndex, offsetBy: 5)
                    print(i)
                    self.phone.remove(at: i)
                }else{
                    self.phone = self.PhoneNumber.text!
                }
                print(self.phone)
                Login.showLoader(userInteraction: true)
                PhoneAuthProvider.provider().verifyPhoneNumber(self.phone.convertedDigitsToLocale(Locale(identifier: "EN")), uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print(error)
                        self.Login.hideLoader()
                        let myMessage = error.localizedDescription
                        let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(myAlert, animated: true, completion: nil)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    UserDefaults.standard.set(self.PhoneNumber.text!, forKey: "PhoneNumber")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "VeryingVC") as! VerifyingVC
                    myVC.modalPresentationStyle = .fullScreen
                    self.Login.hideLoader()
                    self.present(myVC, animated: true, completion: nil)
                }
            }else{
                self.Login.hideLoader()
                if self.PhoneNumber.text == "+964"{
                    let myAlert = UIAlertController(title: "Please enter your number", message: nil, preferredStyle: UIAlertController.Style.alert)
                    myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(myAlert, animated: true, completion: nil)
                }
            }
        }
        
       
        
        
        
    }
    class MyGBTextField: PhoneNumberTextField {
        override var defaultRegion: String {
            get {
                return "IRQ"
            }
            set {} // exists for backward compatibility
        }
    }
    extension String {
        subscript(idx: Int) -> String {
            String(self[index(startIndex, offsetBy: idx)])
        }
    }







extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            guard let digit = Self.formatter.number(from: String($0)) else {
                assertionFailure("Can not convert to number from: \(original)")
                return (original, original)
            }
            guard let localized = Self.formatter.string(from: digit) else {
                assertionFailure("Can not convert to string from: \(digit)")
                return (original, original)
            }
            return (original, localized)
        }

        var converted = self
        for map in maps { converted = converted.replacingOccurrences(of: map.original, with: map.converted) }
        return converted
    }
}
