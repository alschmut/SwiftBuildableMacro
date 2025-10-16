//
//  InitParameter.swift
//  Buildable
//
//  Created by Alexander Schmutz on 16.10.25.
//

import SwiftSyntax
import Foundation

struct InitParameter: Identifiable {
    let id = UUID()
    let identifier: TokenSyntax
    let type: TypeSyntax
    let value: TokenSyntax?
}
