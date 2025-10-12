//
//  GetAccessLevel.swift
//  Buildable
//
//  Created by Alexander Schmutz on 12.10.25.
//

import SwiftSyntax

func getAccessLevel(from modifiers: DeclModifierListSyntax) -> AccessLevel {
    guard let accessLevelText = modifiers.first(where: { modifier in
        AccessLevel.allCases.contains(where: { accessLevel in
            accessLevel.rawValue == modifier.name.text
        })
    }) else {
        return .internal
    }
    return AccessLevel(rawValue: accessLevelText.name.text) ?? .internal
}
