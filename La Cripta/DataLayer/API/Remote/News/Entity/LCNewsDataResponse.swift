//
//  NewsAPI.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import Foundation

struct LCNewsDataResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [LCArticleResponse]
}

// MARK: - Article
struct LCArticleResponse: Codable {
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
