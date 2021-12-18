//
//  HomeWritingImageBottomCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/14.
//

import UIKit

class HomeWritingImageBottomCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ urlString: String) {
        guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return }
        imageView.image = UIImage(data: data)
    }
    
    func addBorder() {
        imageView.borderWidth = 2
        imageView.borderColor = .primary
    }
    
    func removeBorder() {
        imageView.borderWidth = 0
    }
}
