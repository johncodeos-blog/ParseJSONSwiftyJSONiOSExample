//
//  SimpleJSONViewController.swift
//  ParseJSONSwiftyJSONExample
//
//  Created by John Codeos on 6/16/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import SwiftyJSON
import UIKit

class SimpleJSONViewController: UIViewController {
    @IBOutlet var jsonResultsTextView: UITextView!
    @IBOutlet var parseJsonButton: UIButton!
    @IBOutlet var employeeIdLabel: UILabel!
    @IBOutlet var employeeNameLabel: UILabel!
    @IBOutlet var employeeSalaryLabel: UILabel!
    @IBOutlet var employeeAgeLabel: UILabel!
    
    var jsonData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clean TextView
        jsonResultsTextView.text = ""
        // Clean Labels
        employeeIdLabel.text = ""
        employeeNameLabel.text = ""
        employeeSalaryLabel.text = ""
        employeeAgeLabel.text = ""
        
        // Get the JSON
        HttpRequestHelper().GET(url: "https://raw.githubusercontent.com/johncodeos-blog/ParseJSONSwiftyJSONiOSExample/master/simple.json") { success, data in
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
        
        // ID
        let id = json["id"].string ?? "N/A"
        print("ID: \(id)")
        employeeIdLabel.text = id
        
        // Employee Name
        let employeeName = json["employee_name"].string ?? "N/A"
        print("Employee Name: \(employeeName)")
        employeeNameLabel.text = employeeName
        
        // Employee Salary
        let employeeSalary = json["employee_salary"].string ?? "N/A"
        print("Employee Salaray: \(employeeSalary)")
        employeeSalaryLabel.text = "$ " + employeeSalary
        
        // Employee Age
        let employeeAge = json["employee_age"].string ?? "N/A"
        print("Employee Age: \(employeeAge)")
        employeeAgeLabel.text = employeeAge
    }
}



