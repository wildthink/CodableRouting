//

import Foundation

struct RouteDecodingError: Error { }

public func decode<R: Decodable>(_ path: String) throws -> R {
    guard path.first == "/" else {
        throw RouteDecodingError()
    }
    let components = path.dropFirst().split(separator: "/", omittingEmptySubsequences: false).map { String($0) }
    let decoder = RouteDecoder(components: Box(components))
    return try R.init(from: decoder)
}

struct RouteDecoder: Decoder {
    var components: Box<[String]>
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer(RouteKDC(components: components))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw NotImplementedError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw NotImplementedError()
    }
}

struct RouteKDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var components: Box<[String]>
    var codingPath: [CodingKey] = []
    var allKeys: [Key] = []

    init(components: Box<[String]>) {
        self.components = components
        if let c = components.value.first, let k = Key(stringValue: c) {
            self.components.value.removeFirst()
            allKeys = [k]
        }
    }

    func contains(_ key: Key) -> Bool {
        if key.stringValue.hasPrefix("_") {
            return true
        }
        return false
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        return components.value.isEmpty
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        throw NotImplementedError()
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        throw NotImplementedError()
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let f = components.value.first, let i = Double(f) else {
            throw RouteDecodingError()
        }
        return i
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let f = components.value.first, let i = Float(f) else {
            throw RouteDecodingError()
        }
        return i
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        // jmj
        try decode(int: type, forKey: key)
//        guard let f = components.value.first, let i = Int(f) else {
//            throw RouteDecodingError()
//        }
//        return i
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try decode(int: type, forKey: key)
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try decode(int: type, forKey: key)
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        let decoder = RouteDecoder(components: components)
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        KeyedDecodingContainer(RouteKDC<NestedKey>(components: components))
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw NotImplementedError()
    }

    func superDecoder() throws -> Decoder {
        throw NotImplementedError()
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        throw NotImplementedError()
    }
}

extension RouteKDC {
    func decode<IValue: FixedWidthInteger>(int type: IValue.Type, forKey key: Key) throws -> IValue {
        guard let f = components.value.first, let i = IValue(f) else {
            throw RouteDecodingError()
        }
        return i
    }
}
