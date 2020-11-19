//
//  Model.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/11.
//  Copyright © 2020 LSH. All rights reserved.
//

import Foundation

// MARK: - StockGraphModel
struct StockGraph: Codable {
    let metaData: MetaData
    let timeSeriesDaily: [String: TimeSeriesDaily]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

struct MetaData: Codable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct TimeSeriesDaily: Codable {
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case adjustedClose = "5. adjusted close"
    }
}

//struct StockInfo: Codable {
//    let symbol: String
//    let marketCap: String
//    let per: String
//    let bookValue: String
//    let eps: String
//    let high: String
//    let low: String
//    let dividendDate: String
//    let dividendPerShare: String
//
//    enum CodingKeys: String, CodingKey {
//        case symbol = "Symbol"
//        case marketCap = "MarketCapitalization"
//        case per = "PERatio"
//        case bookValue = "BookValue"
//        case eps = "EPS"
//        case high = "52WeekHigh"
//        case low = "52WeekLow"
//        case dividendDate = "DividendDate"
//        case dividendPerShare = "DividendPerShare"
//    }
//}
