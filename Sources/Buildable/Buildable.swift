// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces a peer struct which implements the builder pattern
///
///     @Buildable
///     struct Person {
///         let name: String
///         let age: Int
///         let address: Address
///         let favouriteSeason: Season
///     }
///
///     @Buildable
///     public enum Season {
///         case winter
///         case spring
///         case summer
///         case autumn
///     }
///
///     @Buildable(accessLevel: .internal)
///     package class AppState {
///         let persons: [Person]
///
///         init(
///             persons: [Person]
///         ) {
///             self.persons = persons
///         }
///     }
///
///  will expand to
///
///     struct PersonBuilder {
///         var name: String = ""
///         var age: Int = 0
///         var address: Address = AddressBuilder().build()
///         var favouriteSeason: Season = SeasonBuilder().build()
///
///         func build() -> Person {
///             return Person(
///                 name: name,
///                 age: age,
///                 address: address,
///                 favouriteSeason: favouriteSeason
///             )
///         }
///     }
///
///     public struct SeasonBuilder {
///         public var value: Season = .winter
///
///         public init(
///             value: Season = .winter
///         ) {
///             self.value = value
///         }
///
///         public func build() -> Season {
///             return value
///         }
///     }
///
///     struct AppStateBuilder {
///         var persons: [Person] = []
///
///         func build() -> AppState {
///             return AppState(
///                 persons: persons
///             )
///         }
///     }
///
/// - Parameters:
///   - accessLevel: The access level (e.x. `.private`, `.public`, etc.), which the generated Builder will have. If you set the value to nil, the generated Builder has the same access level as the original struct/class/enum to which the macro was applied to. The default value of this parameter is nil.
@attached(peer, names: suffixed(Builder))
public macro Buildable(accessLevel: AccessLevel? = nil) = #externalMacro(
    module: "BuildableMacro",
    type: "BuildableMacroType"
)
