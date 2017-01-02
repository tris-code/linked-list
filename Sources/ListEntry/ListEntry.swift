/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public struct ListEntry<T> {
    public var payload: T
    public private(set) lazy var next: UnsafeMutablePointer<ListEntry> = UnsafeMutablePointer(&self)
    public private(set) lazy var prev: UnsafeMutablePointer<ListEntry> = UnsafeMutablePointer(&self)

    var originalPointer: UnsafeMutablePointer<ListEntry> {
        mutating get {
            return self.next.pointee.prev
        }
    }

    public init(payload: T) {
        self.payload = payload
    }

    mutating func create() {
        next = UnsafeMutablePointer(&self)
        prev = UnsafeMutablePointer(&self)
    }

    public mutating func remove() {
        prev.pointee.next = next
        next.pointee.prev = prev
        create()
    }

    public mutating func insert(_ item: UnsafeMutablePointer<ListEntry>) {
        item.pointee.prev = UnsafeMutablePointer(&self)
        item.pointee.next = next
        item.pointee.next.pointee.prev = item
        item.pointee.prev.pointee.next = item
    }

    public mutating func append(_ item: UnsafeMutablePointer<ListEntry>) {
        item.pointee.next = UnsafeMutablePointer(&self)
        item.pointee.prev = prev
        item.pointee.next.pointee.prev = item
        item.pointee.prev.pointee.next = item
    }

    public var first: UnsafeMutablePointer<ListEntry>? {
        var head = self
        if head.isEmpty {
            return nil
        }
        return head.next
    }

    public var last: UnsafeMutablePointer<ListEntry>? {
        var head = self
        if head.isEmpty {
            return nil
        }
        return head.prev
    }

    public mutating func removeFirst() -> UnsafeMutablePointer<ListEntry> {
        let result = next
        next.pointee.remove()
        return result
    }

    public mutating func removeLast() -> UnsafeMutablePointer<ListEntry> {
        let result = prev
        prev.pointee.remove()
        return result
    }

    public mutating func popFirst() -> UnsafeMutablePointer<ListEntry>? {
        if isEmpty {
            return nil
        }
        return removeFirst()
    }

    public mutating func popLast() -> UnsafeMutablePointer<ListEntry>? {
        if isEmpty {
            return nil
        }
        return removeLast()
    }

    // NOTE:
    // 11x faster than default
    public var isEmpty: Bool {
        @inline(never)
        mutating get {
            return next == next.pointee.prev
        }
    }

    // NOTE:
    // default implementation is broken
    public var count: Int{
        var count = 0
        var copy = self
        let head = copy.originalPointer
        var next = copy.next
        while next != head {
            count += 1
            next = next.pointee.next
        }
        return count
    }

    // for the tests
    var isOriginal: Bool {
        mutating get {
            return next.pointee.prev == UnsafeMutablePointer(&self)
        }
    }
}
