//
//  CryptoTableError.swift
//  CryptoTable
//
//  Created by  Михаил on 22.02.2025.
//

import Foundation

enum CryptoTableError: Error {
    case badURL
    case someError
    case badData
    case parseError
    case emptyData
    
    var errorDescription: String {
           switch self {
           case .badURL:
               return "Некорректный URL"

           case .badData:
               return "Данные не загрузились"

           case .emptyData:
               return "Данные отсутствуют"

           case .someError:
               return "Ошибка загрузки данных"

           case .parseError:
               return "Ошибка обработки данных"
           }
       }
}
