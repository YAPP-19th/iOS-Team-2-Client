//
//  HomeWritingPartCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine

final class HomeWritingPartCell: UICollectionViewCell {
    
    @IBOutlet weak var selectPartButton: UIButton!
    @IBOutlet private weak var textField: UITextField!
    
    var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ part: String) {
        textField.text = part
    }
}
