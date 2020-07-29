//
//  NestedJSONViewController.swift
//  ParseJSONSwiftyJSONExample
//
//  Created by John Codeos on 6/16/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import SwiftyJSON
import UIKit

class NestedJSONViewController: UIViewController {
    @IBOutlet var jsonResultsTextView: UITextView!
    
    @IBOutlet var parseJsonButton: UIButton!
    @IBOutlet var jsonResultsTableView: UITableView!
    
    var employeeArray: [NestedJSONModel] = [NestedJSONModel]()
    
    var jsonData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView Customization
        jsonResultsTableView.separatorColor = .white
        jsonResultsTableView.separatorStyle = .singleLine
        jsonResultsTableView.tableFooterView = UIView()
        jsonResultsTableView.allowsSelection = false
        
        // Get the JSON
        HttpRequestHelper().GET(url: "https://raw.githubusercontent.com/johncodeos-blog/ParseJSONSwiftyJSONiOSExample/master/nested.json") { success, data in
            if success {
                // Show JSON results in pretty form
                self.showPrettyJSON(jsonData: data!)
                
                self.jsonData = data
            } else {
                print("Error: Coudn't get the data")
            }
        }
    }
    
    @IBAction func parseJsonBtnAction(_ sender: UIButton) {
        // Check if jsonData exist
        if let data = jsonData {
            // Parse JSON
            self.parseJSON(jsonData: data)
        }
    }
    
    func showPrettyJSON(jsonData: Data) {
        let prettyResults = PrettyJSONHelper().convertPretty(data: jsonData)
        
        // Show Results in Main thread
        DispatchQueue.main.async {
            self.jsonResultsTextView.text = prettyResults ?? ""
        }
    }
    
    func parseJSON(jsonData: Data) {
        let json = try! JSON(data: jsonData)
        for (_, data) in json["data"] {
            // ID
            let id = data["id"].string ?? "N/A"
            print("ID: \(id)")
            
            // Employee Name
            let employeeName = data["employee"]["name"].string ?? "N/A"
            print("Employee Name: \(employeeName)")
            
            // Employee Salary in USD
            let employeeSalaryUSD = data["employee"]["salary"]["usd"].int ?? 0
            print("Employee Salary in USD: \(employeeSalaryUSD)")
            
            // Employee Salary in EUR
            let employeeSalaryEUR = data["employee"]["salary"]["eur"].int ?? 0
            print("Employee Salary in EUR: \(employeeSalaryEUR)")
            
            // Employee Age
            let employeeAge = data["employee"]["age"].string ?? "N/A"
            print("Employee Age: \(employeeAge)")
            
            employeeArray.append(
                NestedJSONModel(
                    employee_id: id,
                    employee:
                    Employee(
                        name: employeeName,
                        salary:
                        Salary(
                            usd: employeeSalaryUSD,
                            eur: employeeSalaryEUR
                        ),
                        age: employeeAge
                    )
                )
            )
            
            jsonResultsTableView.reloadData()
        }
    }
}

extension NestedJSONViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "nestedjsoncellid", for: indexPath) as? NestedJSONCell else { fatalError("Cell not exists") }
        
        cell.employeeIdLabel.text = employeeArray[indexPath.row].employee_id
        cell.employeeNameLabel.text = employeeArray[indexPath.row].employee.name
        cell.employeeSalaryUSDLabel.text = "$ \(employeeArray[indexPath.row].employee.salary?.usd ?? 0)"
        cell.employeeSalaryEURLabel.text = "€ \(employeeArray[indexPath.row].employee.salary?.eur ?? 0)"
        cell.employeeAgeLabel.text = employeeArray[indexPath.row].employee.age
        
        return cell
    }
}

extension NestedJSONViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
