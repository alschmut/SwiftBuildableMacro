//
//  BuildableStructAccesLevelTests.swift
//
//
//  Created by Alexander Schmutz on 13.06.23.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableStructAccesLevelTests: XCTestCase {
    
    func test_should_apply_fileprivate_access_levels() {
        assertMacroExpansion(
            """
            @Buildable
            fileprivate struct Person {
                let name: String
            }
            """,
            expandedSource: """

            fileprivate struct Person {
                let name: String
            }

            fileprivate struct PersonBuilder {
                fileprivate var name: String = ""

                fileprivate func build() -> Person {
                    return Person(
                        name: name
                    )
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
                
                    \(accessLevel) init(
                        name: String = ""
                    ) {
                        self.name = name
                    }

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
                let age: Int
            }
            """,
            expandedSource: """

            public struct Person {
                let name: String
                let age: Int
            }

            package struct PersonBuilder {
                package var name: String = ""
                package var age: Int = 0

                package init(
                    name: String = "",
                    age: Int = 0
                ) {
                    self.name = name
                    self.age = age
                }

                package func build() -> Person {
                    return Person(
                        name: name,
                        age: age
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
}
