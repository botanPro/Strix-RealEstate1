//
//  classes.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import Foundation
import UIKit
import MapKit
import Alamofire
import SwiftyJSON





class  SlideShowObject {
    var id = ""
    var link = ""
    var image = ""
    
    init(id : String ,image : String , link : String) {
        self.id = id
        self.link = link
        self.image = image
    }
}

class SlideShowAPI {
    static func GetSlideImage(completion : @escaping(_ SlideImage : [SlideShowObject])->()){
        var Slide = [SlideShowObject]()
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_slides"
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                        print(jsonData)
                           for (_,val) in jsonData{
                            let slide = SlideShowObject(id: val["id"].string ?? "",image: val["image"].string ?? "", link: val["link"].string ?? "")
                               Slide.append(slide)
                           }
                           completion(Slide)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
}



class  ZoneObject {
    var id = ""
    var name = ""
    
    init(id : String , name : String) {
        self.id = id
        self.name = name
    }
}

class ZoneAPI {
    static func GetZones(completion : @escaping(_ SlideImage : [ZoneObject])->()){
        var Zones = [ZoneObject]()
        let stringUrl = URL(string: API.URL);
        let lang = UserDefaults.standard.integer(forKey: "Lang")
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun" : "get_zone",
            "lang" : lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                for (_,val) in jsonData{
                    let zone = ZoneObject(id: val["id"].string ?? "",name: val["name"].string ?? "")
                    Zones.append(zone)
                }
                completion(Zones)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetEstateByZone(Id : String ,completion : @escaping(_ user : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_estate_by_zone_id",
                   "id" : Id,
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       print("[]][][][][]]")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon:     val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
}






class  EstateImageObject {
    var id = ""
    var name = ""
    
    init(id : String , name : String) {
        self.id = id
        self.name = name
    }
}

class EstateImageObjectAPI {
    static func GetImages(Id : String,completion : @escaping(_ SlideImage : [EstateImageObject])->()){
        var images = [EstateImageObject]()
        let stringUrl = URL(string: API.URL);
        //let lang = UserDefaults.standard.integer(forKey: "Lang")
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun" : "get_estate_img",
            "id" : Id
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                for (_,val) in jsonData{
                    let image = EstateImageObject(id: val["id"].string ?? "",name: val["image"].string ?? "")
                    images.append(image)
                }
                completion(images)
            case .failure(let error):
                print(error);
            }
        }
    }
    
}





class ProjectObjects{
    
    var id = ""
    var latitude = "0.0"
    var longtitude = "0.0"
    var zone_id = "0"
    var title = ""
    var address = ""
    var buldings = ""
    var from_money = "0.0"
    var to_money = "0.0"
    var project_img = ""
    var project_vedio = ""
    var date = ""
    var zone_name = ""
    var spaces = ""
    var monthly_fee = ""
    
    init(id : String , latitude : String , longtitude : String,zone_id : String , title : String , address : String,buldings : String , from_money : String , to_money : String, project_img : String , project_vedio : String,date : String , zone_name : String,spaces : String , monthly_fee : String) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.id = id
        self.zone_id = zone_id
        self.title = title
        self.address = address
        self.buldings = buldings
        self.from_money = from_money
        self.to_money = to_money
        self.project_img = project_img
        self.project_vedio = project_vedio
        self.date = date
        self.zone_name = zone_name
        self.spaces = spaces
        self.monthly_fee = monthly_fee
    }
    
    
}

class ProjectApi{
  
