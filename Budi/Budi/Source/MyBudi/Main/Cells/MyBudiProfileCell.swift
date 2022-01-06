//
//  MyBudiProfileCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/21.
//

import UIKit
import Combine

final class MyBudiProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    
    var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
