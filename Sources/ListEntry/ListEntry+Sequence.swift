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
