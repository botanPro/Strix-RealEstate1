    //
//  EstateProfileVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/9/22.
//

import UIKit
import FSPagerView
import SDWebImage
import ScrollingPageControl
import Alamofire
import SwiftyJSON
import CollieGallery
import CustomLoader
import youtube_ios_player_helper
import MapKit
import CollieGallery
class EstateProfileVC: UIViewController , YTPlayerViewDelegate, MKMapViewDelegate{
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var Saved: UIButton!
    
    var sliderImages : [EstateImageObject] = []
    @IBOutlet weak var slider1Container: FSPagerView!{
        didSet{
            self.slider1Container.layer.masksToBounds = true
            self.slider1Container.automaticSlidingInterval = 4.0
            self.slider1Container.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.slider1Container.transformer = FSPagerViewTransformer(type: .crossFading)
            self.slider1Container.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var PagerControl: ScrollingPageControl!{
        didSet {
            self.PagerControl.dotColor = #colorLiteral(red: 0.6052123308, green: 0.6128310561, blue: 0.6126970053, alpha: 1)
            self.PagerControl.selectedColor = #colorLiteral(red: 1, green: 0.9771955609, blue: 1, alpha: 1)
            self.PagerControl.dotSize = CGFloat(8)
        }
    }
    
    
    
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
    
    
    
    var IsSaved = false
    
    @IBAction func Saved(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "Login") == true{
            UserObjectsAPI.GetUserInfo(FirebaseId: UserDefaults.standard.string(forKey: "FireId") ?? "") { UserInfo in
                if let Info = self.EstateProfileInfo{
                    _ = LoadingView.standardProgressBox.show(inView: self.view)
                    if self.IsSaved == true {
                        UserObjectsAPI.SaveUnSave(add_dell: "0", saved_pro_id: Info.id, id: UserInfo.id) { Info in
                            self.Saved.setImage(UIImage(named: "saved-empty"))
                            self.IsSaved = !self.IsSaved
                            self.view.removeLoadingViews(animated: true)
                        }
                    }else{
                        UserObjectsAPI.SaveUnSave(add_dell: "1", saved_pro_id: Info.id, id: UserInfo.id) { Info in
                            self.Saved.setImage(UIImage(named: "saved-fill"))
                            self.IsSaved = !self.IsSaved
                            self.view.removeLoadingViews(animated: true)
                        }
                    }
                }
            }
        }else{print("haaaaaaaatttttt")
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    
    
    var pictures = [CollieGalleryPicture]()
    
    
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var ProjectName: UILabel!
    
    
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var RentSellLable: UILabel!
    @IBOutlet weak var CashOrInstallment: UILabel!
    @IBOutlet weak var OverView: UITextView!
    
    @IBOutlet weak var player: YTPlayerView!
    var EstateProfileInfo : EstateObjects!
    
    
    
    @IBOutlet weak var RelatedCollectionView: UICollectionView!
    
    
    @IBOutlet weak var OverViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var YTVideoHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var RelatedCollectionViewLayout: NSLayoutConstraint!
    @IBOutlet weak var MapView: MKMapView!
    var RelatedArray : [EstateObjects] = []
    var DetailsArray : [DetailObject] = []
    
    
    
    
    @IBOutlet weak var DetailsCollectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 10
    
    
    
    
    
    
    @IBOutlet weak var a1: LanguageLable!
    @IBOutlet weak var a2: LanguageLable!
    @IBOutlet weak var a3: LanguageLable!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            self.a1.textAlignment = .right
            self.a2.textAlignment = .right
            self.a3.textAlignment = .right
            
            self.ProjectName.textAlignment = .right
            self.OverView.textAlignment = .right
        }
        
        
        self.player.layer.masksToBounds = true
        self.DetailsCollectionView.delegate = self
        self.DetailsCollectionView.dataSource = self
        player.delegate = self
        self.MapView.delegate = self
        RelatedCollectionView.register(UINib(nibName: "AllEstatesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        DetailsCollectionView.register(UINib(nibName: "DetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DCell")
        GetDate()
        GetAboutUs()
        
        MakeCall.onClickAction = { (button) in
            self.makePhoneCall(phoneNumber: self.CountactUs)
        }
        
    }
    
    @IBOutlet weak var OverViewLableHeightLayout: NSLayoutConstraint!
    
    func GetDate(){
        if let Info = EstateProfileInfo{
            print(Info.zone_name)
            self.pictures.removeAll()
            player.load(withVideoId: Info.estate_vedio, playerVars: ["playsinline" : 1, "controls" : 0 ,"showinfo" : 0])
            
            if Info.estate_vedio == ""{
                self.YTVideoHeightLayout.constant = 0
            }
            
            if Info.disc == ""{
                self.OverViewLableHeightLayout.constant = 0
                self.OverViewHeightLayout.constant = 0
            }
            
            self.ProjectName.text = Info.project_title
            self.Price.text = Info.price.description.currencyFormatting()
            self.Location.text = "Duhok~\(Info.zone_name)~\(Info.project_title)"
            
            let dateString = Info.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString = dateFormatter.date(from: dateString)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd-MM-YYYY"
            let stringFromDate = dateFormatter2.string(from: dateFromString!)
            self.Date.text = stringFromDate
            
            let lang = UserDefaults.standard.integer(forKey: "Lang")
            if lang == 2 {
                if Info.rent_sell == "rent"{
                   self.RentSellLable.text = "اجار"
                }else{
                    self.RentSellLable.text = "بیع"
                }
                if Info.cash_installment == "cash"{
                   self.CashOrInstallment.text = "دفع"
                }else{
                    self.CashOrInstallment.text = "اقساط"
                }
            }else if lang == 3{
                if Info.rent_sell == "rent"{
                   self.RentSellLable.text = "کرێ"
                }else{
                    self.RentSellLable.text = "فروشتن"
                }
                if Info.cash_installment == "cash"{
                   self.CashOrInstallment.text = "کاش"
                }else{
                    self.CashOrInstallment.text = "قست"
                }
            }else{
                if Info.rent_sell == "rent"{
                   self.RentSellLable.text = "rent"
                }else{
                    self.RentSellLable.text = "sell"
                }
                if Info.cash_installment == "cash"{
                   self.CashOrInstallment.text = "cash"
                }else{
                    self.CashOrInstallment.text = "installment"
                }
            }
            
            
            
            self.OverView.text = Info.disc
            
           var Id = "Id"
           var BuldingNo = "Building Number"
           var FloorNo = "Floor Number"
           var EstateNo = "Estate Number"
           var NoBedRoom = "Bed Rooms"
           var NoWashRoom = "Wash Rooms"
           var NoSweednRoom = "Sweeden Rooms"
           var Furnished = "Furnished"
           var NoBalcony = "Balaconies"
           var SpaceDet = "Space Details"
           var Fee = "Mounthly Fee"
           var Year = "Year"
           var Space = "Cpace"
           var Direction = "Direction"
           var CashInstallment = "Paying Type"

            
            
            if lang == 2{
                Id = "Id"
                BuldingNo = "رقم عیمارة"
                FloorNo = "رقم الطابق"
                EstateNo = "ةرقم الشقە"
                NoBedRoom = "عدد الغرف"
                NoWashRoom = "عدد الحمامات"
                NoSweednRoom = "عدد غرف السویدیە"
                Furnished = "مفروشة"
                NoBalcony = "عدد البلکونات"
                SpaceDet = "نوع الغرف"
                Fee = "سعر خدمات الشهریة"
                Year = "سنە البناء"
                Space = "المساحة"
                Direction = "الواجهة"
                CashInstallment = "نوع الدفع"
            }else if lang == 3{
                Id = "Id"
                BuldingNo = "ژمارا عیماران"
                FloorNo = "ژمارا طابقی"
                EstateNo = "ژمارا شقێ"
                NoBedRoom = "ژمارا ژورێن نڤستنێ"
                NoWashRoom = "ژمارا سەرشوویان"
                NoSweednRoom = "ژمارا ژورێن سویدی"
                Furnished = "رایێخستی"
                NoBalcony = "ژمارا بەلەکۆنا"
                SpaceDet = "جورێ ژوران"
                Fee = "بهایێ خزمەتگۆزاریێن هەیڤانە"
                Year = "ساڵا ئاڤاکرنێ"
                Space = "رۆبەر"
                Direction = "ئاراستە"
                CashInstallment = "جۆرێ پارەدانێ"
            }
            
            
            self.DetailsArray.append(DetailObject(name: Id,              image: "id", number: Info.id))
            self.DetailsArray.append(DetailObject(name: Space,           image: "space", number: Info.space))
            self.DetailsArray.append(DetailObject(name: SpaceDet,        image: "number-1", number: Info.space_det))
            self.DetailsArray.append(DetailObject(name: BuldingNo,       image: "build", number: Info.bulding_number))
            self.DetailsArray.append(DetailObject(name: FloorNo,         image: "floor", number: Info.floor_number))
            self.DetailsArray.append(DetailObject(name: EstateNo,        image: "icons8-79-100", number: Info.estate_number))
            self.DetailsArray.append(DetailObject(name: NoBedRoom,       image: "bed", number: Info.no_bedrooms))
            self.DetailsArray.append(DetailObject(name: NoWashRoom,      image: "wash", number: Info.no_washroom))
            self.DetailsArray.append(DetailObject(name: NoSweednRoom,    image: "wash-1", number: Info.no_sweeden_room))
            self.DetailsArray.append(DetailObject(name: NoBalcony,       image: "icons8-balcony-100 (1)", number: Info.no_balcon))
            self.DetailsArray.append(DetailObject(name: Direction,       image: "compass", number: Info.direction))
            self.DetailsArray.append(DetailObject(name: Furnished,       image: "Furnished", number: Info.furnished))
            self.DetailsArray.append(DetailObject(name: Year,            image: "year", number: Info.year_constraction))
            self.DetailsArray.append(DetailObject(name: Fee,             image: "icons8-euro-money-100", number: Info.monthly_fee.description.currencyFormattingWithoutIQD()))
            if lang == 2 {
                if Info.cash_installment == "cash"{
                    self.DetailsArray.append(DetailObject(name: CashInstallment, image: "icons8-canadian-dollar-96", number: "دفع"))
                }else{
                    self.DetailsArray.append(DetailObject(name: CashInstallment, image: "icons8-canadian-dollar-96", number: "اقساط"))
                }
            }else if lang == 3{
                if Info.cash_installment == "cash"{
                    self.DetailsArray.append(DetailObject(name: CashInstallment, image: "icons8-canadian-dollar-96", number: "کاش"))
                }else{
                    self.DetailsArray.append(DetailObject(name: CashInstallment, image: "icons8-canadian-dollar-96", number: "قست"))
                }
            }else{
                if Info.cash_installment == "cash"{
                    self.DetailsArray.append(DetailObject(name: CashInstallment, image: "icons8-canadian-dollar-96", number: "cash"))
                }else{
                    self.DetailsArray.append(DetailObject(name: CashInstallment, image: "icons8-canadian-dollar-96", number: "installment"))
                }
            }
            
            self.DetailsCollectionView.reloadData()
            
            
            let location = CLLocationCoordinate2D(latitude: (Info.latitude as NSString).doubleValue, longitude: (Info.longitude as NSString).doubleValue)
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: location, span: span)
            self.MapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            self.MapView.addAnnotation(annotation)
            
            
            if let FireId = UserDefaults.standard.string(forKey: "FireId"){
                UserObjectsAPI.GetUserInfo(FirebaseId: FireId) { UserInfo in
                    EstateApi.GetSaved(Id: UserInfo.id) { estate in
                    for Estate in estate{
                        if Info.id == Estate.id{
                            self.IsSaved = true
                            self.Saved.setImage(UIImage(named: "saved-fill"))
                        }else{
                            self.IsSaved = false
                            self.Saved.setImage(UIImage(named: "saved-empty"))
                        }
                    }
                }
                }
            }
            
            
            
            EstateImageObjectAPI.GetImages(Id: Info.id) { SlideImage in
                self.sliderImages = SlideImage

                self.PagerControl.pages = SlideImage.count
                if SlideImage.count <= 5 {
                    self.PagerControl.maxDots = 5
                    self.PagerControl.centerDots = 5
                } else {
                    self.PagerControl.maxDots = 7
                    self.PagerControl.centerDots = 3
                }
                for image in SlideImage{
                    let strUrl = image.name
                    let picture = CollieGalleryPicture(url: strUrl.replacingOccurrences(of: " ", with: "%20"))
                    self.pictures.append(picture)
                }
                self.slider1Container.reloadData()
            }
            
            EstateApi.GetRelated(Id: Info.id) { estates in
                self.RelatedArray = estates
                self.RelatedCollectionView.reloadData()
            }
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
    
    
    
    
    
    
    @IBOutlet weak var MakeCall : AZSocialButton!
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL)
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let height = self.RelatedCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.RelatedCollectionViewLayout.constant = height
            }
    }
    
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.player.playVideo()
    }
}

