//
//  ProjectVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/4/22.
//

import UIKit
import youtube_ios_player_helper
import CRRefresh
class ProjectVC: UIViewController , YTPlayerViewDelegate{
    var ProjectComming : ProjectObjects?
    @IBOutlet weak var ProjectName: UILabel!
    var Titlee = ""
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Spaces: UILabel!
    @IBOutlet weak var PriceFrom: UILabel!
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 2
    @IBOutlet weak var NofBuildings: UILabel!
    let spacingBetweenCells: CGFloat = 10
    @IBOutlet weak var AllEstatesCollectionView: UICollectionView!
    @IBOutlet weak var player: YTPlayerView!
    @IBOutlet weak var AllEstatesCollectionLayout: NSLayoutConstraint!
    
    
    
    @IBAction func GoToLocation(_ sender: Any) {
        if let UrlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(self.latitude.trimmingCharacters(in: .whitespaces)),\(self.longitude.trimmingCharacters(in: .whitespaces))&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }else {print("opopopopop")
                NSLog("Can't use comgooglemaps://");
                self.openTrackerInBrowser()
            }
        }else{print("lkklklklkl")
            NSLog("Can't use comgooglemaps://");
            self.openTrackerInBrowser()
        }
    }
    
func openTrackerInBrowser(){
   if let urlDestination = URL.init(string: "http://maps.google.com/maps?q=loc:\(self.latitude.trimmingCharacters(in: .whitespaces)),\(self.longitude.trimmingCharacters(in: .whitespaces))&directionsmode=driving") {
          UIApplication.shared.open(urlDestination)
       print("p[p[p[p")
      }
  }
    
    var latitude = ""
    var longitude = ""
    
    var AllEstate : [EstateObjects] = []
    
    
    
    
    @IBOutlet weak var a1: LanguageLable!
    @IBOutlet weak var infoStack: UIStackView!
    
    
    
    
    
    var to = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            self.a1.textAlignment = .right
            self.infoStack.alignment = .trailing
            self.ProjectName.textAlignment = .right
            self.PriceFrom.textAlignment = .right
            self.Location.textAlignment = .right
        }
        
        
        if lang == 2{
            self.to = "الی"
        }else if lang == 3{
            self.to = "بو"
        }else{
            self.to = "to"
        }
        
        self.ProjectName.text = Titlee
        self.AllEstatesCollectionView.delegate = self
        self.AllEstatesCollectionView.dataSource = self
        self.player.layer.masksToBounds = true
        player.delegate = self
        
        AllEstatesCollectionView.register(UINib(nibName: "AllEstatesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        
        if let project = self.ProjectComming{
            player.load(withVideoId: project.project_vedio, playerVars: ["replay" : 1, "controls" : 0 ,"showinfo" : 0])
            self.ProjectName.text = project.title
            self.NofBuildings.text = project.buldings
            self.Price.text = project.monthly_fee.currencyFormatting()
            self.PriceFrom.text = "\(project.from_money.description.currencyFormatting())  \(self.to)  \(project.to_money.description.currencyFormatting())"
            
            self.Spaces.text = project.spaces
            self.Location.text = "Duhok~\(project.zone_name)~\(project.title)"
            self.GetEstatesPro(id: project.id)
            self.AllEstatesCollectionView.cr.addHeadRefresh {
            self.GetEstatesPro(id: project.id)
                self.latitude = project.latitude
                self.longitude = project.longtitude
             }
            
        }
    }
    
    
    
    
    
    
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
    }
    
    func GetEstatesPro(id : String){
        self.AllEstate.removeAll()
        ProjectApi.GetEstateByProjectId(Id: id) { estates in
            self.AllEstate = estates
            self.AllEstatesCollectionView.cr.endHeaderRefresh()
            self.AllEstatesCollectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let height = self.AllEstatesCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.AllEstatesCollectionLayout.constant = height
        }
    }
}




extension ProjectVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.AllEstate.count == 0{
            return 0
        }
        return self.AllEstate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AllEstatesCollectionViewCell
        cell.Delete.isHidden = true
        cell.update(self.AllEstate[indexPath.row])
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
        if self.AllEstate.count != 0 && indexPath.row <= self.AllEstate.count{
        self.performSegue(withIdentifier: "Next", sender: AllEstate[indexPath.row])
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
