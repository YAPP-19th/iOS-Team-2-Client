//
//  TableViewItem.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/16.
//

import Foundation

struct SectionModel {
    let type: ModalControl
    let items: [Item]
}

struct Item {
    let description: String
    let endDate: String
    let name: String
    let startDate: String
}
