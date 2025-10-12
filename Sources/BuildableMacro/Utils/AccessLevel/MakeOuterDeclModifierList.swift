//
//  MakeOuterDeclModifierList.swift
//  Buildable
//
//  Created by Alexander Schmutz on 12.10.25.
//

import SwiftSyntax

/// Returns a `DeclModifierListSyntax` for the top level generated Builder struct
///
/// Returns a new `DeclModifierSyntax` object to exclude any previous prefixed or suffixed newlines
func makeOuterDeclModifierList(for accessLevel: AccessLevel) -> DeclModifierListSyntax {
    if accessLevel == .internal {
        return []
    } else {
        return [DeclModifierSyntax(name: TokenSyntax(stringLiteral: accessLevel.rawValue))]
    }
}
