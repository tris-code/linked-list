/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

extension ListEntry: Sequence {
    public typealias Iterator = ListEntryIterator<T>
    public func makeIterator() -> ListEntryIterator<T> {
        // NOTE:
        // can't implement mutating makeIterator
        // so we make a copy, and get self pointer through next->prev
        var head = self
        return ListEntryIterator<T>(head: head.originalPointer)
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
