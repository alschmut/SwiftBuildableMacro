//
//  MakeStructBuilder.swift
//
//
//  Created by Alexander Schmutz on 13.02.24.
//

import SwiftSyntax

func makeStructBuilder(
    structName: TokenSyntax,
    inheritanceClause: InheritanceClauseSyntax?,
    structMembers: [StructMember],
    accessLevel: AccessLevel
) -> StructDeclSyntax {
    StructDeclSyntax(
        modifiers: makeOuterDeclModifierList(for: accessLevel),
        name: getStructBuilderName(from: structName),
        inheritanceClause: getSendableInheritanceClause(original: inheritanceClause)
    ) {
        MemberBlockItemListSyntax {
            for structMember in structMembers {
                MemberBlockItemSyntax(decl: makeVariableDecl(structMember: structMember, accessLevel: accessLevel))
            }
            
            if accessLevel.needsExplicitInit {
                MemberBlockItemSyntax(
                    leadingTrivia: .newlines(2),
                    decl: InitializerDeclSyntax(
                        modifiers: makeInnerDeclModifierList(for: accessLevel),
                        initKeyword: .init(stringLiteral: "init"),
                        signature: FunctionSignatureSyntax(
                            parameterClause: FunctionParameterClauseSyntax(
                                parameters: FunctionParameterListSyntax {
                                    for structMember in structMembers {
                                        FunctionParameterSyntax(
                                            leadingTrivia: .newline,
                                            firstName: structMember.identifier,
                                            type: structMember.type,
                                            defaultValue: InitializerClauseSyntax(value: getDefaultValueForType(structMember.type) ?? "nil"),
                                            trailingTrivia: structMember.id == structMembers.last?.id ? .newline : nil
                                        )
                                    }
                                }
                            )
                        ),
                        bodyBuilder: {
                            CodeBlockItemListSyntax {
                                for structMember in structMembers {
                                    CodeBlockItemSyntax(
                                        item: CodeBlockItemSyntax.Item(
                                            InfixOperatorExprSyntax(
                                                leftOperand: MemberAccessExprSyntax(
                                                    base: DeclReferenceExprSyntax(baseName: "self"),
                                                    name: structMember.identifier
                                                ),
                                                operator: AssignmentExprSyntax(),
                                                rightOperand: DeclReferenceExprSyntax(baseName: structMember.identifier)
                                            )
                                        )
                                    )
                                }
                            }
                        }
                    )
                )
            }
            
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: structName, structMembers: structMembers, accessLevel: accessLevel)
            )
        }
    }
}
