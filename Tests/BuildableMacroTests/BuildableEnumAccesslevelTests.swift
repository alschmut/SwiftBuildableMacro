//
//  BuildableEnumAccessLevelTests.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableEnumAccessLevelTests: XCTestCase {
    
    func test_should_apply_fileprivate_access_level() {
        assertMacroExpansion(
            """
            @Buildable
            fileprivate enum MyEnum {
                case myCase
            }
            """,
            expandedSource: """
            
            fileprivate enum MyEnum {
                case myCase
            }
            
            fileprivate struct MyEnumBuilder {
                fileprivate var value: MyEnum = .myCase
            
                fileprivate func build() -> MyEnum {
                    return value
                }
            }
            
            """,
            macros: testMacros
        )
    }
    
    func test_should_apply_public_and_package_access_levels_with_init() {
        let accessLevels = [
            "package",
            "public"
        ]
        for accessLevel in accessLevels {
            assertMacroExpansion(
                """
                @Buildable
                \(accessLevel) enum MyEnum {
                    case myCase
                }
                """,
                expandedSource: """
                
                \(accessLevel) enum MyEnum {
                    case myCase
                }
                
                \(accessLevel) struct MyEnumBuilder {
                    \(accessLevel) var value: MyEnum = .myCase
                
                    \(accessLevel) init(
                        value: MyEnum = .myCase
                    ) {
                        self.value = value
                    }
                
                    \(accessLevel) func build() -> MyEnum {
                        return value
                    }
                }
                
                """,
                macros: testMacros
            )
        }
    }
    
    func test_should_not_print_internal_access_level() {
        assertMacroExpansion(
            """
            @Buildable
            internal enum MyEnum {
                case myCase
            }
            """,
            expandedSource: """

            internal enum MyEnum {
                case myCase
            }

            struct MyEnumBuilder {
                var value: MyEnum = .myCase

                func build() -> MyEnum {
                    return value
                }
            }

            """,
            macros: testMacros
        )
    }
    
    func test_should_apply_private_access_level_not_for_inner_properties() {
        assertMacroExpansion(
            """
            @Buildable
            private enum MyEnum {
                case myCase
            }
            """,
            expandedSource: """

            private enum MyEnum {
                case myCase
            }

            private struct MyEnumBuilder {
                var value: MyEnum = .myCase

                func build() -> MyEnum {
                    return value
                }
            }

            """,
            macros: testMacros
        )
    }
    
    func test_should_apply_custom_access_level() {
        assertMacroExpansion(
            """
            @Buildable(accessLevel: .internal)
            public enum MyEnum {
                case myCase
            }
            """,
            expandedSource: """

            public enum MyEnum {
                case myCase
            }

            struct MyEnumBuilder {
                var value: MyEnum = .myCase

                func build() -> MyEnum {
                    return value
                }
            }

            """,
            macros: testMacros
        )
    }
}

