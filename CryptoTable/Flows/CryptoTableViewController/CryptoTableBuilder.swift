//
//  CryptoTableBuilder.swift
//  CryptoTable
//
//  Created by  Михаил on 23.02.2025.
//

import UIKit

protocol CryptoTableBuildableProlocol {
    func build() -> UIViewController
}

final class CryptoTableBuilderImpl: CryptoTableBuildableProlocol {
    func build() -> UIViewController {
        let viewModel = CryptoTableViewModelImpl()
        let vc = CryptoTableViewController()
        vc.viewModel = viewModel
        return vc
    }
}
