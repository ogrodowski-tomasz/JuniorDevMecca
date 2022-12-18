//
//  HomeViewController.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import SafariServices
import UIKit

let appColor = UIColor.systemBlue

enum SortingMethod: String, CaseIterable {
    case category = "Category ↓"
    case categoryReversed = "Category ↑"
    case name = "Name ↓"
    case nameReversed = "Name ↑"
}

class HomeViewController: UIViewController {
    
    // Table View
    var tableView = UITableView()
    var headerView = HomeTableHeaderView(frame: .zero)
    
    // Search controller
    let searchController = UISearchController()

    // Action sheets
    var filteringActionSheet = UIAlertController()
    var sortingActionSheet = UIAlertController()
    var errorAlert = UIAlertController()
    
    var networkingManager: NetworkingManagerable = NetworkingManager()

    // Properties
    var entries = [Entry]() {
        didSet {
            shapeViewModels()
        }
    }
    
    var categories = [String]() {
        didSet {
            setupCategoriesActionSheet()
        }
    }
    
    var viewModels = [ApiTableViewCell.ViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Manipulation properties
    var selectedCategory = "" {
        didSet {
            shapeViewModels()
        }
    }
    
    var searchText = "" {
        didSet {
            shapeViewModels()
        }
    }
    
    var selectedSortingMethod: SortingMethod = .category {
        didSet {
            shapeViewModels()
        }
    }
    
    var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        fetchData()
    }
}

extension HomeViewController {
    
    private func setup() {
        setupTableView()
        setupTableHeaderView()
        setupNavigationBar()
        setupSearchController()
        setupSkeletons()
        setupSortingActionSheet()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor
        tableView.register(ApiTableViewCell.self, forCellReuseIdentifier: ApiTableViewCell.reuseIdentifier)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .label
        navigationItem.rightBarButtonItem = filterButton
        
        let sortingButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortingButtonTapped))
        sortingButton.tintColor = .label
        navigationItem.leftBarButtonItem = sortingButton
        
        let customAppearance = UINavigationBarAppearance()
        customAppearance.backgroundColor = appColor
        
        navigationController?.navigationBar.scrollEdgeAppearance = customAppearance
        navigationController?.navigationBar.compactAppearance = customAppearance
        navigationController?.navigationBar.standardAppearance = customAppearance
    }
    
    private func setupSearchController() {
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func setupSkeletons() {
        let row = Entry.makeSketelon()
        entries = Array(repeating: row, count: 10)
    }
    
    private func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

// MARK: - Networking
extension HomeViewController {
    
    private func fetchData() {
        fetchEntries()
        fetchCategories()
    }
    
    private func fetchEntries() {
        networkingManager.call(endpoint: .entries, decodeToType: EntriesApiResponse.self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.entries = response.entries
                    self.isLoaded = true
                case .failure(let error):
                    self.displayError(error)
                }
            }
        }
    }
    
    private func fetchCategories() {
        networkingManager.call(endpoint: .categories, decodeToType: CategoriesApiResponse.self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.categories = response.categories
                case .failure(let error):
                    self.displayError(error)
                }
            }
        }
    }
}

// MARK: - Data manipulation
extension HomeViewController {
    
    private func shapeViewModels() {
        var filteredEntries = filterEntries(entries)
        sortEntries(&filteredEntries)
        
        viewModels = filteredEntries.map { ApiTableViewCell.ViewModel(name: $0.name, category: $0.category, description: $0.description, link: $0.link) }
    }
    
    /// Filtering given entries in terms of category and text from text field
    private func filterEntries(_ entries: [Entry]) -> [Entry] {
        var filteredEntries = [Entry]()
        if !selectedCategory.isEmpty {
            filteredEntries = entries.filter { $0.category.lowercased().contains(selectedCategory.lowercased()) }
        }
        
        if !searchText.isEmpty {
            // If filteredEntries is empty, then it means no CATEGORY filter was selected so we want to filter all entries.
            if filteredEntries.isEmpty {
                filteredEntries = entries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            } else {
                // Otherwise we want to filter by name only entries of selected category
                filteredEntries = filteredEntries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }
        
        return filteredEntries.isEmpty ? entries : filteredEntries
    }
    
    private func sortEntries(_ entries: inout [Entry]) {
        entries.sort { firstEntry, secondEntry in
            switch selectedSortingMethod {
            case .category:
                return firstEntry.category < secondEntry.category
            case .categoryReversed:
                return firstEntry.category > secondEntry.category
            case .name:
                return firstEntry.name < secondEntry.name
            case .nameReversed:
                return firstEntry.name > secondEntry.name
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = viewModels[indexPath.row]
        print("DEBUG: Should open \"\(viewModel.name)\" Safari with link: \(viewModel.link)")
        displayLink(viewModel.link)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: ApiTableViewCell.reuseIdentifier, for: indexPath) as! ApiTableViewCell
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseIdentifier, for: indexPath) as! SkeletonCell
        
        return cell
    }
}

// MARK: - Action Sheets
extension HomeViewController {
    
    private func setupCategoriesActionSheet() {
        filteringActionSheet = UIAlertController(title: "Categories", message: "Which category interests You?", preferredStyle: .actionSheet)
        
        // Main actions
        filteringActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        filteringActionSheet.addAction(UIAlertAction(title: "Show all", style: .destructive, handler: { _ in
            self.selectedCategory = ""
        }))
        
        // Category actions
        for category in categories {
            filteringActionSheet.addAction(UIAlertAction(title: category, style: .default, handler: { action in
                guard let selectedCategory = action.title else { return }
                self.selectedCategory = selectedCategory
            }))
        }
    }
    
    private func setupSortingActionSheet() {
        sortingActionSheet = UIAlertController(title: "Sorting", message: "Sort APIs", preferredStyle: .actionSheet)
        sortingActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        for sortingMethod in SortingMethod.allCases {
            sortingActionSheet.addAction(UIAlertAction(title: sortingMethod.rawValue, style: .default, handler: { _ in
                self.selectedSortingMethod = sortingMethod
            }))
        }
    }
    
    private func displayError(_ error: NetworkingError) {
        errorAlert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        errorAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchData()
        }))
        present(errorAlert, animated: true)
    }
}

// MARK: - Selectors
extension HomeViewController {
    
    @objc
    private func filterButtonTapped() {
        present(filteringActionSheet, animated: true)
    }
    
    @objc
    private func sortingButtonTapped() {
        present(sortingActionSheet, animated: true)
    }
}

// MARK: - Safari Services
extension HomeViewController {
    
    func displayLink(_ link: String) {
        guard let url = URL(string: link) else {
            displayError(.invalidUrl)
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate, UITextFieldDelegate
extension HomeViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            return
        }
        self.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearFiltering()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearFiltering()
        searchController.dismiss(animated: true)
        return true
    }
    
    private func clearFiltering() {
        self.searchText = ""
    }
}
