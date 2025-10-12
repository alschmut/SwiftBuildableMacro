//
//  BuildableEnumTests.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableEnumTests: XCTestCase {
    func test_should_create_macro_from_enum() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum {
                case myCase
            }
            """,
            expandedSource: """

            enum MyEnum {
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

    func test_should_set_first_enum_case_as_default_value() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum {
                case myCase, mySecondCase
            }
            """,
            expandedSource: """

            enum MyEnum {
                case myCase, mySecondCase
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

    func test_should_set_first_enum_case_as_default_value_when_enum_has_rawvalue() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum: String {
                case myCase = "a"
                case mySecondCase = "b"
            }
            """,
            expandedSource: """

            enum MyEnum: String {
                case myCase = "a"
                case mySecondCase = "b"
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

    func test_should_set_first_enum_case_as_default_value_when_identifier_uses_special_keyword() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum {
                case `none`
            }
            """,
            expandedSource: """

            enum MyEnum {
                case `none`
            }

            struct MyEnumBuilder {
                var value: MyEnum = .`none`

                func build() -> MyEnum {
                    return value
                }
            }

            """,
            macros: testMacros
        )
    }

    func test_should_set_first_enum_case_as_default_value_when_first_enum_member_is_no_case_declaration() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum {
                var someVariable: String? { nil }
                case myCase
            }
            """,
            expandedSource: """

            enum MyEnum {
                var someVariable: String? { nil }
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

    func test_should_make_enum_sendable() {
        assertMacroExpansion(
            """
            @Buildable
            enum MyEnum: Sendable {
                case myCase
            }
            """,
            expandedSource: """

            enum MyEnum: Sendable {
                case myCase
            }

            struct MyEnumBuilder : Sendable {
                var value: MyEnum = .myCase

                func build() -> MyEnum {
                    return value
                }
            }

            """,
            macros: testMacros
        )
    }
    
    func test_should_apply_access_levels() {
        let accessLevels = [
            "fileprivate",
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

