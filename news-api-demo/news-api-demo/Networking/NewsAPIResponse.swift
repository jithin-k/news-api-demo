//
//  NewsAPIResponse.swift
//  news-api-demo
//
//  Created by Jithin on 23/12/20.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
}
