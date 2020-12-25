//
//  ArticleServices.swift
//  news-api-demo
//
//  Created by Jithin on 23/12/20.
//

import Foundation

typealias ArticlesResponse = Result<NewsAPIResponse, Error>

class ArticleService {
    
    private let decoder = JSONDecoder()
    var session = URLSession.shared
    
    func fetchArticles(page: Int, completion: @escaping (ArticlesResponse) -> Void) {
        
        guard let articlesURL = EndPoint.articles(page: page).url else { return }
        
        let task = session.dataTask(with: articlesURL) {[weak self] (data, _, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ArticleError.noData))
                return
            }
            do {
                let response = try self.decoder.decode(NewsAPIResponse.self, from: data)
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

struct EndPoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension EndPoint {
    
    static func articles(page: Int) -> EndPoint {
        return EndPoint(path: "/v2/top-headlines", queryItems: [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "category", value: "business"),
            URLQueryItem(name: "apiKey", value: "24de9e0fb15e411dadada31e15d45447"),
            URLQueryItem(name: "pageSize", value: "5"),
            URLQueryItem(name: "page", value: "\(page)")
        ])
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