    static func GetAllProjects(completion : @escaping(_ projects : [ProjectObjects])->()){
        var projects = [ProjectObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_all_project",
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       print("-----------------------------------------------------------")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let project = ProjectObjects(id: val["id"].string ?? "", latitude: val["latitude"].string ?? "", longtitude: val["longtitude"].string ?? "", zone_id: val["zone_id"].string ?? "", title: val["title"].string ?? "", address: val["address"].string ?? "", buldings: val["buldings"].string ?? "", from_money: val["from_money"].string ?? "", to_money: val["to_money"].string ?? "", project_img: val["project_img"].string ?? "", project_vedio: val["project_vedio"].string ?? "", date: val["date"].string ?? "", zone_name: val["zone_name"].string ?? "",spaces:val["space"].string ?? "", monthly_fee: val["monthly_fee_pro"].string ?? "")
                               projects.append(project)
                           }
                           completion(projects)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
    

    
    
    
    
    static func GetEstateByProjectId(Id : String ,completion : @escaping(_ user : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_estate_by_project_id",
                   "id" : Id,
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       
                       print("Hello, World")
                       
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon:     val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
}













class EstateObjects{
    
    var id = ""
    var rent_sell = "0.0"
    var cash_installment = "0.0"
    var price = "0"
    var space = ""
    var disc = ""
    var space_det = ""
    var bulding_number = ""
    var floor_number = "0.0"
    var estate_number = "0.0"
    var direction = ""
    var no_bedrooms = ""
    var no_washroom = ""
    var no_sweeden_room = ""
    
    var no_balcon = "0.0"
    var year_constraction = "0"
    var monthly_fee = ""
    var furnished = ""
    var latitude = ""
    var longitude = "0.0"
    var project_title = "0.0"
    var zone_name = ""
    var image = ""
    var date = ""
    var estate_vedio = ""
    var active = ""
    var zone_id = ""
    var project_id = ""
    
    init(id : String , rent_sell : String , cash_installment : String,price : String , space : String , space_det : String,bulding_number : String , floor_number : String , estate_number : String, direction : String , no_bedrooms : String,no_washroom : String , no_sweeden_room : String
         , no_balcon : String , year_constraction : String,monthly_fee : String , furnished : String , latitude : String, longitude : String , project_title : String,zone_name : String , image : String,date : String,estate_vedio : String,zone_id : String,project_id : String,active:String,disc:String) {
        self.rent_sell = rent_sell
        self.cash_installment = cash_installment
        self.id = id
        self.price = price
        self.space = space
        self.space_det = space_det
        self.bulding_number = bulding_number
        self.floor_number = floor_number
        self.estate_number = estate_number
        self.direction = direction
        self.no_bedrooms = no_bedrooms
        self.no_washroom = no_washroom
        self.no_sweeden_room = no_sweeden_room
        
        self.no_balcon = no_balcon
        self.year_constraction = year_constraction
        self.monthly_fee = monthly_fee
        self.furnished = furnished
        self.bulding_number = bulding_number
        self.latitude = latitude
        self.longitude = longitude
        self.project_title = project_title
        self.zone_name = zone_name
        self.image = image
        self.date = date
        self.estate_vedio = estate_vedio
        self.active = active
        self.zone_id = zone_id
        self.project_id = project_id
        self.disc = disc
    }
    
    
}

class EstateApi{
  
    static func GetAllEstate(completion : @escaping(_ estates : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_all_estate",
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       print("[]][][][][]]")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon: val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
    
    static func GetHomeEstate(Start:Int,Limit: Int,completion : @escaping(_ estates : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_home_estate",
                   "lang":lang,
                   "start":Start,
                   "limit":Limit
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       print("[]][][][][]]")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon: val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
    
    
    
    
    
    static func GetRelated(Id : String ,completion : @escaping(_ user : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_related_estate_by_estate_id",
                   "id" : Id,
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon:     val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
    
    
    static func GetEstateByUserId(Id : String ,completion : @escaping(_ user : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_estate_by_user_id",
                   "id" : Id,
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       print("==============================================================")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon:     val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
    
    
    static func GetSaved(Id : String ,completion : @escaping(_ user : [EstateObjects])->()){
        var Estates = [EstateObjects]()
        let lang = UserDefaults.standard.integer(forKey: "Lang")
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_saved",
                   "id" : Id,
                   "lang":lang
               ]
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                        print(jsonData)
                           for (_,val) in jsonData{
                               let estate = EstateObjects(id:  val["id"].string ?? "", rent_sell:  val["rent_sell"].string ?? "", cash_installment:  val["cash_installment"].string ?? "", price:  val["price"].string ?? "", space:  val["space"].string ?? "", space_det:     val["space_det"].string ?? "", bulding_number:  val["bulding_number"].string ?? "", floor_number:  val["floor_number"].string ?? "",   estate_number:  val["estate_number"].string ?? "", direction:  val["direction"].string ?? "", no_bedrooms:  val["no_bedrooms"].string ?? "", no_washroom:  val["no_washroom"].string ?? "", no_sweeden_room:  val["no_sweeden_room"].string ?? "", no_balcon:     val["no_balcon"].string ?? "", year_constraction:  val["year_constraction"].string ?? "", monthly_fee:  val["monthly_fee"].string ?? "",   furnished:  val["furnished"].string ?? "", latitude:  val["latitude"].string ?? "", longitude:  val["longitude"].string ?? "",    project_title:  val["project_title"].string ?? "", zone_name:  val["zone_name"].string ?? "", image:  val["image"].string ?? "",date: val["date"].string ?? "", estate_vedio: val["estate_vedio"].string ?? "",zone_id: val["zone_id"].string ?? "", project_id: val["project_id"].string ?? "",active:val["active"].string ?? "",disc:val["disc"].string ?? "")
                               Estates.append(estate)
                           }
                           completion(Estates)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
}







class EstateImagesObjects{
    
    var id = ""
    var name = ""
    var image = ""
    
    
    init(id : String , name : String , image : String) {
        self.id  = id
        self.name = name
        self.image = image
    }
    
    
}


class EstateImagesObjectsAPI{
    static func Add(Image : String ,Id : String){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "estate_id":Id,
            "fun":"add_estate_img",
            "image":Image
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
            case .failure(let error):
                print(error);
            }
        }
    }
}



class UserObjects{
    
    var id = ""
    var full_name = ""
    var address = ""
    
    var phone1 = ""
    var phone2 = ""
    var about_me = ""
    
    var img = ""
    var fire_id = ""
    
    var IsArchived = ""
    
    
    var option = ""
    
    init(id : String , name : String , image : String,phone1 : String , phone2 : String , about_me : String, fire_id : String , address : String, IsArchived : String, option : String) {
        self.id  = id
        self.full_name = name
        self.img = image
        self.address = address
        self.phone1 = phone1
        self.phone2 = phone2
        self.fire_id = fire_id
        self.about_me = about_me
        self.IsArchived = IsArchived
        self.option = option
    }
    
    
}


class UserObjectsAPI{
    static func GetUserInfo(FirebaseId : String ,completion : @escaping(_ user : UserObjects)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "id":FirebaseId,
            "fun":"get_profile_by_fire_id"
        ]
        var user : UserObjects?
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                for (_,val) in jsonData{
                    user = UserObjects(id: val["id"].string ?? "", name:  val["full_name"].string ?? "", image: val["img"].string ?? "", phone1:  val["phone1"].string ?? "", phone2:  val["phone1"].string ?? "", about_me:  val["about_me"].string ?? "", fire_id:  val["fire_id"].string ?? "", address:  val["address"].string ?? "" , IsArchived : val["archive"].string ?? "",option: val["options"].string ?? "")
                    
                }
                completion(user ?? UserObjects(id:"", name:"", image:"", phone1:"", phone2:"", about_me:"", fire_id:"", address:"",IsArchived : "",option: ""))
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func SetUserInfo(full_name : String,address:String , phone1 : String , phone2 : String , about_me : String , img : String, fire_id : String ,id : String,completion : @escaping (_ Info : String)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"set_profile",
            "full_name":full_name,
            "address":address,
            "phone1":phone1,
            "phone2":phone2,
            "about_me":about_me,
            "img":img,
            "fire_id":fire_id,
            "id":id
            ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                completion(jsonData["insert"].string ?? "")
                print(jsonData)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func SaveUnSave(add_dell : String,saved_pro_id:String ,id : String,completion : @escaping (_ Info : String)->()){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"add_dell_saved",
            "saved_pro_id":saved_pro_id,
            "add_dell":add_dell,
            "id":id
            ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                completion(jsonData["insert"].string ?? "")
                print(jsonData)
            case .failure(let error):
                print(error);
            }
        }
    }
}











class InsertEstateInfoObjectAPI {
    static func SetEstateInfo(UserID : String,zone_id:String , project_id : String , rent_sell : String , cash_installment : String , price : String, space : String , space_det : String , bulding_number : String , floor_number : String , estate_number : String ,direction : String , no_bedrooms : String , no_washroom : String , no_sweeden_room : String, no_balcon : String , year_constraction : String ,monthly_fee : String , furnished : String , latitude : String , longitude : String,Disc:String,completion : @escaping (_ Info : [String])->()){
        
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"add_estate",
            "zone_id":zone_id,
            "project_id":project_id,
            "rent_sell":rent_sell,
            "cash_installment":cash_installment,
            "price":price,
            "space":space,
            "space_det":space_det,
            "bulding_number":bulding_number,
            "floor_number":floor_number,
            "estate_number":estate_number,
            "direction":direction,
            "no_bedrooms":no_bedrooms,
            "no_washroom":no_washroom,
            "no_sweeden_room":no_sweeden_room,
            "no_balcon":no_balcon,
            "year_constraction":year_constraction,
            "monthly_fee":monthly_fee,
            "furnished":furnished,
            "latitude":latitude,
            "longitude":longitude,
            "disc":Disc,
            "user_id":UserID
            ]

        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    print(jsonData)
                    completion([jsonData["insert"].string ?? "",jsonData["id"].string ?? ""])
                }
            case .failure(let error):
                print("error 404 : error while Inserting User Informations")
                print(error);
            }
        }
    }
    
    
    static func UpdateEstateInfo(EstateId : String,UserID : String,zone_id:String , project_id : String , rent_sell : String , cash_installment : String , price : String, space : String , space_det : String , bulding_number : String , floor_number : String , estate_number : String ,direction : String , no_bedrooms : String , no_washroom : String , no_sweeden_room : String, no_balcon : String , year_constraction : String ,monthly_fee : String , furnished : String , latitude : String , longitude : String,Disc:String,completion : @escaping (_ Info : [String])->()){
        
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"edit_estate",
            "zone_id":zone_id,
            "project_id":project_id,
            "rent_sell":rent_sell,
            "cash_installment":cash_installment,
            "price":price,
            "space":space,
            "space_det":space_det,
            "bulding_number":bulding_number,
            "floor_number":floor_number,
            "estate_number":estate_number,
            "direction":direction,
            "no_bedrooms":no_bedrooms,
            "no_washroom":no_washroom,
            "no_sweeden_room":no_sweeden_room,
            "no_balcon":no_balcon,
            "year_constraction":year_constraction,
            "monthly_fee":monthly_fee,
            "furnished":furnished,
            "latitude":latitude,
            "longitude":longitude,
            "user_id":UserID,
            "disc":Disc,
            "id":EstateId
            ]

        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    print(jsonData)
                    completion([jsonData["insert"].string ?? "",jsonData["id"].string ?? ""])
                }
            case .failure(let error):
                print("error 404 : error while Inserting User Informations")
                print(error);
            }
        }
    }
    
    
}











extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

//m2
extension NSMutableAttributedString
{
    enum scripting : Int
    {
        case aSub = -1
        case aSuper = 1
    }
    
