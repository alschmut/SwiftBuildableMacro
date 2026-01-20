//
//  MakeBuildFunctionDecl.swift
//  
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax
import SwiftSyntaxBuilder

func makeBuildFunctionDecl(
    returningType: TypeSyntax,
    accessLevel: AccessLevel,
    body: () -> ReturnStmtSyntax
) -> FunctionDeclSyntax {
    let buildFunctionSignature = FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax([])),
        returnClause: ReturnClauseSyntax(type: returningType)
    )

    return FunctionDeclSyntax(
        modifiers: makeInnerDeclModifierList(for: accessLevel),
        name: .identifier("build"),
        signature: buildFunctionSignature
    ) {
        CodeBlockItemListSyntax {
            CodeBlockItemSyntax(
                item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(body()))
            )
        }
    }
}
