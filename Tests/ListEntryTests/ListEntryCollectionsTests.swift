/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************
 *  This file contains code that has not yet been described                   *
 ******************************************************************************/

import Test
@testable import ListEntry

class ListEntryCollectionsTests: TestCase {
    func testSequence() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var i = 0
        for item in head.pointee {
            i += 1
            assertEqual(item.pointee.payload, i)
        }

        assertEqual(i, 10)
    }

    func testCollection() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var i = 0
        var index = head.pointee.startIndex
        while index != head.pointee.endIndex {
            i += 1
            assertEqual(head.pointee[index].pointee.payload, i)
            index = head.pointee.index(after: index)
        }

        assertEqual(i, 10)
    }

    func testBidirectionalCollection() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var i = 10
        var index = head.pointee.index(before: head.pointee.endIndex)
        while index != head.pointee.endIndex {
            assertEqual(head.pointee[index].pointee.payload, i)
            index = head.pointee.index(before: index)
            i -= 1
        }

        assertEqual(i, 0)
    }

    func testEmptySequence() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        var i = 0
        for _ in head.pointee {
            i += 1
        }

        assertEqual(i, 0)
    }

    func testEmptyCollection() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        var i = 0
        for _ in head.pointee.indices {
            i += 1
        }

        assertEqual(i, 0)
    }

    func testCount() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        assertEqual(head.count, 10)
    }

    func testSlice() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var slice = items.prefix(upTo: items.count)

        var id = 10
        while let last = slice.popLast() {
            assertEqual(last.id, id)
            id -= 1
        }

        assertEqual(id, 0)
        assertTrue(slice.isEmpty)
        assertFalse(head.isEmpty)
    }


    static var allTests = [
        ("testSequence", testSequence),
        ("testCollection", testCollection),
        ("testBidirectionalCollection", testBidirectionalCollection),
        ("testEmptySequence", testEmptySequence),
        ("testEmptyCollection", testEmptyCollection),
        ("testCount", testCount),
        ("testSlice", testSlice),
    ]
}
