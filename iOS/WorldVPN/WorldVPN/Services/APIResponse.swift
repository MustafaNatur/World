//
//  APIResponse.swift
//  WorldVPN
//
//  Created by Mustafa on 26.09.2025.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let data: T
}
