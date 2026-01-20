//
//  MakeVariableDeclWithValue.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax
import SwiftSyntaxBuilder

func makeVariableDeclWithValue(
    enumMember: EnumMember,
    accessLevel: AccessLevel
) -> VariableDeclSyntax {
    VariableDeclSyntax(
        modifiers: makeInnerDeclModifierList(for: accessLevel),
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: enumMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: enumMember.type),
                initializer: InitializerClauseSyntax(value: MemberAccessExprSyntax(name: enumMember.value))
            )
        }
    )
}
