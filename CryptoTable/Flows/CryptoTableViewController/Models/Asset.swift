//
//  Asset.swift
//  CryptoTable
//
//  Created by  Михаил on 22.02.2025.
//

import Foundation

struct CryptoAssetData: Decodable {
    let data: [CryptoAsset]
}

struct CryptoAsset: Decodable {
    let id: String?
    let rank: String?
    let symbol: String?
    let name: String?
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let vwap24Hr: String?
}
