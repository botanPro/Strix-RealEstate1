//
//  LanguageVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/2/22.
//

import UIKit

class LanguageVC: UIViewController {

   
    var LanguagesArray : [languages] = []
    @IBOutlet weak var TableView: UITableView!{didSet{self.TableView.delegate = self ; self.TableView.dataSource = self}}
    var Titlee = ""
    var Messagee = ""
    var Actionn = ""
    var Actionn2 = ""
    var IsSelected = false
    var selectedLang : languages?
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        if lang == 1{
            Actionn = "Restart"
            Actionn2 = "later"
            Messagee = "Restart application, do you want to restart?"
            Titlee = "Language"
            self.LanguagesArray.append(languages(lang: "English", id: 1))
            self.LanguagesArray.append(languages(lang: "Arabic", id: 2))
            self.LanguagesArray.append(languages(lang: "Kurdish", id: 3))
        }
        
        if lang == 2{
            Actionn = "اعادة تشغيل"
            Actionn2 = "ليس الان"
            Messagee = "إعادة تشغيل التطبيق، هل تريد إعادة التشغيل؟"
            Titlee = "اللغة"
            self.LanguagesArray.append(languages(lang: "إنجليزي", id: 1))
            self.LanguagesArray.append(languages(lang: "العربية", id: 2))
            self.LanguagesArray.append(languages(lang: "الكردية", id: 3))
        }
        
        if lang == 3{
            Actionn = "بەلێ"
            Actionn2 = "نەخێر"
            Messagee = "بو گهورینا زمانی پێتڤیە بەرنامج دوبارە بهێتە کارپێکرن،تە دڤێت دوبارە بەرنامج بهێتە کارپێکرن؟ "
            Titlee = "زمان"
            self.LanguagesArray.append(languages(lang: "ئینگلیزی", id: 1))
            self.LanguagesArray.append(languages(lang: "عەرەبی", id: 2))
            self.LanguagesArray.append(languages(lang: "کوردی", id: 3))
        }
        
        self.TableView.reloadData()
    }
    
}

extension LanguageVC : UITableViewDelegate , UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if LanguagesArray.count == 0 {
            return 0
        }
        return LanguagesArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell

        if LanguagesArray.count != 0{
            cell.Name.text = self.LanguagesArray[indexPath.row].lang
          
            if selectedLang?.id == self.LanguagesArray[indexPath.row].id  && self.IsSelected == true{
                if self.LanguagesArray[indexPath.row].id == 1{
                    cell.Check.isHidden = false
                }else if self.LanguagesArray[indexPath.row].id == 2{
                    cell.Check.isHidden = false
                }else {
                    cell.Check.isHidden = false
                }
               
            }else{
                cell.Check.isHidden = true
            }
            
            
            if self.LanguagesArray[indexPath.row].id == UserDefaults.standard.integer(forKey: "Lang") && self.IsSelected == false{
                cell.Check.isHidden = false
            }else {
                cell.Check.isHidden = true
            }
        }
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if LanguagesArray.count != 0 && indexPath.row <= LanguagesArray.count{
            
            if self.LanguagesArray[indexPath.row].id == 1{
                self.selectedLang = self.LanguagesArray[indexPath.row]
        
                Alert(title: Titlee, message: Messagee, action: Actionn, action2: Actionn2, LangId: self.LanguagesArray[indexPath.row].id)
            }else if self.LanguagesArray[indexPath.row].id == 2{
                self.selectedLang = self.LanguagesArray[indexPath.row]
                
                Alert(title: Titlee, message: Messagee, action: Actionn, action2: Actionn2, LangId: self.LanguagesArray[indexPath.row].id)
            }else {
                self.selectedLang = self.LanguagesArray[indexPath.row]
               
                Alert(title: Titlee, message: Messagee, action: Actionn, action2: Actionn2, LangId: self.LanguagesArray[indexPath.row].id)
            }
            
        }
        
    }
    
    
    
    
    func Alert(title : String , message:String , action :String , action2:String,LangId : Int){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: action, style: UIAlertAction.Style.default) {
            UIAlertAction in
            UserDefaults.standard.set(LangId, forKey: "Lang")
            if LangId == 1{
                //UIView.appearance().semanticContentAttribute = .forceLeftToRight
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVc") as? TabBarVC
                let appDelegate = UIApplication.shared.delegate?.window as? UIWindow
                appDelegate?.rootViewController = vc
                XLanguage.set(Language: .English)
            }else if LangId == 2{
                //UIView.appearance().semanticContentAttribute = .forceRightToLeft
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVc") as? TabBarVC
                let appDelegate = UIApplication.shared.delegate?.window as? UIWindow
                appDelegate?.rootViewController = vc
                XLanguage.set(Language: .Arabic)
            }else{
                //UIView.appearance().semanticContentAttribute = .forceRightToLeft
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVc") as? TabBarVC
                let appDelegate = UIApplication.shared.delegate?.window as? UIWindow
                appDelegate?.rootViewController = vc
                XLanguage.set(Language: .Kurdish)
            }
            
            self.IsSelected = true
            self.TableView.reloadData()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVc")
            vc!.modalPresentationStyle = .overFullScreen
            vc!.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: action2, style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func callSegueFromProduct(myData: Int , CatId : Int) {
       
        
    }
    
    
    
}

class languages{
    var lang = ""
    var id = 0
    
    init(lang : String , id : Int) {
        self.id = id
        self.lang = lang
    }
}
