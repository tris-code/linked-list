/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public struct ListEntry<T>: ListEntryProtocol {
    public var payload: T
    public var next: UnsafeMutablePointer<ListEntry>
    public var prev: UnsafeMutablePointer<ListEntry>

    var pointer: UnsafeMutablePointer<ListEntry> {
        @inline(__always) get {
            return self.next.pointee.prev
        }
    }

    public init(payload: T, pointer: UnsafeMutablePointer<ListEntry>) {
        self.payload = payload
        self.next = pointer
        self.prev = pointer
    }
}

// FIXME:
// We need to hide next/prev setters, but it's not possible with a protocol.
// And we can't use generic ListEntry<T> as a constrain.

public protocol ListEntryProtocol {
    associatedtype Payload
    var payload: Payload { get }
    var next: UnsafeMutablePointer<Self> { get set }
    var prev: UnsafeMutablePointer<Self> { get set }
    init(payload: Payload, pointer: UnsafeMutablePointer<Self>)
}

extension UnsafeMutablePointer where Pointee: ListEntryProtocol {
    public var payload: Pointee.Payload {
        @inline(__always) get {
            return pointee.payload
        }
    }

    public var next: UnsafeMutablePointer<Pointee> {
        @inline(__always) get {
            return pointee.next
        }
        @inline(__always) nonmutating set {
            pointee.next = newValue
        }
    }

    public var prev: UnsafeMutablePointer<Pointee> {
        @inline(__always) get {
            return pointee.prev
        }
        @inline(__always) nonmutating set {
            pointee.prev = newValue
        }
    }

    public static func allocate(
        payload: Pointee.Payload
    ) -> UnsafeMutablePointer<Pointee> {
        let pointer = UnsafeMutablePointer<Pointee>.allocate(capacity: 1)
        pointer.initialize(to: Pointee(payload: payload, pointer: pointer))
        return pointer
    }

    public func deallocate() {
        remove()
        self.deallocate(capacity: 1)
    }

    public func remove() {
        prev.next = next
        next.prev = prev
        next = self
        prev = self
    }

    public func insert(_ item: UnsafeMutablePointer<Pointee>) {
        item.prev = self
        item.next = next
        item.next.prev = item
        item.prev.next = item
    }

    public func append(_ item: UnsafeMutablePointer<Pointee>) {
        item.next = self
        item.prev = prev
        item.next.prev = item
        item.prev.next = item
    }

    public var first: UnsafeMutablePointer<Pointee>? {
        guard !isEmpty else {
            return nil
        }
        return next
    }

    public var last: UnsafeMutablePointer<Pointee>? {
        guard !isEmpty else {
            return nil
        }
        return prev
    }

    public func removeFirst() -> UnsafeMutablePointer<Pointee> {
        let result = next
        next.remove()
        return result
    }

    public func removeLast() -> UnsafeMutablePointer<Pointee> {
        let result = prev
        prev.remove()
        return result
    }

    public func popFirst() -> UnsafeMutablePointer<Pointee>? {
        guard !isEmpty else {
            return nil
        }
        return removeFirst()
    }

    public func popLast() -> UnsafeMutablePointer<Pointee>? {
        guard !isEmpty else {
            return nil
        }
        return removeLast()
    }

    // NOTE:
    // 11x faster than default
    public var isEmpty: Bool {
        @inline(never) get {
            return next == self
        }
    }

    // NOTE:
    // default implementation is broken
    public var count: Int{
        var count = 0
        var current = self.next
        while current != self {
            count += 1
            current = current.next
        }
        return count
    }
}
