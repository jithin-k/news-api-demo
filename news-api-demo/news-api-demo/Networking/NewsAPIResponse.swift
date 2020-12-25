//
//  NewsAPIResponse.swift
//  news-api-demo
//
//  Created by Jithin on 23/12/20.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    var totalResults: Int
    let message: String?
    var articles: [Article]
    
    var error: Error? {
        if let message = message {
            return ArticleError.apiFailure(message: message)
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case message
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message)
        articles = try values.decodeIfPresent([Article].self, forKey: .articles) ?? []
    }
}

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
}

enum ArticleError: Error, LocalizedError {
    case noData
    case apiFailure(message: String)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data"
        
        case .apiFailure(let message):
            return message
        }
    }
}
