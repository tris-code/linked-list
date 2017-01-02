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
        var head = ListEntry(payload: 0)
        var first = Container(id: 1)
        var second = Container(id: 2)
        head.append(&first.entry)
        head.append(&second.entry)

        var i = 1
        for item in head {
            XCTAssert(item.pointee.payload == i)
            i += 1
        }

        XCTAssert(i == 3)
    }

    func testCollection() {
        var head = ListEntry(payload: 0)
        var items = allocateList(head: &head, count: 10)
        defer { deallocateList(items: items) }

        var i = 0
        var index = head.startIndex
        while index < head.endIndex {
            i += 1
            XCTAssert(head[index].pointee.payload == i)
            index = head.index(after: index)
        }

        XCTAssertEqual(i, 10)
    }

    func testBidirectionalCollection() {
        var head = ListEntry(payload: 0)
        var items = allocateList(head: &head, count: 10)
        defer { deallocateList(items: items) }

        var i = 10
        var index = head.index(before: head.endIndex)
        while index < head.endIndex {
            XCTAssert(head[index].pointee.payload == i)
            index = head.index(before: index)
            i -= 1
        }

        XCTAssertEqual(i, 0)
    }

    func testEmptySequence() {
        let head = ListEntry(payload: 0)

        var i = 0
        for _ in head {
            i += 1
        }

        XCTAssertEqual(i, 0)
    }

    func testEmptyCollection() {
        let head = ListEntry(payload: 0)

        var i = 0
        for _ in head.indices {
            i += 1
        }

        XCTAssertEqual(i, 0)
    }

    func testCount() {
        var head = ListEntry(payload: 0)
        var first = Container(id: 1)
        var second = Container(id: 2)
        head.append(&first.entry)
        head.append(&second.entry)

        XCTAssertEqual(head.count, 2)
    }

    func testSlice() {
        var head = ListEntry(payload: 0)
        let items = allocateList(head: &head, count: 10)
        defer { deallocateList(items: items) }

        var slice = items.prefix(upTo: items.count)

        var id = 10
        while let last = slice.popLast() {
            XCTAssert(last.pointee.id == id)
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
