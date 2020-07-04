//
//  Array+Extensions.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/3/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//
import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
