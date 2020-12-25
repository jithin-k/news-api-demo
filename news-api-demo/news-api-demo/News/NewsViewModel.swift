//
//  NewsViewModel.swift
//  news-api-demo
//
//  Created by Jithin on 23/12/20.
//

import Foundation

protocol NewsViewModelDelegate: AnyObject {
    func viewModelDidFetchArticles(_ viewModel: NewsViewModel)
    func viewmodel(_ viewModel: NewsViewModel, failedToFetchArticles error: Error)
}

class NewsViewModel {
    
    private(set) var articles: [Article] = []
    private var page = 1
    private var fetchingInProgress = false
    var service = ArticleService()
    weak var delegate: NewsViewModelDelegate?
    var totalCount: Int = 0
    
    var isNextPageAvailable: Bool {
        return articles.count < totalCount
    }
    
    func fetchArticles(paginate: Bool = false) {
        guard !fetchingInProgress else { return }
        
        if !paginate {
            page = 1
        } else if !isNextPageAvailable {
            return
        }
        fetchingInProgress = true
        
        service.fetchArticles(page: page) {[weak self] (response) in
            guard let self = self else { return }
            defer { self.fetchingInProgress = false }
            
            switch response {
            case .success(let news):
                let articles = news.articles
                self.totalCount = news.totalResults
                
                if self.page == 1 {
                    self.articles = articles
                } else {
                    self.articles.append(contentsOf: articles)
                }
                if self.isNextPageAvailable {
                    self.page += 1
                }
                DispatchQueue.main.async {
                    print(self.articles.count)
                    self.delegate?.viewModelDidFetchArticles(self)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.viewmodel(self, failedToFetchArticles: error)
                }
            }
        }
    }
}
