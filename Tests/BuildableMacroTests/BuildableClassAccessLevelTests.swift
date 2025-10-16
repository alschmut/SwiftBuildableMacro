//
//  BuildableClassAccessLevelTests.swift
//
//
//  Created by Alexander Schmutz on 09.02.24.
//

import XCTest
import SwiftSyntaxMacrosTestSupport

class BuildableClassAccessLevelTests: XCTestCase {
    
    func test_should_apply_fileprivate_access_level() {
        assertMacroExpansion(
            """
            @Buildable
            fileprivate class MyClass {
                let m1: String

                fileprivate init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            fileprivate class MyClass {
                let m1: String

                fileprivate init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }

            fileprivate struct MyClassBuilder {
                fileprivate var m1: String = ""

                fileprivate func build() -> MyClass {
                    return MyClass(
                        m1: m1
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
                \(accessLevel) class MyClass {
                    let m1: String

                    \(accessLevel) init(
                        m1: String = ""
                    ) {
                        self.m1 = m1
                    }
                }
                """,
                expandedSource: """

                \(accessLevel) class MyClass {
                    let m1: String

                    \(accessLevel) init(
                        m1: String = ""
                    ) {
                        self.m1 = m1
                    }
                }

                \(accessLevel) struct MyClassBuilder {
                    \(accessLevel) var m1: String = ""

                    \(accessLevel) init(
                        m1: String = ""
                    ) {
                        self.m1 = m1
                    }

                    \(accessLevel) func build() -> MyClass {
                        return MyClass(
                            m1: m1
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
            internal class MyClass {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            internal class MyClass {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }

            struct MyClassBuilder {
                var m1: String = ""

                func build() -> MyClass {
                    return MyClass(
                        m1: m1
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
            private class MyClass {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            private class MyClass {
                let m1: String

                init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }

            private struct MyClassBuilder {
                var m1: String = ""

                func build() -> MyClass {
                    return MyClass(
                        m1: m1
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
            @Buildable(accessLevel: .fileprivate)
            public class MyClass {
                let m1: String

                public init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }
            """,
            expandedSource: """

            public class MyClass {
                let m1: String

                public init(
                    m1: String = ""
                ) {
                    self.m1 = m1
                }
            }

            fileprivate struct MyClassBuilder {
                fileprivate var m1: String = ""

                fileprivate func build() -> MyClass {
                    return MyClass(
                        m1: m1
                    )
                }
            }

            """,
            macros: testMacros
        )
    }
}

