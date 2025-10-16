//
//  StructMember.swift
//  
//
//  Created by Alexander Schmutz on 09.02.24.
//

import SwiftSyntax
import Foundation

struct StructMember: Identifiable {
    let id = UUID()
    let identifier: TokenSyntax
    let type: TypeSyntax
}
