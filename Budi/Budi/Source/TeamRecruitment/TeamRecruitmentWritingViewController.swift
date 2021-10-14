//
//  TeamRecruitmentWritingViewController.swift
//  Budi
//
//  Created by 최동규 on 2021/10/11.
//

import UIKit

final class TeamRecruitmentWritingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureNavigationBar()
        configureCells()
    }
    func configureCells() {
        let calender = UINib(nibName: "CalendarCollectionViewCell", bundle: nil)
        let selectPhoto = UINib(nibName: "SelectPhotoCollectionViewCell", bundle: nil)
        let projectName = UINib(nibName: "ProjectNameCollectionViewCell", bundle: nil)
        let location = UINib(nibName: "LocationCollectionViewCell", bundle: nil)
        collectionView.register(calender, forCellWithReuseIdentifier: "calendarCell")
        collectionView.register(selectPhoto, forCellWithReuseIdentifier: "selectPhotoCell")
        collectionView.register(projectName, forCellWithReuseIdentifier: "projectNameCell")
        collectionView.register(location, forCellWithReuseIdentifier: "locationCell")
    }
    
}

extension TeamRecruitmentWritingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let calenderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        guard let selectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectPhotoCell", for: indexPath) as? SelectPhotoCollectionViewCell else { return UICollectionViewCell() }
        guard let projectNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectNameCell", for: indexPath) as? ProjectNameCollectionViewCell else { return UICollectionViewCell() }
        guard let locationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? LocationCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            return selectCell
        } else if indexPath.row == 1 {
            return projectNameCell
        } else if indexPath.row == 2 {
            return calenderCell
        } else {
            return locationCell
        }
        return UICollectionViewCell()
    }
}
extension TeamRecruitmentWritingViewController: UICollectionViewDelegateFlowLayout {

}

private extension TeamRecruitmentWritingViewController {
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(systemItem: .done)
        title = "팀원 모집"
    }
}
