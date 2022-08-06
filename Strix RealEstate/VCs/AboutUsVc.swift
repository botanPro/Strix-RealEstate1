//
//  AboutUsVc.swift
//  Strix RealEstate
//
//  Created by botan pro on 6/4/22.
//

import UIKit

class AboutUsVc: UIViewController {
    var AboutObject : AboutUsObject?
    @IBOutlet weak var About: UITextView!
    
    @IBOutlet weak var YouTube: AZSocialButton!
    @IBOutlet weak var Instagram: AZSocialButton!
    @IBOutlet weak var CallUs: AZSocialButton!
    @IBOutlet weak var Twitter: AZSocialButton!
    @IBOutlet weak var FaceBook: AZSocialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(AboutObject?.about_us ?? "")
        self.About.text = AboutObject?.about_us
        self.Instagram.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.AboutObject?.instagram ?? "" ) {
                UIApplication.shared.open(urlDestination)
            }
        }
        
        
        CallUs.onClickAction = { (button) in
            self.makePhoneCall(phoneNumber: self.AboutObject?.phone ?? "")
        }
        
        self.FaceBook.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.AboutObject?.facebook ?? "") {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
        
        
        self.Twitter.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.AboutObject?.twitter ?? "") {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
        
        
        self.YouTube.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.AboutObject?.youtube ?? "") {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL)
        }
    }
}
