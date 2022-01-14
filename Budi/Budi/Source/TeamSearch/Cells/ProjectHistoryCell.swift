//
//  ProjectHistoryCell.swift
//  Budi
//
//  Created by 최동규 on 2022/01/11.
//

import UIKit

class ProjectHistoryCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var postionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(project: ProjectList) {
        titleLabel.text = project.name
        postionLabel.text = project.description
        let startDate = project.startDate.date() ?? Date(timeIntervalSince1970: 0)
        let endDate = project.endDate.date() ?? Date(timeIntervalSince1970: 0)
        let month = endDate.distance(from: startDate, only: .month)
        progressLabel.isHidden = endDate == Date(timeIntervalSince1970: 0)
        timeLabel.text = "\(startDate.convertStringyyyyMMdd()) - \(endDate.convertStringyyyyMMdd()) · \(month)개월"
    }
}
