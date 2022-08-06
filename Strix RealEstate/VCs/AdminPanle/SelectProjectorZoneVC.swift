//
//  SelectProjectorZoneVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/21/22.
//

import UIKit
import CRRefresh
class SelectProjectorZoneVC: UIViewController {


    var Array : [ProjectObjects] = []
    var Array2 : [ZoneObject] = []
    
    var IsProjectOrZone = true
    @IBOutlet weak var TableView: UITableView!{didSet{ self.GetAllProjects();  self.GetZones()}}
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        if IsProjectOrZone == true{
            self.TableView.cr.addHeadRefresh {
                self.GetAllProjects()
            }
        }else{
            self.TableView.cr.addHeadRefresh {
                self.GetZones()
            }
        }
        
    }

    func GetAllProjects(){
        self.Array.removeAll()
        ProjectApi.GetAllProjects { projects in
            self.Array = projects
            self.TableView.cr.endHeaderRefresh()
            self.TableView.reloadData()
        }
    }
    
    
    func GetZones(){
        self.Array2.removeAll()
        ZoneAPI.GetZones { zones in
            self.Array2 = zones
            self.TableView.cr.endHeaderRefresh()
            self.TableView.reloadData()
        }
    }

}





extension SelectProjectorZoneVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if IsProjectOrZone == true{
            if Array.count == 0{
                return 0
            }
            return Array.count
        }else{
            if Array2.count == 0{
                return 0
            }
            return Array2.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.Check.isHidden = true
        if IsProjectOrZone == true{
            cell.Name.text = self.Array[indexPath.row].title
        }else{
            cell.Name.text = self.Array2[indexPath.row].name
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.Array.count != 0 && indexPath.row <=  self.Array.count{
        if IsProjectOrZone == true{
            let Data:[String: String] = ["projectName": self.Array[indexPath.row].title , "projectId":self.Array[indexPath.row].id]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProjectComming"), object: nil, userInfo: Data)
        }else{
            let Data:[String: String] = ["zoneName": self.Array2[indexPath.row].name , "zoneId":self.Array2[indexPath.row].id]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ZoneComming"), object: nil, userInfo: Data)
        }
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}
