import Buildable
import Foundation

@Buildable
public struct MyObject {
    let m01: String
    let m02: Int
    let m03: Int8
    let m04: Int16
    let m05: Int32
    let m06: Int64
    let m07: UInt
    let m08: UInt8
    let m09: UInt16
    let m10: UInt32
    let m11: UInt64
    let m12: Bool
    let m13: Double
    let m14: Float
    let m15: Date
    let m16: UUID
    let m17: Data
    let m18: URL
    let m19: CGFloat
    let m20: CGPoint
    let m21: CGRect
    let m22: CGSize
    let m23: CGVector
    let m24: String?
    let m25: String!
    let m26: [String]
    let m27: [String: String]
    var m28: String
    let m29: () -> Void
    let m30: (() -> Void)?
    let m31: (() -> Void)!
    let m32: (String) -> Void
    let m33: ((String) -> Void)?
    let m34: (String, Int) -> Void
    let m35: (String, Int) -> String
    var myEnum: MyEnum
}

@Buildable
public enum MyEnum {
    case `none`
    case myCase
}

@Buildable
final class MyClass: Sendable {
    let m1: String

    init(
        m1: String
    ) {
        self.m1 = m1
    }
}

@Buildable
package struct MyStruct {
    let m1: String
    let fix: String = ""
}

@Buildable
public struct Person: Sendable {
    let name: String
    let age: Int
    let address: Address
    let favouriteSeason: Season
}

@Buildable
public enum Season: Sendable {
    case winter
    case spring
    case summer
    case autumn
}

@Buildable(accessLevel: .private)
package class AppState {
    let persons: [Person]

    init(
        persons: [Person]
    ) {
        self.persons = persons
    }
}

@Buildable
public struct Address: Sendable {}

let anyPerson = PersonBuilder().build()
let max = PersonBuilder(name: "Max", favouriteSeason: .summer).build()
let appState = AppStateBuilder(persons: [max]).build()
