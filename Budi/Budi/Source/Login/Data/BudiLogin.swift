//
//  Login.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/24.
//
import Foundation

struct BudiLogin: Codable {
    let loginId: String
    let name: String?
    let email: String?
}

struct BudiLoginResponse: Decodable {
    let userId: String
    let accessToken: String
}
