//
//  LocationSearchViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/08.
//

import UIKit

protocol HomeLocationSearchViewControllerDelegate: AnyObject {
    func getLocation(_ location: String)
}

final class HomeLocationSearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "도로명으로 검색"
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor =  UIColor.primarySub
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.tintColor = .white
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
        return button
    }()

    private var searchedLocations: [String] = []
    weak var delegate: HomeLocationSearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.addBackButton()
        
        LocationManager.shared.requestWhenInUseAuthorization()

        searchBar.delegate = self
        nextButton.isEnabled = false
        configureLayout()
        configureTableView()

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nowLocationButton.addTarget(self, action: #selector(nowLocationButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

private extension HomeLocationSearchViewController {
    @objc
    func nextButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func nowLocationButtonTapped() {
        LocationManager.shared.getAddress { result in
            switch result {
            case .success(let address):
                self.delegate?.getLocation(address)
                self.searchBar.text = address
                self.nextButton.backgroundColor = UIColor.primary
                self.nextButton.isEnabled = true
            case .failure(let error): print(error.localizedDescription)
            }
        }
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
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width - 16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(nowLocationButton)
        nowLocationButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nowLocationButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            nowLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nowLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nowLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nowLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 83)
        ])

        view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: nowLocationButton.bottomAnchor, constant: 18),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
    }
}

// MARK: - SearchBar
extension HomeLocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredLocations = LocationManager.shared.searchAddress(searchText)
        
        if !searchText.isEmpty {
            if searchedLocations != filteredLocations {
                searchedLocations.append(contentsOf: filteredLocations)
            }
            searchTableView.reloadData()
        } else {
            searchedLocations = []
            searchTableView.reloadData()
        }
    }
}

// MARK: - TableView
extension HomeLocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellId, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        if searchedLocations.count > 0 {
            cell.configureCellLabel(text: searchedLocations[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = searchedLocations[indexPath.row]
        nextButton.backgroundColor = UIColor.primary
        nextButton.isEnabled = true
        self.view.endEditing(true)
        delegate?.getLocation(data)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