    func characterSubscriptAndSuperscript(string:String,
                                          characters:[Character],
                                          type:scripting,
                                          fontSize:CGFloat,
                                          scriptFontSize:CGFloat,
                                          offSet:Int,
                                          length:[Int],
                                          alignment:NSTextAlignment)-> NSMutableAttributedString
    {
        let paraghraphStyle = NSMutableParagraphStyle()
        // Set The Paragraph aligmnet , you can ignore this part and delet off the function
        paraghraphStyle.alignment = alignment
        
        var scriptedCharaterLocation = Int()
        //Define the fonts you want to use and sizes
        let stringFont = UIFont.boldSystemFont(ofSize: fontSize)
        let scriptFont = UIFont.boldSystemFont(ofSize: scriptFontSize)
        // Define Attributes of the text body , this part can be removed of the function
        let attString = NSMutableAttributedString(string:string, attributes: [NSAttributedString.Key.font:stringFont,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.paragraphStyle: paraghraphStyle])
        
        // the enum is used here declaring the required offset
        let baseLineOffset = offSet * type.rawValue
        // enumerated the main text characters using a for loop
        for (i,c) in string.enumerated()
        {
            // enumerated the array of first characters to subscript
            for (theLength,aCharacter) in characters.enumerated()
            {
                if c == aCharacter
                {
                    // Get to location of the first character
                    scriptedCharaterLocation = i
                    //Now set attributes starting from the character above
                    attString.setAttributes([NSAttributedString.Key.font:scriptFont,
                                             // baseline off set from . the enum i.e. +/- 1
                                             NSAttributedString.Key.baselineOffset:baseLineOffset,
                                             NSAttributedString.Key.foregroundColor:UIColor.black],
                                            // the range from above location
                                            range:NSRange(location:scriptedCharaterLocation,
                                                          // you define the length in the length array
                                                          // if subscripting at different location
                                                          // you need to define the length for each one
                                                          length:length[theLength]))
                    
                }
            }
        }
        return attString}
}









import CoreLocation

class XLocations : NSObject , CLLocationManagerDelegate{
    
