//
//  TableViewItem.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/16.
//

import Foundation

struct SectionModel {
    let type: ModalControl
    var index: Int
    var items: [Item]
}

struct Item {
    var description: String
    var endDate: String
    var name: String
    var startDate: String
}
