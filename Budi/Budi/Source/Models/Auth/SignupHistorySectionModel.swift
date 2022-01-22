//
//  TableViewItem.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/16.
//

import Foundation

struct HistorySectionModel {
    let type: ModalControl
    let sectionTitle: String
    var items: [Item]
}

struct Item {
    var itemInfo: ItemInfo
    var description: String
    var endDate: String
    var name: String
    var nowWork: Bool
    var startDate: String
    var portfolioLink: String
}

struct ItemInfo {
    var isInclude: Bool
    let buttonTitle: String
}
