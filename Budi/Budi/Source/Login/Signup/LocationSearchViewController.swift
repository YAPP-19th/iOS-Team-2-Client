//
//  LocationSearchViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/08.
//

import UIKit
import CoreLocation

class LocationSearchViewController: UIViewController {
    private var locationResults: [String] = []

    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "지명으로 검색"
        search.setImage(UIImage(systemName: "magnifyingglass"), for: UISearchBar.Icon.search, state: .normal)
        search.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)
        search.tintColor = UIColor.init(white: 0, alpha: 0.12)
        search.backgroundImage = UIImage()
        search.backgroundColor = .none
        search.layer.cornerRadius = 0
        search.searchTextField.backgroundColor = .white
        return search
    }()

    private let nowLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("현위치로 설정", for: .normal)
        button.setImage(UIImage(named: "GPS"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        button.setTitleColor(UIColor.init(white: 0.62, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.tintColor = .white

        button.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.separatorInset.left = 0
        return tableView
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.38)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        nextButton.isEnabled = false
        self.addBackButton()
        configureLayout()
        configureTableView()
        configureLocationAuthorization()
        configureKeyBoard()
    }
}

private extension LocationSearchViewController {
    @objc
    func locationButtonAction() {
        LocationManager.shared.getAddress { result in
            switch result {
            case .success(let location):
                self.searchBar.text = location
                self.nextButton.backgroundColor = UIColor.budiGreen
                self.nextButton.isEnabled = true
                self.view.endEditing(true)
                NotificationCenter.default.post(name: NSNotification.Name("LocationNextActivation"), object: location)
            case .failure(let error): print(error)
            }
        }
    }

    @objc
    func nextAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func configureKeyBoard() {
    }

    func configureLocationAuthorization() {
        LocationManager.shared.requestWhenInUseAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(locationAuthorizationSuccess), name: Notification.Name("locationAuthorizationSuccess"), object: nil)
    }

    @objc
    func locationAuthorizationSuccess() {
        nowLocationButton.isEnabled = true
        nowLocationButton.setTitleColor(UIColor.budiDarkGray, for: .normal)
        nowLocationButton.backgroundColor = UIColor.budiLightGreen
    }

    func configureTableView() {
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellId)
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }

    func configureLayout() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 40, width: view.bounds.width - 16, height: 1.0)
        bottomLine.backgroundColor = UIColor.init(white: 0, alpha: 0.12).cgColor

        searchBar.layer.addSublayer(bottomLine)

        view.addSubview(searchBar)
        view.addSubview(nowLocationButton)
        view.addSubview(nextButton)
        view.addSubview(searchTableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        nowLocationButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width - 16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            nowLocationButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            nowLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nowLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nowLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nowLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 83)
        ])

        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: nowLocationButton.bottomAnchor, constant: 18),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LocationManager.shared.searchAddress(searchText) { results in
            self.locationResults = results
        }
        searchTableView.reloadData()
    }
}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellId, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.configureCellLabel(text: locationResults[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locationResults[indexPath.row]
        nextButton.backgroundColor = UIColor.budiGreen
        nextButton.isEnabled = true
        self.view.endEditing(true)
        searchBar.text = location
        NotificationCenter.default.post(name: NSNotification.Name("LocationNextActivation"), object: location)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
