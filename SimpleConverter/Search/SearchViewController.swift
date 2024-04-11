import UIKit

protocol SelectFlagDelegate {
    func didSelectFlag(url: String, currency: String)
}

final class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var viewModel: SearchViewModel!
    private var searchController: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableSearchBar()
        setupTableView()
        viewModel.fetchMetaData()
        viewModel.onUpdate = {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableSearchBar() {
        searchController = UISearchBar()
        searchController.placeholder = SearchViewModel.Constants.title
        searchController.delegate = self
        searchController.translatesAutoresizingMaskIntoConstraints = false
        let searchBarContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 664))
        searchBarContainer.addSubview(searchController)
        view.addSubview(searchBarContainer)
        NSLayoutConstraint.activate([
            searchController.topAnchor.constraint(equalTo: view.topAnchor),
            searchController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchController.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchController.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.tag = indexPath.row
        cell.currencyConverterImageView.image = nil
        cell.set(metaData: viewModel.filteredArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterSearch(searchText)
    }
}
