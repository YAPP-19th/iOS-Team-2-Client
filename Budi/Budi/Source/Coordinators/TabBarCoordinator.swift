//
//  TabBarCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

protocol TabBarCoordinator: AnyObject {
    var tabBarController: UITabBarController { get set }

    func start()
}
