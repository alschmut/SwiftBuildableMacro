//
//  GenerateBuilderFromClass.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax

func generateBuilderFromClass(classDecl: ClassDeclSyntax, accessLevel: AccessLevel?) throws -> StructDeclSyntax {
    guard let initialiserDecl = getFirstInitialiser(from: classDecl.memberBlock) else {
        throw "Missing initialiser"
    }
    let givenAccessLevel = getAccessLevel(from: classDecl.modifiers)
    let validAccessLevel = try getValidAccessLevels(givenAccessLevel: givenAccessLevel, desiredAccessLevel: accessLevel)
    return makeStructBuilder(
        structName: classDecl.name,
        inheritanceClause: classDecl.inheritanceClause,
        structMembers: extractInitializerMembers(from: initialiserDecl),
        accessLevel: validAccessLevel
    )
}
