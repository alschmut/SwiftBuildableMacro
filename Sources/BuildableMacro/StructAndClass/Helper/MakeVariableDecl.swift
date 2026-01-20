//
//  MakeVariableDecl.swift
//
//
//  Created by Alexander Schmutz on 03.07.23.
//

import SwiftSyntax
import SwiftSyntaxBuilder

func makeVariableDecl(
    structMember: StructMember,
    accessLevel: AccessLevel
) -> VariableDeclSyntax {
    VariableDeclSyntax(
        modifiers: makeInnerDeclModifierList(for: accessLevel),
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: structMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: structMember.type),
                initializer: getDefaultInitializerClause(type: structMember.type)
            )
        }
    )
}

private func getDefaultInitializerClause(type: TypeSyntax) -> InitializerClauseSyntax? {
    guard let defaultExpr = getDefaultValueForType(type) else { return nil }
    return InitializerClauseSyntax(value: defaultExpr)
}
