//
//  Section.swift
//  Budi
//
//  Created by 인병윤 on 2021/12/01.
//

import UIKit

class Section: Hashable {
    var id = UUID()

    var title: String
    var write: [WorkHistory]

    init(title: String, write: [WorkHistory]) {
        self.title = title
        self.write = write
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}

extension Section {
    static var allSections: [Section] = [
        Section(title: "경력", write: []),
        Section(title: "프로젝트", write: []),
        Section(title: "포트폴리오", write: [])
    ]
}
