//
//  HomeWritingMembersPartBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/15.
//

import UIKit

final class HomeWritingMembersPartBottomCell: UICollectionViewCell {
    
    @IBOutlet private weak var programmerLabel: UILabel!
    @IBOutlet private weak var designerLabel: UILabel!
    @IBOutlet private weak var plannerLabel: UILabel!
    
    @IBAction private func programmerButtonTapped(_ sender: Any) {
        isCheckedToggle()
        isProgrammerChecked.toggle()
        configureUI()
    }
    @IBAction private func designerButtonTapped(_ sender: Any) {
        isCheckedToggle()
        isDesignerChecked.toggle()
        configureUI()
    }
    @IBAction private func plannerButtonTapped(_ sender: Any) {
        isCheckedToggle()
        isPlannerChecked.toggle()
        configureUI()
    }
    
    private var isProgrammerChecked: Bool = false
    private var isDesignerChecked: Bool = false
    private var isPlannerChecked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func isCheckedToggle() {
    }
    
    private func configureUI() {
        programmerLabel.textColor = isProgrammerChecked ? .budiGreen : .budiGray
        programmerLabel.font = .systemFont(ofSize: 14, weight: isProgrammerChecked ? .semibold : .regular)
        
        designerLabel.textColor = isDesignerChecked ? .budiGreen : .budiGray
        designerLabel.font = .systemFont(ofSize: 14, weight: isDesignerChecked ? .semibold : .regular)
        
        plannerLabel.textColor = isPlannerChecked ? .budiGreen : .budiGray
        plannerLabel.font = .systemFont(ofSize: 14, weight: isPlannerChecked ? .semibold : .regular)
    }
}
