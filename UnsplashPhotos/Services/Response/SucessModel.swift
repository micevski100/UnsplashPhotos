//
//  File.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import Foundation

struct SuccessModel<T: Codable>: Codable {
    var data: T
}
