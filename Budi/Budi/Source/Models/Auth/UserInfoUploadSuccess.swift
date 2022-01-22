//
//  UserInfoUploadSuccess.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/25.
//

import Foundation

struct UserInfoUploadSuccess: Codable {
    let statusCode: Int
    let message: String
    let serverDateTime: String
    let data: SignUpSuccess
}

struct SignUpSuccess: Codable {
    let memberId: Int
}
