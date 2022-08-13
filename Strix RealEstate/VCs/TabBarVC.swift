//
//  TabBarVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 6/7/22.
//

import UIKit
import EFInternetIndicator

class TabBarVC: UITabBarController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startMonitoringInternet()

    }

}
