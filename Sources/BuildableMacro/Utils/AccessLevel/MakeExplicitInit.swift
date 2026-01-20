//
//  MakeExplicitInit.swift
//  Buildable
//
//  Created by Alexander Schmutz on 16.10.25.
//

import SwiftSyntax
import SwiftSyntaxBuilder

func makeExplicitInit(parameters: [InitParameter], accessLevel: AccessLevel) -> InitializerDeclSyntax {
    InitializerDeclSyntax(
        modifiers: makeInnerDeclModifierList(for: accessLevel),
        initKeyword: .init(stringLiteral: "init"),
        signature: FunctionSignatureSyntax(
            parameterClause: FunctionParameterClauseSyntax(
                parameters: FunctionParameterListSyntax {
                    for parameter in parameters {
                        FunctionParameterSyntax(
                            leadingTrivia: .newline,
                            firstName: parameter.identifier,
                            type: parameter.typeForExplicitInit,
                            defaultValue: InitializerClauseSyntax(value: getDefaultValue(from: parameter)),
                            trailingTrivia: parameter.id == parameters.last?.id ? .newline : nil
                        )
                    }
                }
            )
        ),
        bodyBuilder: {
            CodeBlockItemListSyntax {
                for structMember in parameters {
                    makeInitCodeBlockItem(identifier: structMember.identifier)
                }
            }
        }
    )
}

private func getDefaultValue(from parameter: InitParameter) -> ExprSyntax {
    parameter.value.map { ExprSyntax(stringLiteral: $0.text) } ?? getDefaultValueForType(parameter.type) ?? "nil"
}

private func makeInitCodeBlockItem(identifier: TokenSyntax) -> CodeBlockItemSyntax{
    CodeBlockItemSyntax(
        item: CodeBlockItemSyntax.Item(
            InfixOperatorExprSyntax(
                leftOperand: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: "self"),
                    name: identifier
                ),
                operator: AssignmentExprSyntax(),
                rightOperand: DeclReferenceExprSyntax(baseName: identifier)
            )
        )
    )
}
