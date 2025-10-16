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
