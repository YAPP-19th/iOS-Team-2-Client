//
//  APIResponse.swift
//  Budi
//
//  Created by 최동규 on 2021/11/27.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T
}
