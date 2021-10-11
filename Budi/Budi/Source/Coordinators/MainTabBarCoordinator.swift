//
//  MainTabBarCoordinator.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

// swiftlint:disable line_length
final class MainTabBarCoordinator: TabBarCoordinator {

    var tabBarController: UITabBarController
    private var chlidCoordinators: [NavigationCoordinator] = []

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        let recruitmentNavigationController = UINavigationController()
        let searchNavigationController = UINavigationController()
        let chattingNavigationController = UINavigationController()
        let myBudiNavigationController = UINavigationController()

        let recruitmentCoordinator = TeamRecruitmentCoordinator(navigationController: recruitmentNavigationController)
        let searchCoordinator = TeamSearchCoordinator(navigationController: searchNavigationController)
        let chattingCoordinator = ChattingCoordinator(navigationController: chattingNavigationController)
        let myBudiCoordinator = MyBudiCoordinator(navigationController: myBudiNavigationController)

        let iconRecruitment = UITabBarItem(title: "팀원모집", image: UIImage(systemName: "person.2.fill"), selectedImage: nil)
        let iconSearch = UITabBarItem(title: "팀원찾기", image: UIImage(systemName: "doc.text.magnifyingglass"), selectedImage: nil)
        let iconChatting = UITabBarItem(title: "채팅", image: UIImage(systemName: "ellipses.bubble"), selectedImage: nil)
        let iconMyBudi = UITabBarItem(title: "나의 버디", image: UIImage(systemName: "person.fill"), selectedImage: nil)

        recruitmentCoordinator.navigationController?.tabBarItem = iconRecruitment
        searchCoordinator.navigationController?.tabBarItem = iconSearch
        chattingCoordinator.navigationController?.tabBarItem = iconChatting
        myBudiCoordinator.navigationController?.tabBarItem = iconMyBudi

        chlidCoordinators = [recruitmentCoordinator,
                             searchCoordinator,
                             chattingCoordinator,
                             myBudiCoordinator]

        tabBarController.viewControllers = [recruitmentNavigationController,
                                            searchNavigationController,
                                            chattingNavigationController,
                                            myBudiNavigationController]

        recruitmentCoordinator.parentCoordinator = self
        searchCoordinator.parentCoordinator = self
        chattingCoordinator.parentCoordinator = self
        myBudiCoordinator.parentCoordinator = self

        recruitmentCoordinator.start()
        searchCoordinator.start()
        chattingCoordinator.start()
        myBudiCoordinator.start()
    }
}

extension MainTabBarCoordinator {

}
