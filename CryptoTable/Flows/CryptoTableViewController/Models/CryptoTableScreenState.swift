//
//  CryptoTableScreenState.swift
//  CryptoTable
//
//  Created by  Михаил on 23.02.2025.
//

import Foundation

enum CryptoTableScreenState {
    case isLoading
    case dataLoaded([CryptoAsset])
    case loadingError(CryptoTableError)
}