    static var Shared = XLocations()
    
    var LocationManager : CLLocationManager!
    
    func GetUserLocation(){
        
        LocationManager = CLLocationManager()
        
        LocationManager.delegate = self
        
        LocationManager.requestWhenInUseAuthorization()
        
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if CLLocationManager.locationServicesEnabled(){
           LocationManager.startUpdatingLocation()
        }
        
        

    }
    
    var longtude : Double = 0
    var latitude : Double = 0
    var GotLocation : (()->())?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.longtude = locations[0].coordinate.longitude
        self.latitude = locations[0].coordinate.latitude
        
        GotLocation?()
        
    }
    
}





@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}





extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
}


extension String {
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"

            formatter.maximumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return "\(str)"
            }
        }
        return ""
    }
    
    func currencyFormattingWithoutIQD() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            formatter.numberStyle = .currency
            formatter.currencySymbol = "IQD"

            formatter.maximumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return "\(str)"
            }
        }
        return ""
    }
}



class WorkItem {

    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func perform(after: TimeInterval, _ block: @escaping () -> Void) {
        // Cancel the currently pending item
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem(block: block)
        
        pendingRequestWorkItem = requestWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
    }
}


class UIXTabBarStyle : UITabBar{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
  
    }
    

}





class UpdateOneSignalIdAPI{
    static func Update(onesignalUUID : String , userId : String){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "id":userId,
            "fun":"set_onesignal",
            "one_id":onesignalUUID
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
            case .failure(let error):
                print("error 420 : error while getting onesignal UUID")
                print(error);
            }
        }
    }
}

