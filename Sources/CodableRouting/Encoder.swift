//

import Foundation

public func encode<R: Encodable>(_ value: R) throws -> String {
    let encoder = RouteEncoder(components: Box([]))
    try value.encode(to: encoder)
    let path = encoder.components.value.joined(separator: "/")
    return "/\(path)"
}

final class Box<Value> {
    var value: Value
    init(_ value: Value) {
        self.value = value
    }
}

struct RouteEncoder: Encoder {
    var components: Box<[String]>

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        KeyedEncodingContainer(RouteKEC(components: components))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }
}

struct RouteKEC<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var components: Box<[String]>
    var codingPath: [CodingKey] = []

    mutating func encodeNil(forKey key: Key) throws {
        throw NotImplementedError()
    }

    mutating func encode(_ value: Bool, forKey key: Key) throws {
        throw NotImplementedError()
    }

    mutating func encode(_ value: String, forKey key: Key) throws {
        throw NotImplementedError()
    }

    mutating func encode(_ value: Double, forKey key: Key) throws {
        components.value.append(String(format: "%.2f", value))
    }

    mutating func encode(_ value: Float, forKey key: Key) throws {
        components.value.append(String(format: "%.2f", value))
    }

    mutating func encode(_ value: Int, forKey key: Key) throws {
//        components.value.append("\(value)")
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: Int8, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: Int16, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: Int32, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: Int64, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: UInt, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        try encode(int: value, forKey: key)
    }

    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        let encoder = RouteEncoder(components: components)
        try value.encode(to: encoder)
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        components.value.append(key.stringValue)
        return KeyedEncodingContainer(RouteKEC<NestedKey>(components: components))
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError()
    }

    mutating func superEncoder() -> Encoder {
        fatalError()
    }

    mutating func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }


}

extension RouteKEC {
    mutating func encode<IValue: FixedWidthInteger>(int value: IValue, forKey key: Key)
    throws
    {
        components.value.append("\(value)")
    }
}
