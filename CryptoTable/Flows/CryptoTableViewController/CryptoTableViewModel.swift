//
//  TableViewModel.swift
//  CryptoTable
//
//  Created by  Михаил on 22.02.2025.
//

import Foundation

enum CryptoTableScreenState {
    case isLoading
    case dataLoaded([CryptoAsset])
    case loadingError(CryptoTableError)
}

protocol CryptoTableViewModelProtocol {
    func setUpdateHandler(_ handler: @escaping (CryptoTableScreenState) -> Void)
    func loadData()
}

final class CryptoTableViewModelImpl: CryptoTableViewModelProtocol {
    
    // MARK: - Constants
    private enum Constants {
        static let apiURL = "https://api.coincap.io/v2/assets"
        static let limit: Int = 20
        static let maxItemsPerRequest: Int = 20
    }

    // MARK: - Private properies
    private var offset = 0
    private var isLoading = false
    private var canLoadMore = true
    private var updateHandler: ((CryptoTableScreenState) -> Void)?
    
    // MARK: - Public methods
    func loadData() {
        guard canLoadMore, !isLoading else { return }
        isLoading = true
        updateHandler?(.isLoading)
        performDownload(offset: offset, limit: Constants.limit) { [weak self] result in
            guard let self else { return }
            var allItemsLoaded = false
            switch result {
            case .success(let assets):
                allItemsLoaded = assets.count < Constants.maxItemsPerRequest
                offset += Constants.maxItemsPerRequest
                updateHandler?(.dataLoaded(assets))
                
            case .failure(let error):
                updateHandler?(.loadingError(error))
            }

            isLoading = false
            canLoadMore = !allItemsLoaded
            
        }
    }

    func setUpdateHandler(_ handler: @escaping (CryptoTableScreenState) -> Void) {
        updateHandler = handler
    }
    
    // MARK: - Private methods
    private func performDownload(offset:Int, limit: Int, completion: @escaping (Result<[CryptoAsset], CryptoTableError>) -> ()) {
        guard var urlComponents = URLComponents(string: Constants.apiURL) else {
            completion(.failure(.badURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(.badURL))
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.someError))
                return
            }
            
            guard let data else {
                completion(.failure(.badData))
                return
            }
            do {
                let assetData = try JSONDecoder().decode(CryptoAssetData.self, from: data)
                let assets = assetData.data
                guard !assets.isEmpty else {
                    completion(.failure(.emptyData))
                    return
                }
                completion(.success(assets))
            }
            catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
}
