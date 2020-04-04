//
//  ViewController.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 03. 30..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import UIKit
import ClosureLayout
import Fuse

protocol CovidStatListViewLogic: AnyObject {
    func startLoading()
    func showData(_ data: [CovidStatViewModel])
}

class CovidStatListViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let navViewInset: CGFloat = 24
        static let topInset: CGFloat = 72
    }
    
    typealias SortOption = KeyPath<CountryStatViewModel, Int>

    // MARK: - Private Properties
    var presenter: CovidStatListPresenter = CovidStatListPresenterImpl()
    
    var viewModels = [CovidStatViewModel]()
    var searchResults = [CovidStatViewModel]()
    
    var isSearching = false
    let fuse = Fuse()

    // MARK: - UI Properties
    lazy var tableView = UITableView()
    lazy var searchBar = SearchBar()
    lazy var activityIndicator = UIActivityIndicatorView()
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        let topInset = view.safeAreaTop + Constants.navViewInset
        view.addSubview(searchBar)
        searchBar.layout {
            $0.leading == view.leadingAnchor + 24
            $0.trailing == view.trailingAnchor - 24
            $0.top == view.topAnchor + topInset
            $0.bottom == view.bottomAnchor - 12
        }
        return view
    }()
    
    // MARK: - Initial Setup
    convenience init() {
        self.init(nibName: nil, bundle: .main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColors()
        searchBar.delegate = self
        tableView.dataSource = self
        presenter.view = self
        addActivityIndicator()
        addTableView()
        addNavigationView()
        registerToNotifications()
        presenter.loadData()
    }
    
    private func addTableView() {
        view.fillWith(tableView)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        let topInset = view.safeAreaTop + Constants.topInset
        tableView.contentInset.top = topInset
        tableView.contentOffset.y = -topInset
        tableView.contentInset.bottom = 50
        tableView.register(WorldStatCell.self)
        tableView.register(CountryStatCell.self)
    }
    
    private func addNavigationView() {
        view.addSubview(navigationView)
        navigationView.layout {
            $0.top == view.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    private func addActivityIndicator() {
        activityIndicator.style = Theme.isDefault ? .gray : .white
        view.addSubview(activityIndicator)
        activityIndicator.layout {
            $0.centerX == view.centerXAnchor
            $0.centerY == view.centerYAnchor
            $0.size == CGSize(width: 50, height: 50)
        }
    }
    
    private func registerToNotifications() {
        Theme.register(self, selector: #selector(setupColors))
        NotificationCenter.default.addObserver(self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification
        )
    }
    
    // MARK: - Actions
    @objc func appDidBecomeActive() {
        presenter.loadData()
    }
    
    @objc func setupColors() {
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = Theme.isDefault ? .default : .black
        activityIndicator.style = Theme.isDefault ? .gray : .white
        view.backgroundColor = .backgroundColor
        navigationView.backgroundColor = .backgroundColor
        searchBar.textColor = .accentColor
    }
    
    private func search(text: String) {
        let countryStats = viewModels.compactMap { $0 as? CountryStatViewModel }
        let search = fuse.search(text, in: countryStats.map { $0.country.name })
        searchResults = search.map { countryStats[$0.index] }
        tableView.reloadData()
    }
    
    private func sort(by option: SortOption?) {
        let world = viewModels.compactMap { $0 as? WorldStatViewModel }
        var countries = viewModels.compactMap { $0 as? CountryStatViewModel }
        countries.sort {
            guard let option = option else { return $0.active > $1.active }
            return $0[keyPath: option] > $1[keyPath: option]
        }
        if option == nil { countries.prioritizeCurrentLocale() }
        viewModels = world + countries
        tableView.reloadData()
    }
}

// MARK: - View Logic
extension CovidStatListViewController: CovidStatListViewLogic {
    func startLoading() {
        tableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func showData(_ data: [CovidStatViewModel]) {
        viewModels = data
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension CovidStatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rows = isSearching ? searchResults : viewModels
        switch rows[indexPath.row] {
        case let vm as WorldStatViewModel:
            let cell = tableView.dequeuCellOfType(WorldStatCell.self)
            cell.configure(with: vm)
            cell.delegate = self
            return cell
        case let vm as CountryStatViewModel:
            let cell = tableView.dequeuCellOfType(CountryStatCell.self)
            cell.configure(with: vm)
            return cell
        default:
            fatalError()
        }
    }
}

// MARK: - Cell Delegates
extension CovidStatListViewController: WorldStatCellDelegate {
    func sortButtonTapped() {
        let controller = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        let options: [(title: String, type: SortOption?)] = [
            ("Confirmed", \.confirmed),
            ("Deaths", \.deaths),
            ("Recovered", \.recovered),
            ("Default (active)", nil)
        ]
        for option in options {
            let action = UIAlertAction(title: option.title, style: .default, handler: { _ in
                self.sort(by: option.type)
            })
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func moreButtonTapped() {
        let controller = UIAlertController(title: "Change theme", message: nil, preferredStyle: .actionSheet)
        let normal = UIAlertAction(title: "Light", style: .default, handler: { _ in
            Theme.currentStyle = .normal
        })
        let dark = UIAlertAction(title: "Dark", style: .default, handler: { _ in
            Theme.currentStyle = .dark
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(normal)
        controller.addAction(dark)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Search Bar Delegates
extension CovidStatListViewController: SearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: SearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: SearchBar) {
        searchBar.showsCancelButton = false
        if searchBar.text?.isEmpty ?? true {
            isSearching = false
            tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: SearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            search(text: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: SearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: SearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
}
