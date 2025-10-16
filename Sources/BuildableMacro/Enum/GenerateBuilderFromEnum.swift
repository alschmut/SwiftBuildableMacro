//
//  GenerateBuilderFromEnum.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func generateBuilderFromEnum(enumDecl: EnumDeclSyntax, accessLevel: AccessLevel?) throws -> StructDeclSyntax {
    let enumMember = EnumMember(
        identifier: TokenSyntax(stringLiteral: "value"),
        type: TypeSyntax(stringLiteral: enumDecl.name.text),
        value: try getFirstEnumCaseName(from: enumDecl)
    )
    
    let accessLevel = accessLevel ?? getAccessLevel(from: enumDecl.modifiers)

    return StructDeclSyntax(
        modifiers: makeOuterDeclModifierList(for: accessLevel),
        name: getStructBuilderName(from: enumDecl.name),
        inheritanceClause: getSendableInheritanceClause(original: enumDecl.inheritanceClause)
    ) {
        MemberBlockItemListSyntax {
            MemberBlockItemSyntax(
                decl: makeVariableDeclWithValue(enumMember: enumMember, accessLevel: accessLevel)
            )
            
            if accessLevel.needsExplicitInit {
                MemberBlockItemSyntax(
                    leadingTrivia: .newlines(2),
                    decl: makeExplicitInit(parameters: [enumMember.asInitParameter], accessLevel: accessLevel)
                )
            }
            
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDeclWithValue(enumMember: enumMember, accessLevel: accessLevel)
            )
        }
    }
}
