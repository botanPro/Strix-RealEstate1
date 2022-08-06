//
//  FilterVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/28/22.
//

import UIKit
import SmoothPicker
import Slider2
import MBRadioCheckboxButton
import Alamofire
import SwiftyJSON

class FilterVC: UIViewController , RadioButtonDelegate{
    
    
    var RentOrSell = "rent"
    func radioButtonDidSelect(_ button: RadioButton) {
        print("select  : \(button.tag)")
        if button.tag == 1{
            self.RentOrSell = "sell"
        }else{
            self.RentOrSell = "rent"
        }
    }
    func radioButtonDidDeselect(_ button: RadioButton) {
        print("Dselect  : \(button.tag)")
    }
    
    
    
    
    
    @IBOutlet weak var a1: LanguageLable!
    @IBOutlet weak var a2: LanguageLable!
    @IBOutlet weak var a3: LanguageLable!
    
    
    
    
    
    
    
    
    @IBOutlet weak var ZoneCollectionView: UICollectionView!
    
    
    @IBAction func SpovSlider(_ sender: Slider2) {
        MinLable.text = "$\(sender.value) "
        MaxLable.text = "$\(sender.value2)"
        
        self.MinPrice = "\(sender.value) "
        self.MaxPrice = "\(sender.value2)"
    }
    var MinPrice = "0"
    var MaxPrice = "0"
    @IBOutlet weak var PickerView: SmoothPickerView!
    var selecteCell : ZoneObject?
    var ZoneArray : [ZoneObject] = []
    @IBOutlet weak var MaxLable: UILabel!
    @IBOutlet weak var MinLable: UILabel!
    
    @IBOutlet weak var viewGroup2: RadioButtonContainerView!
    var SelectedNORooms = 0
    var NumberOfRooms = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        
        if lang == 2 || lang == 3{
            self.a1.textAlignment = .right
            self.a2.textAlignment = .right
            self.a3.textAlignment = .right
        }
        
        
        ZoneCollectionView.register(UINib(nibName: "ZoneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        for i in 1..<7 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            view.layer.cornerRadius = 6
            view.backgroundColor = #colorLiteral(red: 0.931279242, green: 0.931279242, blue: 0.931279242, alpha: 1)
            view.layer.borderColor = #colorLiteral(red: 0.2632661164, green: 0.3186239004, blue: 0.7541932464, alpha: 1)
            view.layer.borderWidth = 1.2
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            label.textAlignment = .center
            label.text = "\(i)"
            label.textColor = #colorLiteral(red: 0.4486939907, green: 0.2383579016, blue: 0.3201408982, alpha: 1)
            view.addSubview(label)
            NumberOfRooms.append(view)
        }
        
        
        if lang == 2{
            self.RentRadioButton.setTitle("اجار")
            self.SellRadioButton.setTitle("بیع")
        }else if lang == 3{
            self.RentRadioButton.setTitle("کرێ")
            self.SellRadioButton.setTitle("فروشتن")
        }
        
        GetZones()
        PickerView.firstselectedItem = 3
        setupGroup2()
    }
    
    func GetZones(){
        self.ZoneArray.removeAll()
        ZoneAPI.GetZones { zones in
            self.ZoneArray = zones
            self.ZoneCollectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var RentRadioButton: RadioButton!
    @IBOutlet weak var SellRadioButton: RadioButton!
    

    var group3Container = RadioButtonContainer()
    func setupGroup2() {
        viewGroup2.buttonContainer.delegate = self
        viewGroup2.buttonContainer.setEachRadioButtonColor {
            return RadioButtonColor(active: $0.tintColor , inactive: $0.tintColor)
        }
        group3Container.addButtons([RentRadioButton, SellRadioButton])
        group3Container.delegate = self
        group3Container.selectedButton = RentRadioButton
    }

    var Estates : [EstateObjects] = []
    @IBAction func ShowResult(_ sender: Any) {
        self.Estates.removeAll()
        let stringUrl = URL(string: API.URL);
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"estate_filter",
            "min_price": 0,
            "max_price":self.MaxPrice,
            "room":self.SelectedNORooms,
            "zone": self.selecteCell?.id ?? "",
            "lang":lang,
            "rent_sell": self.RentOrSell
        ]
        print(self.MinPrice)
        print(self.MaxPrice)
            print(self.SelectedNORooms)
                print(self.selecteCell?.id ?? "0")
                    print(self.RentOrSell)
        print(lang)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon:     val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                        self.Estates.append(estate)
                    }
                self.performSegue(withIdentifier: "Next", sender: self.Estates)
            case .failure(let error):
                print("error 520 : error while getting product in search")
                print(error);
            }
        }
    }
    
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let estate = sender as? [EstateObjects]{
            if let next = segue.destination as? AllEstatesVC{
                next.AllEstate = estate
            }
        }
    }
    
}



extension FilterVC : SmoothPickerViewDelegate, SmoothPickerViewDataSource{
    func didSelectItem(index: Int, view: UIView, pickerView: SmoothPickerView) {
        self.SelectedNORooms = index + 1
        print("SelectedIndex \(index + 1)")
    }
    
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        return NumberOfRooms.count
    }
    
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        return NumberOfRooms[index]
    }
    
}

extension FilterVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ZoneArray.count == 0 {
            return 0
        }
        return ZoneArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ZoneCollectionViewCell
        if self.ZoneArray.count != 0{
            cell.Name.text = ZoneArray[indexPath.row].name
            
            if self.selecteCell?.id == ZoneArray[indexPath.row].id{
                cell.Vieww.backgroundColor = #colorLiteral(red: 0.931279242, green: 0.931279242, blue: 0.931279242, alpha: 1)
                cell.Name.textColor = #colorLiteral(red: 0.506865561, green: 0.506865561, blue: 0.506865561, alpha: 1)
                cell.Vieww.layer.borderColor = #colorLiteral(red: 0.2632661164, green: 0.3186239004, blue: 0.7541932464, alpha: 1)
                cell.Vieww.layer.borderWidth = 1.4
            }else{
                cell.Vieww.backgroundColor = #colorLiteral(red: 0.931279242, green: 0.931279242, blue: 0.931279242, alpha: 1)
                cell.Name.textColor = #colorLiteral(red: 0.506865561, green: 0.506865561, blue: 0.506865561, alpha: 1)
                cell.Vieww.layer.borderColor = #colorLiteral(red: 0.506865561, green: 0.506865561, blue: 0.506865561, alpha: 1)
                cell.Vieww.layer.borderWidth = 0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width / 4, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
             return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.ZoneArray.count != 0 && indexPath.row <= self.ZoneArray.count{
            self.selecteCell = self.ZoneArray[indexPath.row]
            self.ZoneCollectionView.reloadData()
        }
    }
}

