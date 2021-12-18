//
//  AppliesRequest.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/16.
//

import Foundation

struct AppliesRequest: Codable {
    let postId: Int
    let recruitingPositionId: Int
    
    init(postId: Int, recruitingPositionId: Int) {
        self.postId = postId
        self.recruitingPositionId = recruitingPositionId
    }
}
