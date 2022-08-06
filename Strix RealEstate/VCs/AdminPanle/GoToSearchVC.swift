//
//  GoToSearchVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 5/3/22.
//

import UIKit
import Alamofire
import SwiftyJSON


class GoToSearchVC: UIViewController , UISearchBarDelegate {
    
    var workitem = WorkItem()
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {print(text.count)
        if text.count == 0 {
            self.Array.removeAll()
            self.TableViewView.reloadData()
        }else{
            workitem.perform(after: 0.3) {print("[[[[[[[[")
                self.Array.removeAll()
                let stringUrl = URL(string: API.URL);
                let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
                let param: [String: Any] = [
                    "key":API.key,
                    "username":API.UserName,
                    "fun":"search_estate",
                    "text": text,
                    "lang":lang
                ]
                
                AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
                    switch respons.result{
                    case .success:
                        let jsonData = JSON(respons.data ?? "")
                        print(jsonData)
                            for (_,val) in jsonData{
                                let profile = ProjectObjects(id: val["id"].string ?? "", latitude: val["latitude"].string ?? "", longtitude: val["longtitude"].string ?? "", zone_id: val["zone_id"].string ?? "", title: val["title"].string ?? "", address: val["address"].string ?? "", buldings: val["buldings"].string ?? "", from_money: val["from_money"].string ?? "", to_money: val["to_money"].string ?? "", project_img: val["project_img"].string ?? "", project_vedio: val["project_vedio"].string ?? "", date: val["date"].string ?? "", zone_name: val["zone_name"].string ?? "",spaces : val["space"].string ?? "", monthly_fee: val["monthly_fee"].string ?? "")
                                self.Array.append(profile)
                            }
                            self.TableViewView.reloadData()
                    case .failure(let error):
                        print("error 520 : error while getting product in search")
                        print(error);
                    }
                }
            }
        }
        return true
    }

    
    
    lazy var searchText = UISearchBar()
    var searchPlaceHolder = "Search..."
    var Array : [ProjectObjects] = []
    @IBOutlet weak var TableViewView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchText.delegate = self
        searchText.backgroundImage = UIImage()
        self.searchText.setImage(UIImage(named: "icons8-search_filled"), for: .search, state: .normal)
            self.searchText.placeholder = self.searchPlaceHolder
        self.navigationItem.titleView = searchText
        searchText.searchTextField.font = UIFont(name: "Avenir", size: 13)
        searchText.searchTextField.textColor = UIColor.darkGray
        self.TableViewView.delegate = self
        self.TableViewView.dataSource = self
        TableViewView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.searchText.becomeFirstResponder()
    }
    
}



extension GoToSearchVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.Name.text = self.Array[indexPath.row].title
        cell.Check.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.Array.count != 0 && indexPath.row <= self.Array.count{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProjectVC") as! ProjectVC
        myVC.title = self.Array[indexPath.row].title
        myVC.ProjectComming = self.Array[indexPath.row]
        self.navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
}
