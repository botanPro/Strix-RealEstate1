//
//  SearchVC.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import UIKit
import EFInternetIndicator

class SearchVC: UIViewController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
//https://dribbble.com/shots/11880927-FlyLine-Flight-Booking-App
    
    
    
    
    @IBOutlet weak var ShowFilter: UIBarButtonItem!
    
    
    @IBAction func ShowFilter(_ sender: Any) {
        
    }
    
    
    @IBAction func SearchStackAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToSearchVC") as! GoToSearchVC
        myVC.title = title
        self.navigationController?.pushViewController(myVC, animated: false)
    }
    
    
    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBOutlet weak var HomeTitle: UIBarButtonItem!
    @IBOutlet weak var ProjectCollectionView: UICollectionView!
    @IBOutlet weak var ProjectCollectionViewHeight: NSLayoutConstraint!
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    var ProjectArray : [ProjectObjects] = []
    
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchTextField.isEnabled = false
        SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        SearchView.layer.shadowOpacity = 1
        SearchView.layer.shadowOffset = CGSize.zero
        SearchView.layer.shadowRadius = 8
        
        
        self.ScrollView.delegate = self
        
        
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.standardAppearance.backgroundEffect = nil
        self.navigationController?.navigationBar.standardAppearance.shadowImage = UIImage()
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance.backgroundImage = UIImage()
        
    
        HomeTitle.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: "rudawregular", size: 24)!,
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ], for: .normal)
        
        ProjectCollectionView.register(UINib(nibName: "SearchProjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        
        GetAllProjects()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.startMonitoringInternet()
        if CheckInternet.Connection() == false{
            self.ScrollView.isHidden = true
            self.Refreash.isHidden = false
        }else{
            GetAllProjects()
            self.ScrollView.isHidden = false
            self.Refreash.isHidden = true
        }
    }
    
    @IBOutlet weak var Refreash: UIButton!
    
    @IBAction func Refreash(_ sender: Any) {
        if CheckInternet.Connection() == true{
            GetAllProjects()
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
    
    
    func GetAllProjects(){
        self.ProjectArray.removeAll()
        ProjectApi.GetAllProjects { projects in
            self.ProjectArray = projects
            self.ProjectCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.1, delay: 0) {
                let height = self.ProjectCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.ProjectCollectionViewHeight.constant = height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 100
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)

       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
    
    
    
    
}


extension SearchVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ProjectArray.count == 0 {
            return 0
        }
        return ProjectArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchProjectCollectionViewCell
        cell.update(self.ProjectArray[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.ProjectArray.count != 0 && indexPath.row <= self.ProjectArray.count{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "ProjectVC") as! ProjectVC
            myVC.title = self.ProjectArray[indexPath.row].title
            myVC.ProjectComming = self.ProjectArray[indexPath.row]
            self.navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
}


