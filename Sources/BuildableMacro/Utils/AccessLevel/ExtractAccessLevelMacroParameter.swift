//
//  ExtractAccessLevelMacroParameter.swift
//  Buildable
//
//  Created by Alexander Schmutz on 12.10.25.
//

import SwiftSyntax

func extractAccessLevelMacroParameter(
    from node: AttributeSyntax
) -> AccessLevel? {
    guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
        return nil
    }
    
    for argument in arguments {
        if argument.label?.text == "accessLevel",
           let declName = argument.expression.as(MemberAccessExprSyntax.self)?.declName,
           let accessLevel = AccessLevel(rawValue: declName.baseName.trimmedDescription)
        {
            return accessLevel
        }
    }
    
    return nil
}
