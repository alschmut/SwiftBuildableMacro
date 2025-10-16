//
//  AccessLevel.swift
//  Buildable
//
//  Created by Alexander Schmutz on 12.10.25.
//

enum AccessLevel: String, CaseIterable {
    case `private`
    case `fileprivate`
    case `internal`
    case `package`
    case `public`
    
    var orderIndex: Int {
        switch self {
        case .private: 0
        case .fileprivate: 1
        case .internal: 2
        case .package: 3
        case .public: 4
        }
    }
    
    var needsExplicitInit: Bool {
        switch self {
        case .private: false
        case .fileprivate: false
        case .internal: false
        case .package: true
        case .public: true
        }
    }
}

extension AccessLevel: Comparable {
    static func < (lhs: AccessLevel, rhs: AccessLevel) -> Bool {
        lhs.orderIndex < rhs.orderIndex
    }
}