extension EstateProfileVC: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if sliderImages.count != 0{
        let urlString = self.sliderImages[index].name;
        let url = URL(string: urlString)
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imageView?.sd_setImage(with: url, completed: nil)
            cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let gallery = CollieGallery(pictures: self.pictures)
        gallery.presentInViewController(self)
    }
    
}




extension EstateProfileVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == RelatedCollectionView{
            if RelatedArray.count == 0 {
                return 0
            }
            return RelatedArray.count
        }
        if collectionView == DetailsCollectionView{
            if DetailsArray.count == 0{
                return 0
            }
            return DetailsArray.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == RelatedCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AllEstatesCollectionViewCell
        cell.Delete.isHidden = true
        cell.update(self.RelatedArray[indexPath.row])
        return cell
        }
        if collectionView == DetailsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCell", for: indexPath) as! DetailsCollectionViewCell
            cell.Image.image = UIImage(named: self.DetailsArray[indexPath.row].image)
            print(self.DetailsArray[indexPath.row].name)
            cell.Name.text = self.DetailsArray[indexPath.row].name
            cell.Number.text = self.DetailsArray[indexPath.row].number
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == RelatedCollectionView{
            return CGSize(width: collectionView.frame.size.width, height: 320)
        }
        
        if collectionView == DetailsCollectionView{
            let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 110)
        }
        
        return CGSize()
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == RelatedCollectionView{
             return 8
         }
         if collectionView == DetailsCollectionView{
             return spacingBetweenCells
         }
         return 0
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == RelatedCollectionView{
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 20.0, right: 5.0)
        }
        
        if collectionView == DetailsCollectionView{
            return sectionInsets
        }
        
        return UIEdgeInsets()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == RelatedCollectionView{
            if self.RelatedArray.count != 0 && indexPath.row <= self.RelatedArray.count{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "EstateVc") as! EstateProfileVC
        myVC.EstateProfileInfo = self.RelatedArray[indexPath.row]
        myVC.modalPresentationStyle = .fullScreen
        self.present(myVC, animated: true, completion: nil)
            }
        }
    }

}
       

extension String {
  
    func strippingHTML() throws -> String?  {
        if isEmpty {
            return nil
        }
        
        if let data = data(using: .utf8) {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType : NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            var string = attributedString.string
            
            // These steps are optional, and it depends on how you want handle whitespace and newlines
            string = string.replacingOccurrences(of: "\u{FFFC}",
                                                 with: "",
                                                 options: .regularExpression,
                                                 range: nil)
            string = string.replacingOccurrences(of: "(\n){3,}",
                                                 with: "\n\n",
                                                 options: .regularExpression,
                                                 range: nil)
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return nil
    }
}



class DetailObject{
    var name = ""
    var image = ""
    var number = ""
    
    
    init(name : String , image : String , number : String) {
        self.name = name
        self.image = image
        self.number = number
    }
}
