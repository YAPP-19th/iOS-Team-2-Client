//
//  HomeWritingMembersBottomViewController.swift
//  Budi
//
//  Created by leeesangheee on 2021/12/13.
//

import UIKit

final class HomeWritingMembersBottomViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet private weak var completeView: UIView!
    @IBOutlet private weak var completeButton: UIButton!

    private var isBottomViewShown: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        completeView.layer.addBorderTop()
        animateBottomView()
    }
}

private extension HomeWritingMembersBottomViewController {
    func animateBottomView() {
        isBottomViewShown ? hideBottomView() : showBottomView()
    }
    
    func showBottomView() {
    }
    
    func hideBottomView() {
    }
}
