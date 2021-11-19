//
//  NaverData.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/19.
//

import Foundation

struct NaverData: Decodable {
    let response: Response
}

struct Response: Decodable {
    let nickname: String
    let email: String
    let name: String
}
