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

struct Container {
    var id: Int
    var entry: ListEntry<Int>

    init(id: Int) {
        self.id = id
        entry = ListEntry(payload: id)
    }
}

class ListEntryTests: XCTestCase {
    func testList() {
        let head = ListEntry(payload: 0)
        XCTAssertNotNil(head)
    }

    func testEmpty() {
        var head = ListEntry(payload: 0)
        XCTAssertTrue(head.isEmpty)

        var c = Container(id: 1)
        XCTAssertTrue(c.entry.isEmpty)

        head.insert(&c.entry)
        XCTAssertFalse(c.entry.isEmpty)
    }

    func testInitialization() {
        var head = ListEntry(payload: 0)
        var container = Container(id: 1)
        head.insert(&container.entry)

        XCTAssert(head.next == UnsafeMutablePointer(&container.entry))
        XCTAssert(head.prev == UnsafeMutablePointer(&container.entry))
        XCTAssert(container.entry.next == UnsafeMutablePointer(&head))
        XCTAssert(container.entry.prev == UnsafeMutablePointer(&head))

        XCTAssert(head.next.pointee.payload == container.id)
    }

    func testOriginal() {
        var head = ListEntry(payload: 0)
        var container = Container(id: 1)
        // wrong initialization
        XCTAssertTrue(head.isOriginal)
        XCTAssertTrue(container.entry.isOriginal)

        // don't copy the list items. never.
        var headCopy = head
        var containerCopy = container
        XCTAssertFalse(headCopy.isOriginal)
        XCTAssertFalse(containerCopy.entry.isOriginal)
    }

    func testInsert() {
        var head = ListEntry(payload: 0)
        var first = Container(id: 1)
        var second = Container(id: 2)
        head.insert(&first.entry)
        head.insert(&second.entry)

        XCTAssert(head.next == UnsafeMutablePointer(&second.entry))
        XCTAssert(head.next.pointee.next == UnsafeMutablePointer(&first.entry))

        XCTAssert(head.prev == UnsafeMutablePointer(&first.entry))
        XCTAssert(head.prev.pointee.prev == UnsafeMutablePointer(&second.entry))

        XCTAssert(head.next.pointee.payload == 2)
        XCTAssert(head.prev.pointee.payload == 1)
    }

    func testAppend() {
        var head = ListEntry(payload: 0)
        var first = Container(id: 1)
        var second = Container(id: 2)
        head.append(&first.entry)
        head.append(&second.entry)

        XCTAssert(head.next == UnsafeMutablePointer(&first.entry))
        XCTAssert(head.next.pointee.next == UnsafeMutablePointer(&second.entry))

        XCTAssert(head.prev == UnsafeMutablePointer(&second.entry))
        XCTAssert(head.prev.pointee.prev == UnsafeMutablePointer(&first.entry))

        XCTAssert(head.next.pointee.payload == 1)
        XCTAssert(head.prev.pointee.payload == 2)
    }

    func testRemove() {
        var head = ListEntry(payload: 0)
        var container = Container(id: 1)

        head.insert(&container.entry)

        XCTAssertFalse(head.isEmpty)
        XCTAssertFalse(container.entry.isEmpty)

        container.entry.remove()

        XCTAssertTrue(head.isEmpty)
        XCTAssertTrue(container.entry.isEmpty)
    }

    func testFirst() {
        var head = ListEntry(payload: 0)
        XCTAssertNil(head.first)

        var items = allocateList(head: &head, count: 2)
        defer { deallocateList(items: items) }

        guard let first = head.first else {
            XCTFail("first item is nil")
            return
        }
        XCTAssertEqual(first.pointee.payload, 1)
    }

    func testLast() {
        var head = ListEntry(payload: 0)
        XCTAssertNil(head.last)

        var items = allocateList(head: &head, count: 2)
        defer { deallocateList(items: items) }

        guard let last = head.last else {
            XCTFail("last item is nil")
            return
        }
        XCTAssertEqual(last.pointee.payload, 2)
    }


    func testRemoveFirst() {
        var head = ListEntry(payload: 0)
        var items = allocateList(head: &head, count: 2)
        defer { deallocateList(items: items) }

        let removedFirst = head.removeFirst()
        let removedSecond = head.removeFirst()

        XCTAssertTrue(removedFirst.pointee.payload == 1)
        XCTAssertTrue(removedSecond.pointee.payload == 2)
        XCTAssertTrue(head.isEmpty)
    }

    func testRemoveLast() {
        var head = ListEntry(payload: 0)
        var items = allocateList(head: &head, count: 2)
        defer { deallocateList(items: items) }

        let removedSecond = head.removeLast()
        let removedFirst = head.removeLast()

        XCTAssertTrue(removedSecond.pointee.payload == 2)
        XCTAssertTrue(removedFirst.pointee.payload == 1)
        XCTAssertTrue(head.isEmpty)
    }

    func testPopFirst() {
        var head = ListEntry(payload: 0)
        var items = allocateList(head: &head, count: 10)
        defer { deallocateList(items: items) }

        var id = 0
        while let item = head.popFirst() {
            id += 1
            XCTAssertTrue(item.pointee.payload == id)
        }

        XCTAssertEqual(id, 10)
        XCTAssertTrue(head.isEmpty)
    }

    func testPopLast() {
        var head = ListEntry(payload: 0)
        var items = allocateList(head: &head, count: 10)
        defer { deallocateList(items: items) }

        var id = 10
        while let item = head.popLast() {
            XCTAssertTrue(item.pointee.payload == id)
            id -= 1
        }

        XCTAssertEqual(id, 0)
        XCTAssertTrue(head.isEmpty)
    }


    static var allTests = [
        ("testList", testList),
        ("testEmpty", testEmpty),
        ("testInitialization", testInitialization),
        ("testOriginal", testOriginal),
        ("testInsert", testInsert),
        ("testAppend", testAppend),
        ("testRemove", testRemove),
        ("testFirst", testFirst),
        ("testLast", testLast),
        ("testRemoveFirst", testRemoveFirst),
        ("testRemoveLast", testRemoveLast),
        ("testPopFirst", testPopFirst),
        ("testPopLast", testPopLast),
    ]
}
