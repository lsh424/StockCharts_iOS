//
//  NetworkManager.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/12.
//  Copyright © 2020 LSH. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(companies: [String], dataTasks: [URLSessionDataTask], index: Int, completion: @escaping (StockGraph?) -> Void) -> [URLSessionDataTask] {
        
        let company = companies[index]
        var tasks = dataTasks
        
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(company)&apikey=4LSUEYUFWMQ45OM9") else {return tasks}
        
        if tasks.firstIndex(where: { task in
            task.originalRequest?.url == url
        }) != nil {
            return tasks
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            
            guard let graph = try? JSONDecoder().decode(StockGraph.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(graph)
        }
        
        dataTask.resume()
        tasks.append(dataTask)
        return tasks
    }
    
    func cancelFetchData(companies: [String], index: Int , dataTasks: [URLSessionDataTask]) -> [URLSessionDataTask] {
        let company = companies[index]
        var tasks = dataTasks
        
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(company)&apikey=4LSUEYUFWMQ45OM9") else {return tasks}
        
        guard let dataTaskIndex = dataTasks.firstIndex(where: { task in
            task.originalRequest?.url == url
        }) else {
            return tasks
        }
        
        let dataTask =  dataTasks[dataTaskIndex]
        
        dataTask.cancel()
        tasks.remove(at: dataTaskIndex)
        return tasks
    }
}
