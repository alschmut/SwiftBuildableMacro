# `@Buildable` Swift Macro
`@Buildable` is an attached swift macro for structs, classes and enums, which produces a peer struct implementing the builder pattern. Initialise your object with minimal effort using default values.
```swift
import Buildable

@Buildable
struct Person {
    let name: String
    let age: Int
}

let person = PersonBuilder(age: 42).build()
```

> **Important!**
    <br>- This macro is intended to be used for simple structs, enums and classes (see below limitations)
    <br>- Please report any issues you might encounter
    <br>- Please star this repository, if your project makes use of it :) 

### Table of Contents
- [Detailed Example with generated builder](#Detailed-Example-with-generated-builder)
- [Installation](#Installation)
- [Motivation](#Motivation)
- [Limitations](#Limitations)
- [Builder default values](#Builder-default-values)
- [Roadmap](#Roadmap)

## Detailed Example with generated builder
```swift
import Buildable

@Buildable
struct Person {
    let name: String
    let age: Int
    let address: Address
    let favouriteSeason: Season
}

@Buildable
public enum Season {
    case winter
    case spring
    case summer
    case autumn
}

@Buildable(accessLevel: .internal)
package class AppState {
    let persons: [Person]

    init(
        persons: [Person]
    ) {
        self.persons = persons
    }
}

let anyPerson = PersonBuilder().build()
let max = PersonBuilder(name: "Max", favouriteSeason: .summer).build()
let appState = AppStateBuilder(persons: [max]).build()
```
Expanded macro
```swift
struct PersonBuilder {
    var name: String = ""
    var age: Int = 0
    var address: Address = AddressBuilder().build()
    var favouriteSeason: Season = SeasonBuilder().build()

    func build() -> Person {
        return Person(
            name: name,
            age: age,
            address: address,
            favouriteSeason: favouriteSeason
        )
    }
}

public struct SeasonBuilder {
    public var value: Season = .winter

    public init(
        value: Season = .winter
    ) {
        self.value = value
    }
    
    public func build() -> Season {
        return value
    }
}

struct AppStateBuilder {
    var persons: [Person] = []

    func build() -> AppState {
        return AppState(
            persons: persons
        )
    }
}
```

## Installation
The library can be installed using Swift Package Manager.


## Features
- The macro can be applied to `struct`, `enum` and `class` definitions to generate a builder
- For `struct` definitions without explicit initialisers the macro makes a best guess to derive the memberwise initialiser. Please create a GitHub issue, in case you find any bugs :)
- For every `init`-parameter a type dependent default value is set (see the below table). For unknown/custom types, the macro will expect another builder to be defined somewhere else
    - E.x. a known type: `var number: Int = 0`
    - E.x. an unknown type: `var value: MyValue = MyValueBuilder().build()`
- By default the top level access level (e.x. `public`, `private`, etc.) of `struct`, `enum` and `class` definition is also appled to the builder. If you need the builder to have a lower access level you can define it via `@Buildable(accessLevel: .internal)`

## Limitations
- If a builder for a specific declaration can not be generated, you can always choose to create it yourself by following the below builder naming pattern:
    ```swift
    struct <MyType>Builder {

        func build() -> <MyType> {
            return ...
        }
    }
    ```
- If a class or a struct has one or more initialisers, the macro will use the first/top one
- As of Swift 6.2.0 and Xcode 26.0 (02.10.2025) it is not possible to use the generated builders inside the SwiftUI `#Preview` closure

## Builder default values
The list of default values is limited to the values specified in the below table. 
If a type e.x. `UnknownType` is not part of the list, the macro will set the default value to `UnknownTypeBuilder().build()`, 
assuming that the `UnknownTypeBuilder` was created somewhere else.

| Type | Default Value |
| - | - |
| UnknownType | UnknownTypeBuilder().build() |
| String | "" |
| Int | 0 |
| Bool | false |
| Double | 0 |
| Float | 0 |
| Date | Date() |
| UUID | UUID() |
| [Any] | [] |
| [Any:Any] | [:] |
| Any? | *(implicitly nil)* |
| Any! | *(implicitly nil)* |
| () -> Void | {} |
| (Any) -> Void | { \_ in } |
| (Any, Any) -> Void | { \_, \_ in } |
| Int8 | 0 |
| Int16 | 0 |
| Int32 | 0 |
| Int46 | 0 |
| UInt | 0 |
| UInt8 | 0 |
| UInt16 | 0 |
| UInt32 | 0 |
| UInt46 | 0 |
| Data | Data() |
| URL | URL(string: "https://www.google.com")! |
| CGFloat | 0 |
| CGPoint | CGPoint() |
| CGRect | CGRect() |
| CGSize | CGSize() |
| CGVector | CGVector() |


## Roadmap

The `@Buildable` macro was created out of personal interest to reduce repetitive code in my own projects. I might continue developing the macro depending on use cases I stumble across, though, I do not guarantee to keep the project up to date myself. Please create GitHub issues for any feature or bugfix you would like to see within the macro. Contributions or fixes from the Community are most welcome.
