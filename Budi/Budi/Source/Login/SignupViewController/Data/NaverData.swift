//
//  NaverData.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/19.
//

import Foundation

struct Response: Decodable {
    let response: NaverData
}

struct NaverData: Decodable {
    let nickname: String?
    let email: String?
    let name: String?
    let id: String
}
