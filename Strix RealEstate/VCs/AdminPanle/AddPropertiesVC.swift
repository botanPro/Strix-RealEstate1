//
//  AddPropertiesVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/8/22.
//

import UIKit
import BSImagePicker
import Photos
import MBRadioCheckboxButton
import CustomLoader


import Alamofire
import SwiftyJSON


class AddPropertiesVC: UIViewController , RadioButtonDelegate, UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: [])
            if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) != nil {
                return false
            }
        }
        catch {
            print("ERROR")
        }
        return true
    }
    
    
    @IBOutlet weak var LocationLatLong: LanguageLable!
    @IBOutlet weak var Rent: RadioButton!
    @IBOutlet weak var Sell: RadioButton!
    
    @IBOutlet weak var Cash: RadioButton!
    @IBOutlet weak var Installment: RadioButton!

    var RentOrSell = ""
    var CashOrInstalment = ""
    func radioButtonDidSelect(_ button: RadioButton) {
        if button.titleLabel?.text! == "Rent" || button.titleLabel?.text! == "اجار" || button.titleLabel?.text! == "کرێ"{
            self.RentOrSell = "rent"
        }
        if button.titleLabel?.text! == "Sell" || button.titleLabel?.text! == "بیع" || button.titleLabel?.text! == "فروشتن"{print("[]][][")
            self.RentOrSell = "sell"
        }
        if button.titleLabel?.text! == "CASH" || button.titleLabel?.text! == "دفع" || button.titleLabel?.text! == "کاش"{print("-=-=-=-=-=-=")
            self.CashOrInstalment = "cash"
        }
        if button.titleLabel?.text! == "INSTALLMENT" || button.titleLabel?.text! == "اقساط" || button.titleLabel?.text! == "قست"{
            self.CashOrInstalment = "installment"
        }
        
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        //print("Dselect  : \(button.tag)")
    }
    
    @IBAction func SelecteLocation(_ sender: Any) {
        
    }
    
    @IBOutlet weak var viewGroup1: RadioButtonContainerView!
    @IBOutlet weak var viewGroup2: RadioButtonContainerView!
    var group3Container1 = RadioButtonContainer()
    var group3Container2 = RadioButtonContainer()
    func setupGroup1() {
        viewGroup1.buttonContainer.delegate = self
        viewGroup1.buttonContainer.delegate = self
        viewGroup1.buttonContainer.setEachRadioButtonColor {
            return RadioButtonColor(active: $0.tintColor , inactive: $0.tintColor)
        }
        group3Container1.addButtons([Rent, Sell])
        group3Container1.delegate = self
        group3Container1.selectedButton = Rent
        RentOrSell = "rent"
    }
    
    func setupGroup2() {
        viewGroup2.buttonContainer.delegate = self
        viewGroup2.buttonContainer.delegate = self
        viewGroup2.buttonContainer.setEachRadioButtonColor {
            return RadioButtonColor(active: $0.tintColor , inactive: $0.tintColor)
        }
        group3Container2.addButtons([Cash, Installment])
        group3Container2.delegate = self
        group3Container2.selectedButton = Cash
        CashOrInstalment = "cash"
    }
    
    
    
    @IBOutlet weak var Furnished: CheckboxButton!
    
    @IBOutlet weak var Price               :              UITextField!
    @IBOutlet weak var Space               :              UITextField!
    @IBOutlet weak var BuildingNumber      :     UITextField!
    @IBOutlet weak var FloorNumber         :        UITextField!
    @IBOutlet weak var EstateNumber        :       UITextField!
    @IBOutlet weak var Direction           :          UITextField!
    @IBOutlet weak var NBedrooms           :          UITextField!
    @IBOutlet weak var NWashrooms          :         UITextField!
    @IBOutlet weak var NSweedenRooms       :      UITextField!
    @IBOutlet weak var NBalcony            :           UITextField!
    @IBOutlet weak var Disc                :               UITextView!
    @IBOutlet weak var YearOfConstraction  : UITextField!
    @IBOutlet weak var MonthlyFee          :         UITextField!
    
    
    
    @IBOutlet weak var ProjectName: UILabel!
    @IBOutlet weak var ZoneName: UILabel!
    
    var ProjectId = ""
    var ZoneId = ""
    
    var latitude = ""
    var longitude = ""
    
    var SelectedRoomtype : SpaceDetile?
    var ComingEstate : EstateObjects?
    var IsUpdate = false
    @IBAction func SelectProject(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "SelectProjectOrZone") as! SelectProjectorZoneVC
        myVC.title = "Projects"
        myVC.IsProjectOrZone = true
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func SelecteZone(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "SelectProjectOrZone") as! SelectProjectorZoneVC
        myVC.title = "Zones"
        myVC.IsProjectOrZone = false
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBOutlet weak var ScrollViewLayout: NSLayoutConstraint!
    
    
    
    
    
      
    @IBOutlet weak var a1  :  LanguageLable!
    @IBOutlet weak var a2  :  LanguageLable!
    @IBOutlet weak var a3  :  LanguageLable!
    @IBOutlet weak var a4  :  LanguageLable!
    @IBOutlet weak var a5  :  LanguageLable!
    @IBOutlet weak var a6  :  LanguageLable!
    @IBOutlet weak var a7  :  LanguageLable!
    @IBOutlet weak var a8  :  LanguageLable!
    @IBOutlet weak var a9  :  LanguageLable!
    @IBOutlet weak var a10 : LanguageLable!
    @IBOutlet weak var a11 : LanguageLable!
    @IBOutlet weak var a12 : LanguageLable!
    @IBOutlet weak var a13 : LanguageLable!
    @IBOutlet weak var a14 : LanguageLable!
    
    
    
    
    
    
    var CommingImages : [EstateImageObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroup1()
        setupGroup2()
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            
            self.a1.textAlignment = .right
            self.a2.textAlignment = .right
            self.a3.textAlignment = .right
            self.a4.textAlignment = .right
            self.a5.textAlignment = .right
            self.a6.textAlignment = .right
            self.a7.textAlignment = .right
            self.a8.textAlignment = .right
            self.a9.textAlignment = .right
            self.a10.textAlignment = .right
            self.a11.textAlignment = .right
            self.a12.textAlignment = .right
            self.a13.textAlignment = .right
            self.a14.textAlignment = .right
            
            self.Price.textAlignment = .right
            self.Space.textAlignment = .right
            self.BuildingNumber.textAlignment = .right
            self.FloorNumber.textAlignment = .right
            self.EstateNumber.textAlignment = .right
            self.Direction.textAlignment = .right
            self.NBedrooms.textAlignment = .right
            self.NWashrooms.textAlignment = .right
            self.NSweedenRooms.textAlignment = .right
            self.NBalcony.textAlignment = .right
            self.Disc.textAlignment = .right
            self.YearOfConstraction.textAlignment = .right
            self.MonthlyFee.textAlignment = .right
            
            
            
            self.Price.delegate = self
            self.Space.delegate = self
            self.BuildingNumber.delegate = self
            self.FloorNumber.delegate = self
            self.EstateNumber.delegate = self
            self.Direction.delegate = self
            self.NBedrooms.delegate = self
            self.NWashrooms.delegate = self
            self.NSweedenRooms.delegate = self
            self.NBalcony.delegate = self
            self.Disc.delegate = self
            self.YearOfConstraction.delegate = self
            self.MonthlyFee.delegate = self
            self.Price.delegate = self

        }
        
        
        
        if lang == 2{
            self.Rent.setTitle("اجار")
            self.Sell.setTitle("بیع")
            
            self.Cash.setTitle("دفع")
            self.Installment.setTitle("اقساط")
            
            self.Furnished.setTitle("مفروشة")
        }else if lang == 3{
            self.Rent.setTitle("کرێ")
            self.Sell.setTitle("فروشتن")
            
            self.Cash.setTitle("کاش")
            self.Installment.setTitle("قست")
            
            self.Furnished.setTitle("رائێخستی")
        }
        

        
        self.RoomsType.append(SpaceDetile(id: "1", title: "1+1"))
        self.RoomsType.append(SpaceDetile(id: "2", title: "1+2"))
        self.RoomsType.append(SpaceDetile(id: "3", title: "1+3"))
        self.RoomsType.append(SpaceDetile(id: "4", title: "1+4"))
        self.RoomsType.append(SpaceDetile(id: "5", title: "1+5"))
        self.RoomsType.append(SpaceDetile(id: "6", title: "1+6"))
        self.NomberOfRoomsTypeCollectionView.reloadData()
        
        
        
        if let estate = ComingEstate{
            EstateImageObjectAPI.GetImages(Id: estate.id) { SlideImage in
                self.CommingImages = SlideImage
                self.ImagesCollectionView.reloadData()
        }
            if estate.rent_sell == "rent"{print(estate.rent_sell)
                self.group3Container1.selectedButton = self.Rent
                self.RentOrSell = "rent"
            }else{print(estate.rent_sell)
                self.group3Container1.selectedButton = self.Sell
                self.RentOrSell = "sell"
            }
            
            if estate.cash_installment == "cash"{
                self.group3Container2.selectedButton = self.Cash
                self.CashOrInstalment = "cash"
            }else{
                self.group3Container2.selectedButton = self.Installment
                self.CashOrInstalment = "installment"
            }
            
            
            if estate.furnished == "furnished"{
                self.Furnished.isOn = true
            }else{
                self.Furnished.isOn = false
            }
            
            self.Disc.text = estate.disc
            self.Price.text = estate.price
            self.Space.text = estate.space
            
            for estateType in RoomsType{
                if estate.space_det == estateType.title{
                    self.SelectedRoomtype = estateType
                    self.NomberOfRoomsTypeCollectionView.reloadData()
                }
            }
            
            
            self.BuildingNumber.text = estate.bulding_number
            self.FloorNumber.text = estate.floor_number
            self.EstateNumber.text = estate.estate_number
            self.Direction.text = estate.direction
            self.NBedrooms.text = estate.no_bedrooms
            self.NWashrooms.text = estate.no_washroom
            self.NSweedenRooms.text = estate.no_sweeden_room
            self.YearOfConstraction.text = estate.year_constraction
            self.MonthlyFee.text = estate.monthly_fee
            self.NBalcony.text = estate.no_balcon
            self.ZoneId = estate.zone_id
            self.ZoneName.text = estate.zone_name
            self.ProjectId = estate.project_id
            self.ProjectName.text = estate.project_title
            self.latitude = estate.latitude
            self.longitude = estate.longitude
            self.LocationLatLong.text = "\(estate.latitude), \(estate.longitude)"
            
            
            
        }
        
        
        
        
     
       
        ImagesCollectionView.register(UINib(nibName: "PropertiesImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        NomberOfRoomsTypeCollectionView.register(UINib(nibName: "ZoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    var count = 1
    @objc func keyboardWasShown(notification: NSNotification) {
        if count == 1{print("[[][]]]]]]]]]]-------=======")
           count += 1
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.ScrollViewLayout.constant += keyboardFrame.height - 50
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetProject(_:)), name: NSNotification.Name(rawValue: "ProjectComming"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.GetZone(_:)), name: NSNotification.Name(rawValue: "ZoneComming"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetCordinate(_:)), name: NSNotification.Name(rawValue: "CordinateComing"), object: nil)
    }
    
    
    
    @objc func GetCordinate(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let lat = dict["latitude"] as? CLLocationDegrees , let long = dict["longtitude"] as? CLLocationDegrees{
                let Lat = "\(lat)"
                let arrLat = Array(Lat)
                let Long = "\(long)"
                let arrLong = Array(Long)
                self.latitude = String(arrLat[0..<8])
                self.longitude = String(arrLong[0..<8])
                self.LocationLatLong.text = "\(String(arrLat[0..<8])), \(String(arrLong[0..<8]))"
            }
        }
    }
    
    @objc func GetProject(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            
            if let  projectName = dict["projectName"] as? String{
                self.ProjectName.text = projectName
            }
            
            if let projectId = dict["projectId"] as? String{
                self.ProjectId = projectId
            }
        }
    }
    
    
    
    
    
    @objc func GetZone(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            
            if let  zoneName = dict["zoneName"] as? String{
                self.ZoneName.text = zoneName
            }
            
            if let ZoneId = dict["zoneId"] as? String{
                self.ZoneId = ZoneId
            }
        }
    }
    
    
    @IBOutlet weak var NomberOfRoomsTypeCollectionView: UICollectionView!
    
    var RoomsType : [SpaceDetile] = []
    
    var SelectedAssets = [PHAsset]()
    var Images : [UIImage] = []
    var ImageUrl : [String] = []
    @IBAction func AddImages(_ sender: Any) {
        self.SelectedAssets.removeAll()
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 25
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count{
                self.SelectedAssets.append(assets[i])
                print(self.SelectedAssets)
            }
            self.getAllImages()
        }, completion: nil)
    }
    
    
    
    @IBOutlet weak var ImagesCollectionView: UICollectionView!
    
    
    func getAllImages() -> Void {
        if SelectedAssets.count != 0{
            for i in 0..<SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.Images.append(thumbnail)
                
                if IsUpdate == true{
                    if let estate = self.ComingEstate{
                        self.uploadManyImage { URLs in
                            for Url in URLs {
                                EstateImagesObjectsAPI.Add(Image: Url, Id: estate.id)
                            }
                            EstateImageObjectAPI.GetImages(Id: estate.id) { SlideImage in
                                self.CommingImages = SlideImage
                                self.ImagesCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
            self.ImagesCollectionView.reloadData()
        }
    }
    
    
    
    
        func uploadManyImage(complition : @escaping (_ URLs: [String])->()){
            var uploadedImages : [String] = []
            for one in self.Images{
                one.upload { (url) in
                    uploadedImages.append(url)
                    if self.Images.count == uploadedImages.count{
                        complition(uploadedImages)
                    }
                }
            }
        }
    
    
    var Messagee = ""
    var Actionn = ""
    var Title = ""
    var message = ""
    var action = ""
    var cancel = ""

    
    @objc func remove(sender: UIButton) {
        if IsUpdate == false{
        self.Images.remove(at: (sender.accessibilityIdentifier! as NSString).integerValue)
        self.ImagesCollectionView.reloadData()
        }else{
            self.CommingImages.removeAll()
            let stringUrl = URL(string: API.URL);
            let param: [String: Any] = [
                "key":API.key,
                "username":API.UserName,
                "fun" : "delete_estate_img_by_id",
                "id":sender.accessibilityIdentifier!
            ]
            AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                switch response.result
                {
                case .success(_):
                    let jsonData = JSON(response.data ?? "")
                     print(jsonData)
                    if let estate = self.ComingEstate{
                        EstateImageObjectAPI.GetImages(Id: estate.id) { SlideImage in
                            self.CommingImages = SlideImage
                            self.ImagesCollectionView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error);
                }
            }
        }
    }
    
    
    func Insert(_ insert : String){
        if insert == "true"{
            if XLanguage.get() == .English{
                self.Actionn = "Ok"
                self.Messagee = "Your apartment is uploaded succsesfully، We will answer you within 24 hours, thank you for waiting."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn, insert: insert)
            }
            
            if XLanguage.get() == .Arabic{
                self.Actionn = "حسنا"
                self.Messagee = "تم رفع شقتك الخاصة بك بنجاح، سنقوم بالرد عليك في غضون 24 ساعة، شكرا لك على الانتظار."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn, insert: insert)
            }
            
            if XLanguage.get() == .Kurdish{
                self.Actionn = "بەلێ"
                self.Messagee = "شوقا تە ب سەرکەفتیانە هاتنە بلند کرن، دێ بەرسڤا تە دەین د 24 دەمژمێران دا، سوپاس."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn, insert: insert)
            }
            
        }else{
            if XLanguage.get() == .English{
                self.Actionn = "Ok"
                self.Messagee = "Your apartment is not uploaded, please try later."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn, insert: insert)
            }
            
            if XLanguage.get() == .Arabic{
                self.Actionn = "حسنا"
                self.Messagee = "لم يتم رفع شقتك، يرجى المحاولة لاحقًا."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn, insert: insert)
            }
            
            if XLanguage.get() == .Kurdish{
                self.Actionn = "بەلێ"
                self.Messagee = "شوقا تە نە هاتنە بلند کرن، هیڤیە دوبارە بکە."
                self.Alert(title: "", message: self.Messagee, action: self.Actionn, insert: insert)
            }
        }
    }
    
    
    
    
    
    func empty(){
        if XLanguage.get() == .English{
            Actionn = "Ok"
            Messagee = "Please write all your informations."
            Alert(title: "", message: Messagee, action: Actionn, insert: "false")
        }
        
        if XLanguage.get() == .Arabic{
            Actionn = "حسنا"
            Messagee = "الرجاء اكتب كل المعلوماتك."
            Alert(title: "", message: Messagee, action: Actionn, insert: "false")
        }
        
        if XLanguage.get() == .Kurdish{
            Actionn = "بەلێ"
            Messagee = "هیڤیە هەمی زانیاریان بنڤیسە."
            Alert(title: "", message: Messagee, action: Actionn, insert: "false")
        }
    }
    

    func Alert(title : String , message:String , action :String ,insert : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: action, style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            if insert == "true"{
             self.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    var IsFurnished = ""
    @IBAction func Upload(_ sender: Any) {
        if IsUpdate == false{
            if  self.Images.count != 0 && self.Price.text != "" && self.Space.text != "" && self.BuildingNumber.text != "" && self.FloorNumber.text != "" && self.EstateNumber.text != "" && self.Direction.text != "" && self.NBedrooms.text != "" && self.NWashrooms.text != "" && self.NSweedenRooms.text != "" && self.NBalcony.text != "" && self.YearOfConstraction.text != "" && self.MonthlyFee.text != "" && self.latitude != "" && self.longitude != "" && self.ProjectName.text! != "" && self.ZoneName.text! != ""{
                if let UserId = UserDefaults.standard.string(forKey: "UserId"){
                    _ = LoadingView.standardProgressBox.show(inView: self.view)
                    
                    if self.Furnished.isOn == true{
                        self.IsFurnished = "furnished"
                    }else{
                        self.IsFurnished = "not furnished"
                    }
                    
                    
                    InsertEstateInfoObjectAPI.SetEstateInfo(UserID: UserId, zone_id: self.ZoneId, project_id: self.ProjectId, rent_sell: self.RentOrSell, cash_installment: self.CashOrInstalment, price: self.Price.text!, space: self.Space.text!, space_det: self.SelectedRoomtype?.title ?? "", bulding_number: self.BuildingNumber.text!, floor_number: self.FloorNumber.text!, estate_number: self.EstateNumber.text!, direction: self.Direction.text!, no_bedrooms: self.NBedrooms.text!, no_washroom: self.NWashrooms.text!, no_sweeden_room: self.NSweedenRooms.text!, no_balcon: self.NBalcony.text!, year_constraction: self.YearOfConstraction.text!, monthly_fee: self.MonthlyFee.text!, furnished:  self.IsFurnished, latitude:self.latitude, longitude: self.longitude, Disc: self.Disc.text!) { info in
                        
                        self.uploadManyImage { URLs in
                            for Url in URLs {
                                EstateImagesObjectsAPI.Add(Image: Url, Id: info[1])
                            }
                        }
                        self.Insert(info[0])
                        self.view.removeLoadingViews(animated: true)
                    }
                }
            }else{
                self.empty()
            }
        }else{
            if self.CommingImages.count != 0 && self.Price.text != "" && self.Space.text != "" && self.BuildingNumber.text != "" && self.FloorNumber.text != "" && self.EstateNumber.text != "" && self.Direction.text != "" && self.NBedrooms.text != "" && self.NWashrooms.text != "" && self.NSweedenRooms.text != "" && self.NBalcony.text != "" && self.YearOfConstraction.text != "" && self.MonthlyFee.text != ""{
                _ = LoadingView.standardProgressBox.show(inView: self.view)
                if let UserId = UserDefaults.standard.string(forKey: "UserId"){
                    _ = LoadingView.standardProgressBox.show(inView: self.view)
                    
                    if self.Furnished.isOn == true{
                        self.IsFurnished = "furnished"
                    }else{
                        self.IsFurnished = "not furnished"
                    }
                    print(self.RentOrSell)
                    print(self.CashOrInstalment)
                    if let estate = self.ComingEstate {
                        InsertEstateInfoObjectAPI.UpdateEstateInfo(EstateId:estate.id,UserID: UserId, zone_id: self.ZoneId, project_id: self.ProjectId, rent_sell: self.RentOrSell, cash_installment: self.CashOrInstalment, price: self.Price.text!, space: self.Space.text!, space_det: self.SelectedRoomtype?.title ?? "", bulding_number: self.BuildingNumber.text!, floor_number: self.FloorNumber.text!, estate_number: self.EstateNumber.text!, direction: self.Direction.text!, no_bedrooms: self.NBedrooms.text!, no_washroom: self.NWashrooms.text!, no_sweeden_room: self.NSweedenRooms.text!, no_balcon: self.NBalcony.text!, year_constraction: self.YearOfConstraction.text!, monthly_fee: self.MonthlyFee.text!, furnished:  self.IsFurnished, latitude:self.latitude, longitude: self.longitude, Disc: self.Disc.text!) { info in
                            
                            
                            self.Insert(info[0])
                            self.view.removeLoadingViews(animated: true)
                        }
                    }
                }
            }else{
                self.empty()
            }
        }
    }
}


extension AddPropertiesVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ImagesCollectionView{
            if IsUpdate == false{
                if Images.count == 0 {
                    return 0
                }
                return Images.count
            }else{
                if CommingImages.count == 0 {
                    return 0
                }
                return CommingImages.count
            }
        }
        if collectionView == NomberOfRoomsTypeCollectionView{
            if RoomsType.count == 0 {
                return 0
            }
            return RoomsType.count
        }
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ImagesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PropertiesImagesCollectionViewCell
            if IsUpdate == false{
                cell.Delete.accessibilityIdentifier = "\(indexPath.row)"
                cell.Delete.addTarget(self, action: #selector(self.remove(sender:)), for:.touchUpInside)
                cell.Imagee.image = self.Images[indexPath.row]
            }else{
                cell.Delete.accessibilityIdentifier = CommingImages[indexPath.row].id
                cell.Delete.addTarget(self, action: #selector(self.remove(sender:)), for:.touchUpInside)
                let imagrUrl = CommingImages[indexPath.row].name
                let url = URL(string: imagrUrl)
                cell.Imagee.sd_setImage(with: url, completed: nil)
            }
            return cell
        }
        if collectionView == NomberOfRoomsTypeCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ZoneCollectionViewCell
            if self.RoomsType.count != 0{
                cell.Name.text = RoomsType[indexPath.row].title
                if SelectedRoomtype?.id == self.RoomsType[indexPath.row].id{
                    cell.Vieww.backgroundColor = #colorLiteral(red: 0, green: 0.6025623679, blue: 0.9988028407, alpha: 1)
                    cell.Name.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                }else{
                    cell.Vieww.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    cell.Name.textColor = #colorLiteral(red: 0.2152355313, green: 0.2593823671, blue: 0.3063950539, alpha: 1)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == NomberOfRoomsTypeCollectionView{
            return CGSize(width: collectionView.frame.size.width / 4, height: 40)
        }
        return CGSize(width: collectionView.frame.size.width / 2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == NomberOfRoomsTypeCollectionView{
             return 0
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == NomberOfRoomsTypeCollectionView{
            self.SelectedRoomtype = self.RoomsType[indexPath.row]
            self.NomberOfRoomsTypeCollectionView.reloadData()
        }
    }
}




class SpaceDetile{
    var id = ""
    var title = ""
    
    init(id : String, title : String) {
        self.id = id
        self.title = title
    }
}



extension AddPropertiesVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        do {
//            let regex = try NSRegularExpression(pattern: "^[A-Za-z0-9ء-ي٠-٩]+$", options: [])
//            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
//                return true
//            }
//        }
//        catch {
//            print("ERROR")
//        }
//        return true
//    }
}

