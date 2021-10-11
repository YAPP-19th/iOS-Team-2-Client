//
//  NavigationCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

protocol NavigationCoordinator: AnyObject {
    var navigationController: UINavigationController? { get set }

    func start()
}
