//
//  HomeVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import UIKit
import FSPagerView
import CRRefresh
import SDWebImage
import OneSignal
import EFInternetIndicator
class HomeVC: UIViewController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var HomeTitle: UIBarButtonItem!
    
    @IBOutlet weak var ZoneCollectionView: UICollectionView!{didSet{self.GetZones()}}
    @IBOutlet weak var AllEstatesCollectionView: UICollectionView!{didSet{self.GetEstates(start: self.start, limit: 20)}}
    @IBOutlet weak var HomeProjectCollectionView : UICollectionView!{didSet{self.GetAllProjects()}}
    
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    var sliderImages : [SlideShowObject] = []
    var AllEstate : [EstateObjects] = []
    var ProjectArray : [ProjectObjects] = []
    var ZoneArray : [ZoneObject] = []
    
    
    
    
    @IBAction func SearchStackAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToSearchVC") as! GoToSearchVC
        myVC.title = title
        
        self.navigationController?.pushViewController(myVC, animated: false)
    }
    
    
    @IBOutlet weak var SliderView: FSPagerView!{
        didSet{
            self.GetSlides()
            self.SliderView.layer.masksToBounds = true
            self.SliderView.layer.cornerRadius = 8
            self.SliderView.automaticSlidingInterval = 4.0
            self.SliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.SliderView.transformer = FSPagerViewTransformer(type: .crossFading)
            self.SliderView.itemSize = FSPagerView.automaticSize
        }
    }
    
    var IsFooter = false
    var start = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.integer(forKey: "Lang")

        
        
        self.SearchView.layer.cornerRadius = 8
        self.SearchView.layer.borderColor = #colorLiteral(red: 0.6043949723, green: 0.6745013595, blue: 0.7449656725, alpha: 0.2031039813)
        self.SearchView.layer.borderWidth = 1.2
        HomeTitle.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: "rudawregular", size: 20)!,
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.07560480386, green: 0.2257080078, blue: 0.3554315865, alpha: 1)
            ], for: .normal)
        
        
        
        
        self.SliderView.layer.cornerRadius = 10
        HomeProjectCollectionView.register(UINib(nibName: "HomeProjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        ZoneCollectionView.register(UINib(nibName: "ZoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        AllEstatesCollectionView.register(UINib(nibName: "AllEstatesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        self.ScrollView.cr.addFootRefresh {
            self.IsFooter = true
            self.start += 20
            self.GetEstates(start : self.start,limit : 20)
        }
        
        
        self.ScrollView.cr.addHeadRefresh {
            self.GetAllProjects()
            self.GetSlides()
            self.start = 0
            self.IsFooter = false
            self.GetEstates(start : self.start,limit : 20)
            self.GetZones()
        }
        
        
    }
    
    
    
    
    func GetAllProjects(){
        self.ProjectArray.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.ScrollView.cr.endHeaderRefresh()
        }
        ProjectApi.GetAllProjects { projects in
            self.ProjectArray = projects
            self.ScrollView.cr.endHeaderRefresh()
            self.HomeProjectCollectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var Refreash: UIButton!
    
    @IBAction func Refreash(_ sender: Any) {
        if CheckInternet.Connection() == true{
            self.GetAllProjects()
            self.GetSlides()
            self.start = 0
            self.IsFooter = false
            self.GetEstates(start : self.start,limit : 20)
            self.GetZones()
            self.ScrollView.isHidden = false
            self.Refreash.isHidden = true
        }else{
            let alertController = UIAlertController(title: "No Internet Comnection", message: "Please, Check your connection with internet", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startMonitoringInternet()
        if CheckInternet.Connection() == false{
            self.ScrollView.isHidden = true
            self.Refreash.isHidden = false
        }else{
            self.ScrollView.isHidden = false
            self.Refreash.isHidden = true
            self.GetAllProjects()
            self.GetSlides()
            self.start = 0
            self.IsFooter = false
            self.GetEstates(start : self.start,limit : 20)
            self.GetZones()
        }
        if UserDefaults.standard.bool(forKey: "Login") == true{print("============")
            if let FireId = UserDefaults.standard.string(forKey: "FireId"){
                UserObjectsAPI.GetUserInfo(FirebaseId: FireId) { UserInfo in
                    print("========000000000000===")
                    print("Player Id\(String(describing: OneSignal.getDeviceState().userId))")
                    UpdateOneSignalIdAPI.Update(onesignalUUID: OneSignal.getDeviceState().userId!, userId: UserInfo.id)
                }
            }
        }
    }
    
    
    
    
    func GetEstates(start : Int,limit : Int){
        if self.IsFooter == false{
            self.AllEstate.removeAll()
            EstateApi.GetHomeEstate(Start: start, Limit: limit, completion: { Estates in
                self.AllEstate = Estates
                self.ScrollView.cr.endHeaderRefresh()
                self.AllEstatesCollectionView.reloadData()
            })
        }else{
            EstateApi.GetHomeEstate(Start: start, Limit: limit, completion: { Estates in
                self.AllEstate.append(contentsOf:Estates)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.ScrollView.cr.endLoadingMore()
                    let height = self.AllEstatesCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.AllEstatesCollectionLayout.constant = height
                }
                self.AllEstatesCollectionView.reloadData()
            })
        }
    }
    
    
    
    
    func GetSlides(){
        self.sliderImages.removeAll()
        SlideShowAPI.GetSlideImage { SlideImage in
            self.sliderImages = SlideImage
            self.ScrollView.cr.endHeaderRefresh()
            self.SliderView.reloadData()
        }
    }
    
    func GetZones(){
        self.ZoneArray.removeAll()
        ZoneAPI.GetZones { zones in
            self.ZoneArray = zones
            self.ScrollView.cr.endHeaderRefresh()
            self.ZoneCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var AllEstatesCollectionLayout: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, delay: 0) {
                let height = self.AllEstatesCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.AllEstatesCollectionLayout.constant = height
                self.view.layoutIfNeeded()
            }
        }
    }
    
}


extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ZoneCollectionView{
            if ZoneArray.count == 0 {
                return 0
            }else{
                return ZoneArray.count
            }
        }
        if collectionView == HomeProjectCollectionView{
            if ProjectArray.count == 0 {
                return 0
            }else{
                return ProjectArray.count
            }
        }
        
        if collectionView == AllEstatesCollectionView{
            if AllEstate.count == 0 {
                return 0
            }else{
                return AllEstate.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == ZoneCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ZoneCollectionViewCell
        if self.ZoneArray.count != 0{
            cell.Vieww.backgroundColor = #colorLiteral(red: 0.002741396427, green: 0.6212182641, blue: 0.914432466, alpha: 1)
            cell.Name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.Name.text = ZoneArray[indexPath.row].name
        }
        return cell
        }
        
        if collectionView == HomeProjectCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeProjectCollectionViewCell
            cell.update(self.ProjectArray[indexPath.row])
            return cell
        }
        
        if collectionView == AllEstatesCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AllEstatesCollectionViewCell
            cell.Delete.isHidden = true
            cell.update(self.AllEstate[indexPath.row])
        return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == ZoneCollectionView{
            return CGSize(width: collectionView.frame.size.width / 4, height: 40)
        }
        if collectionView == HomeProjectCollectionView{
            return CGSize(width: collectionView.frame.size.width / 1.6, height: 130)
        }
        
        if collectionView == AllEstatesCollectionView{
            return CGSize(width: collectionView.frame.size.width, height: 320)
        }
        return CGSize()
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == ZoneCollectionView{
              return 0
         }
         
         if collectionView == HomeProjectCollectionView{
             return 5
         }
         
         
         if collectionView == AllEstatesCollectionView{
             return 8
         }
         
         return CGFloat()
     }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == AllEstatesCollectionView{
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 20.0, right: 5.0)
        }
        if collectionView == HomeProjectCollectionView{
            return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        }
        return UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 6.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ZoneCollectionView{
            if self.ZoneArray.count != 0 && indexPath.row <= self.ZoneArray.count{
              callSegueFromCell(myData: self.ZoneArray[indexPath.row].id, title: ZoneArray[indexPath.row].name)
            }
        }
        
        if collectionView == HomeProjectCollectionView{
            if self.ProjectArray.count != 0 && indexPath.row <= self.ProjectArray.count{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "ProjectVC") as! ProjectVC
            myVC.title = self.ProjectArray[indexPath.row].title
            myVC.ProjectComming = self.ProjectArray[indexPath.row]
            self.navigationController?.pushViewController(myVC, animated: true)
            }
        }
        
        if collectionView == AllEstatesCollectionView{
            if self.AllEstate.count != 0 && indexPath.row <= self.AllEstate.count{
            self.performSegue(withIdentifier: "Next", sender: AllEstate[indexPath.row])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let estate = sender as? EstateObjects{
            if let next = segue.destination as? EstateProfileVC{
                next.EstateProfileInfo = estate
            }
        }
    }
    
    func callSegueFromCell(myData: String , title : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ZoneAllProjectsVc") as! ZoneAllProjectsVc
        myVC.ZoneId = myData
        myVC.title = title
        self.navigationController?.pushViewController(myVC, animated: true)
    }
   
}



extension HomeVC: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if sliderImages.count != 0{
        let urlString = "\(API.SlideImageURL)\(sliderImages[index].image)";
        let url = URL(string: urlString)
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imageView?.sd_setImage(with: url, completed: nil)
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 8
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if sliderImages.count != 0{
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
            
            if let url = NSURL(string: sliderImages[index].link){
                UIApplication.shared.open(url as URL)
            }
        }
    }

}
