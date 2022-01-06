//
//  HomeWritingImageCell.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/02.
//

import UIKit
import Combine

final class HomeWritingImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageChangeButton: UIButton!
    
    var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(_ urlString: String) {
        guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return }
        imageView.image = UIImage(data: data)
    }
}
