//
//  NormalTextFieldTableViewCell.swift
//  Budi
//
//  Created by 인병윤 on 2022/01/10.
//

import UIKit
import Combine

class NormalTextFieldTableViewCell: UITableViewCell {

    static let cellId = "NormalTextFieldTableViewCell"
    var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var normalTextField: UITextField!
    @IBOutlet weak var normalTitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureText(text: String) {
        normalTextField.text = text
    }

    func configureLabel(text: String) {
        normalTitleLabel.text = text
    }
}
