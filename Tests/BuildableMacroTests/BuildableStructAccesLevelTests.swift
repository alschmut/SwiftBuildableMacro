//
//  BuildableStructAccesLevelTests.swift
//
//
//  Created by Alexander Schmutz on 13.06.23.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableStructAccesLevelTests: XCTestCase {
    
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
                \(accessLevel) struct Person {
                    let name: String
                }
                """,
                expandedSource: """

                \(accessLevel) struct Person {
                    let name: String
                }

                \(accessLevel) struct PersonBuilder {
                    \(accessLevel) var name: String = ""

                    \(accessLevel) func build() -> Person {
                        return Person(
                            name: name
                        )
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
            internal struct Person {
                let name: String
            }
            """,
            expandedSource: """

            internal struct Person {
                let name: String
            }

            struct PersonBuilder {
                var name: String = ""

                func build() -> Person {
                    return Person(
                        name: name
                    )
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
            private struct Person {
                let name: String
            }
            """,
            expandedSource: """

            private struct Person {
                let name: String
            }

            private struct PersonBuilder {
                var name: String = ""

                func build() -> Person {
                    return Person(
                        name: name
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func test_should_apply_custom_package_access_level() {
        assertMacroExpansion(
            """
            @Buildable(accessLevel: .package)
            public struct Person {
                let name: String
            }
            """,
            expandedSource: """

            public struct Person {
                let name: String
            }

            package struct PersonBuilder {
                package var name: String = ""

                package func build() -> Person {
                    return Person(
                        name: name
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
}
