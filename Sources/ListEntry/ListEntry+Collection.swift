/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

extension ListEntry: BidirectionalCollection {
    public typealias Index = UnsafeMutablePointer<ListEntry<T>>
    public var startIndex: Index {
        return pointer.next
    }

    public var endIndex: Index {
        return pointer
    }

    public subscript(position: Index) -> UnsafeMutablePointer<ListEntry<T>> {
        return position
    }

    public func index(after index: Index) -> Index {
        return index.pointee.next
    }

    public func index(before index: Index) -> Index {
        return index.pointee.prev
    }
}
