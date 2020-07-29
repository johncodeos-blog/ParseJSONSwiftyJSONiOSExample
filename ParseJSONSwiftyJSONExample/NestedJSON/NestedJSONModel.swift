//
//  NestedJSONModel.swift
//  ParseJSONSwiftyJSONExample
//
//  Created by John Codeos on 6/16/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import Foundation

struct NestedJSONModel: Codable {
    let employee_id: String
    let employee: Employee
}

// MARK: - Employee

struct Employee: Codable {
    let name: String
    let salary: Salary?
    let age: String
}

// MARK: - Salary

struct Salary: Codable {
    let usd: Int
    let eur: Int
}
