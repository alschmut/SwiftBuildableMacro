//
//  EnumMember.swift
//  
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct EnumMember {
    let identifier: TokenSyntax
    let type: TypeSyntax
    let value: TokenSyntax
    
    var asInitParameter: InitParameter {
        InitParameter(
            identifier: identifier,
            type: type,
            value: TokenSyntax(stringLiteral: "." + value.text)
        )
    }
}
