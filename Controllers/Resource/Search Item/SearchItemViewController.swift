//
//  SearchItemViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 2/13/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import SDLoader




class SearchItemViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate  {
    
    var api_name = String()
    var isFrom = String()
    
    var tableData = [[String:String]]()
    var filteredData = [[String:String]]()
    let sdLoader = SDLoader()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var onCompletion: ((_ id: String , _ country: String) -> Void)? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = ServerHandler()
        self.searchBar.delegate = self
        
        if isFrom == "SERVICE" {
            
            service.getResponseFromServer(parametrs: api_name, completion: { (result) in
                let status = result["success"] as? String ?? ""
                if status == "1"{
                    self.tableData = result["category_list"] as! [[String : String]]
                    self.filteredData = result["category_list"] as! [[String : String]]
                    self.tableview.reloadData()
                }else{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: result["message"] as? String ?? "") { (index, title) in
                        print(index,title)
                    }
                }
            })
        }
        else{
            
            service.getResponseFromCountryApi(parametrs: api_name, completion: { (results) in
                
                self.tableData = results
                self.filteredData = results
                self.tableview.reloadData()
            })
        }
        
    }
    


   
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:
    //MARK: - -----------UISearchBar Delegates-----------
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        self.filteredData = searchText.isEmpty ? self.tableData : self.tableData.filter { (dataArray:[String:String]) -> Bool in
            
            if isFrom == "COUNTRY" {
                return ((dataArray["country_name"]?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)) != nil)
            }
            else if isFrom == "STATE" {
                return ((dataArray["state_name"]?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)) != nil)
            }
            else if isFrom == "CITY" {
                return ((dataArray["city_name"]?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)) != nil)
            }
            else if isFrom == "SERVICE" {
                return ((dataArray["name"]?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)) != nil)
            }
            else{
                return false
            }
        }
        self.tableview.reloadData()
    }
   
    
    
    //MARK:
    //MARK: - -----------UITableViewDelegate & UITableViewDataSource-----------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if !(cell != nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
        }
        
        let dict = filteredData[indexPath.row]
        
        if isFrom == "COUNTRY" {
            cell?.textLabel?.text = dict["country_name"] ?? ""
        }
        else if isFrom == "STATE" {
            cell?.textLabel?.text = dict["state_name"] ?? ""
        }
        else if isFrom == "CITY" {
            cell?.textLabel?.text = dict["city_name"] ?? ""
        }
        else if isFrom == "SERVICE" {
            cell?.textLabel?.text = dict["name"] ?? ""
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: {
            
            let dict = self.filteredData[indexPath.row]
            
            var _id : String = ""
            var _data : String = ""
            
            if self.isFrom == "COUNTRY" {
                
                _id = dict["country_id"] ?? ""
                _data = dict["country_name"] ?? ""
            }
            else if self.isFrom == "STATE" {
                
                _id = dict["state_id"] ?? ""
                _data = dict["state_name"] ?? ""
            }
            else if self.isFrom == "CITY" {
                
                _id = dict["city_id"] ?? ""
                _data = dict["city_name"] ?? ""
            }
            else if self.isFrom == "SERVICE" {
                
                _id = dict["id"] ?? ""
                _data = dict["name"] ?? ""
            }
            
            if (self.onCompletion != nil) {
                self.onCompletion!( _id as String, _data as String)
            }
            
        })
    }
    

}
