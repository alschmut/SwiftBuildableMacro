import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct BuildablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BuildableMacroType.self
    ]
}

public struct BuildableMacroType: PeerMacro {
    public static func expansion<Context, Declaration>(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [SwiftSyntax.DeclSyntax] where Context : SwiftSyntaxMacros.MacroExpansionContext, Declaration : SwiftSyntax.DeclSyntaxProtocol {
        
        let accessLevel = extractAccessLevelMacroParameter(from: node)
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            let structBuilder = try generateBuilderFromStruct(structDecl: structDecl, accessLevel: accessLevel)
            return [DeclSyntax(structBuilder)]
        }

        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            let enumBuilder = try generateBuilderFromEnum(enumDecl: enumDecl, accessLevel: accessLevel)
            return [DeclSyntax(enumBuilder)]
        }

        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            let classBuilder = try generateBuilderFromClass(classDecl: classDecl, accessLevel: accessLevel)
            return [DeclSyntax(classBuilder)]
        }

        throw "Macro can only be applied to struct, class and enum declarations"
    }
}


