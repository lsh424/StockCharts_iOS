//
//  ViewController.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/08.
//  Copyright © 2020 LSH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var companyCodes: [String] = ["GOOGL", "TSLA", "DIS", "AAPL", "KO"]
    var graphViewModels: [StockGraphViewModel?] = [StockGraphViewModel?](repeating: nil, count: 5)
    var dataTasks : [URLSessionDataTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    func setupCollectionView() {
        let layout = CarouselLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(UINib(nibName: "StockCell", bundle: nil), forCellWithReuseIdentifier: "stockCell")
    }
    
    func setupNavigationBar() {
        let title = UILabel()
        title.text = "Stock Charts"
        title.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        title.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return graphViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCell", for: indexPath) as! StockCell
        
        if let graphViewModel = graphViewModels[indexPath.row]{
            cell.graphViewModel = graphViewModel
        }else {
            cell.graphViewModel = nil
            
            dataTasks = NetworkManager.shared.fetchData(companyCode: companyCodes[indexPath.row], dataTasks: dataTasks) { [weak self] (stockGraph) in
                guard let graph = stockGraph else {
                    DispatchQueue.main.async {
                        cell.noticeLabel.isHidden = false
                        cell.indicator.stopAnimating()
                    }
                    return}
                
                self?.graphViewModels[indexPath.row] = StockGraphViewModel(strokcGraph: graph)
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: indexPath.row, section: 0)
                    guard let collectionView = self?.collectionView else {return}
                    
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
                    }
                }
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            dataTasks = NetworkManager.shared.fetchData(companyCode: companyCodes[indexPath.row], dataTasks: dataTasks) { [weak self] (stockGraph) in
                guard let graph = stockGraph else {return}
                self?.graphViewModels[indexPath.row] = StockGraphViewModel(strokcGraph: graph)
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: indexPath.row, section: 0)
                    
                    guard let collectionView = self?.collectionView else {return}
                    
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
                    }
                }
            }
        }
    }
}
