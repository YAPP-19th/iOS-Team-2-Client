//
//  HomeWritingImageBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit
import Combine
import CombineCocoa

class HomeWritingImageBottomViewController: UIViewController {
    
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    @IBOutlet private weak var albumButton: UIButton!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: HomeWritingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(nibName: String?, bundle: Bundle?, viewModel: HomeWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
