//
//  InitParameter.swift
//  Buildable
//
//  Created by Alexander Schmutz on 16.10.25.
//

import SwiftSyntax
import Foundation
import SwiftSyntaxBuilder

struct InitParameter: Identifiable {
    let id = UUID()
    let identifier: TokenSyntax
    let type: TypeSyntax
    let value: TokenSyntax?
    
    var typeForExplicitInit: any TypeSyntaxProtocol {
        if type.as(FunctionTypeSyntax.self) != nil {
            return AttributedTypeSyntax(
                specifiers: TypeSpecifierListSyntax {
                    SimpleTypeSpecifierSyntax(specifier: .identifier("@escaping"))
                },
                baseType: type
            )
        } else {
            return type
        }
    }
}
