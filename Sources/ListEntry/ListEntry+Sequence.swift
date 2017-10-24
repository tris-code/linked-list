/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

// TODO: Contitional conformance would be really great
// extension UnsafeMutablePointer: Sequence where Pointee: ListEntryProtocol

extension ListEntry: Sequence {
    public typealias Iterator = ListEntryIterator<T>
    public func makeIterator() -> ListEntryIterator<T> {
        return ListEntryIterator<T>(head: pointer)
    }
}

public struct ListEntryIterator<T>: IteratorProtocol {
    var head: UnsafeMutablePointer<ListEntry<T>>
    var current: UnsafeMutablePointer<ListEntry<T>>

    init(head: UnsafeMutablePointer<ListEntry<T>>) {
        self.head = head
        self.current = head.pointee.next
    }

    public mutating func next() -> UnsafeMutablePointer<ListEntry<T>>? {
        guard current != head else {
            return nil
        }
        let result = current
        current = current.pointee.next
        return result
    }
}
