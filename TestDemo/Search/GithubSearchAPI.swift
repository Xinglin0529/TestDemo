//
//  GithubSearchAPI.swift
//  TestDemo
//
//  Created by Dongdong on 16/11/23.
//  Copyright © 2016年 com. All rights reserved.
//

import Foundation

struct Respository {
    var name: String
    var url: String
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

extension Respository: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(name) | \(url)"
    }
}

enum ServiceSate {
    case online
    case offline
}

enum SearchRepositoryResponse {
    case respositories(respositories: [Respository], nextURL: URL?)
    case serviceOffline
    case limitExceeded
}

struct RepositoriesState {
    let respositories: [Respository]
    
    let serviceState: ServiceSate?
    
    let limitExceeded: Bool
    
    static let empty = RepositoriesState(respositories: [], serviceState: nil, limitExceeded: false)
}

class GithubSearchRepositoriesAPI {
    
}

