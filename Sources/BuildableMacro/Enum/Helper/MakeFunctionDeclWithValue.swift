//
//  MakeFunctionDeclWithValue.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func makeFunctionDeclWithValue(
    enumMember: EnumMember,
    accessLevel: AccessLevel
) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: enumMember.type, accessLevel: accessLevel) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: enumMember.identifier.trimmed),
                    leftParen: nil,
                    arguments: LabeledExprListSyntax([]),
                    rightParen: nil
                )
            )
        )
    }
}
