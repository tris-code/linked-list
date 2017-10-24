/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import XCTest
@testable import ListEntry

class ListEntryCollectionsTests: XCTestCase {
    func testSequence() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var i = 0
        for item in head.pointee {
            i += 1
            XCTAssert(item.pointee.payload == i)
        }

        XCTAssertEqual(i, 10)
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
            XCTAssert(head.pointee[index].pointee.payload == i)
            index = head.pointee.index(after: index)
        }

        XCTAssertEqual(i, 10)
    }

    func testBidirectionalCollection() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var i = 10
        var index = head.pointee.index(before: head.pointee.endIndex)
        while index != head.pointee.endIndex {
            XCTAssert(head.pointee[index].pointee.payload == i)
            index = head.pointee.index(before: index)
            i -= 1
        }

        XCTAssertEqual(i, 0)
    }

    func testEmptySequence() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        var i = 0
        for _ in head.pointee {
            i += 1
        }

        XCTAssertEqual(i, 0)
    }

    func testEmptyCollection() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        var i = 0
        for _ in head.pointee.indices {
            i += 1
        }

        XCTAssertEqual(i, 0)
    }

    func testCount() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        XCTAssertEqual(head.count, 10)
    }

    func testSlice() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }

        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var slice = items.prefix(upTo: items.count)

        var id = 10
        while let last = slice.popLast() {
            XCTAssert(last.id == id)
            id -= 1
        }

        XCTAssertEqual(id, 0)
        XCTAssertTrue(slice.isEmpty)
        XCTAssertFalse(head.isEmpty)
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
