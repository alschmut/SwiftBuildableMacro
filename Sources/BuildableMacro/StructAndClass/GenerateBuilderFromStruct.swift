//
//  GenerateBuilderFromStruct.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func generateBuilderFromStruct(structDecl: StructDeclSyntax, accessLevel: AccessLevel?) -> StructDeclSyntax {
    return makeStructBuilder(
        structName: structDecl.name,
        inheritanceClause: structDecl.inheritanceClause,
        structMembers: getStructMembers(structDecl: structDecl),
        accessLevel: accessLevel ?? getAccessLevel(from: structDecl.modifiers)
    )
}

private func getStructMembers(structDecl: StructDeclSyntax) -> [StructMember] {
    if let initialiserDecl = getFirstInitialiser(from: structDecl.memberBlock) {
        return extractInitializerMembers(from: initialiserDecl)
    } else {
        return extractMembersFrom(structDecl.memberBlock.members)
    }
}
