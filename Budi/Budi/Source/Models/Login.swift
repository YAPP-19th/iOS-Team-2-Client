//
//  Login.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/24.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T
}

struct Login: Codable {
    let loginId: String
    let name: String?
    let email: String?
}

struct LoginResponse: Decodable {
    let userId: String
    let accessToken: String
}
