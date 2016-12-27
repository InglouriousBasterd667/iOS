//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Mikhail Lyapich on 26.12.16.
//  Copyright © 2016 Mikhail Lyapich. All rights reserved.
//

import Foundation

class RecentSearches{
    private struct Constants{
        static let valueKey = "recentSearches"
        static let numberOfSearches = 100
    }
    
    private let stdDefaults = UserDefaults.standard
    
    var values: [String]{
        get{
            return stdDefaults.object(forKey: Constants.valueKey) as? [String] ?? []
        }
        set{
            stdDefaults.set(newValue, forKey: Constants.valueKey)
        }
    }
    
    func add(search: String){
        var currentSearches = values
        if let index = currentSearches.index(of: search){
            currentSearches.remove(at: index)
        }
        currentSearches.insert(search, at: 0)
        if currentSearches.count > Constants.numberOfSearches{
            currentSearches.removeLast()
        }
        values = currentSearches
    }
}
