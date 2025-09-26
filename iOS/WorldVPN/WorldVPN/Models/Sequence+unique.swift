//
//  Sequence+unique.swift
//  WorldVPN
//
//  Created by Mustafa on 26.09.2025.
//

import Foundation

extension Sequence {
    func unique<T: Hashable>(by keyForValue: (Iterator.Element) throws -> T) rethrows -> [Iterator.Element] {
        var seen: Set<T> = []
        return try filter { try seen.insert(keyForValue($0)).inserted }
    }
}
