//
//  MakeInnerDeclModifierList.swift
//  Buildable
//
//  Created by Alexander Schmutz on 12.10.25.
//

import SwiftSyntax
import SwiftSyntaxBuilder

/// Returns a `DeclModifierListSyntax` for properties and functions inside the generated Builder.
///
/// - Returns an empty list if the access level is `private`, since otherwise the generated Builder would not be usable
/// - Returns a new `DeclModifierSyntax` object to exclude any previous prefixed or suffixed newlines
func makeInnerDeclModifierList(for accessLevel: AccessLevel) -> DeclModifierListSyntax {
    if accessLevel == .internal || accessLevel == .private {
        return []
    } else {
        return [DeclModifierSyntax(name: TokenSyntax(stringLiteral: accessLevel.rawValue))]
    }
}
