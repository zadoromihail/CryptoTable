//
//  CryptoTableViewController.swift
//  CryptoTable
//
//  Created by  Михаил on 22.02.2025.
//

import UIKit

final class CryptoTableViewController: UIViewController {

    // MARK: - Public properties
    var viewModel: CryptoTableViewModelProtocol?
    
    // MARK: - Private properties
    private var assets = [CryptoAsset]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var activitiIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    // MARK: - Private methods
    private func setupUI() {
        title = "Список криптовалют"
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(activitiIndicator)
        NSLayoutConstraint.activate([
            activitiIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activitiIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    private func setupViewModel() {
        viewModel?.setUpdateHandler { [weak self] state in
            DispatchQueue.main.async {
                
                switch state {
                case .dataLoaded(let assets):
                    self?.activitiIndicator.stopAnimating()
                    self?.addAssets(assets)
                    
                case .isLoading:
                    self?.activitiIndicator.startAnimating()
                    
                case .loadingError(let error):
                    self?.activitiIndicator.stopAnimating()
                    self?.showErrorAlert(error)
                }
            }
        }
        viewModel?.loadData()
    }
    
    private func addAssets(_ newAssets: [CryptoAsset]) {
        
        guard !assets.isEmpty else {
            assets += newAssets
            tableView.reloadData()
            return
        }
        
        let startIndex = assets.count
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.performBatchUpdates({ [weak self] in
                guard let self else { return }
                let indexPaths = (startIndex..<startIndex + newAssets.count).map {
                    IndexPath(item: $0, section: 0)
                }
                assets.append(contentsOf: newAssets)
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension CryptoTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let asset = assets[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as?  CryptoTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: asset)
        return cell
        
    }
}

// MARK: - UITableViewDelegate
extension CryptoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !tableView.contentOffset.y.isZero else { return }
        if indexPath.row > assets.count - 5 {
            viewModel?.loadData()
        }
    }
}

extension CryptoTableViewController {
    func showErrorAlert(_ error: CryptoTableError) {
        let alert = UIAlertController(title: "Произошла ошибка", message: error.errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
    }
}
