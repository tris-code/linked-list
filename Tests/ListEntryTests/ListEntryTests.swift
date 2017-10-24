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

class ListEntryTests: XCTestCase {
    func testList() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        XCTAssertNotNil(head)
    }

    func testEmpty() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        XCTAssertTrue(head.isEmpty)

        let c = Container(id: 1)
        XCTAssertTrue(c.entry.isEmpty)

        head.insert(c.entry)
        XCTAssertFalse(c.entry.isEmpty)
    }

    func testInitialization() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let container = Container(id: 1)

        head.insert(container.entry)

        XCTAssert(head.next == container.entry)
        XCTAssert(head.prev == container.entry)
        XCTAssert(container.entry.next == head)
        XCTAssert(container.entry.prev == head)

        XCTAssert(head.next.pointee.payload == container.id)
    }

    func testInsert() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let first = Container(id: 1)
        let second = Container(id: 2)
        head.insert(first.entry)
        head.insert(second.entry)

        XCTAssert(head.next == second.entry)
        XCTAssert(head.next.next == first.entry)

        XCTAssert(head.prev == first.entry)
        XCTAssert(head.prev.prev == second.entry)

        XCTAssert(head.next.payload == 2)
        XCTAssert(head.prev.payload == 1)
    }

    func testAppend() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let first = Container(id: 1)
        let second = Container(id: 2)
        head.append(first.entry)
        head.append(second.entry)

        XCTAssert(head.next == first.entry)
        XCTAssert(head.next.pointee.next == second.entry)

        XCTAssert(head.prev == second.entry)
        XCTAssert(head.prev.pointee.prev == first.entry)

        XCTAssert(head.next.pointee.payload == 1)
        XCTAssert(head.prev.pointee.payload == 2)
    }

    func testRemove() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let container = Container(id: 1)

        head.insert(container.entry)

        XCTAssertFalse(head.isEmpty)
        XCTAssertFalse(container.entry.isEmpty)

        container.entry.remove()

        XCTAssertTrue(head.isEmpty)
        XCTAssertTrue(container.entry.isEmpty)
    }

    func testFirst() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        XCTAssertNil(head.first)

        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        guard let first = head.first else {
            XCTFail("first item is nil")
            return
        }
        XCTAssertEqual(first.payload, 1)
    }

    func testLast() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        XCTAssertNil(head.last)

        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        guard let last = head.last else {
            XCTFail("last item is nil")
            return
        }
        XCTAssertEqual(last.pointee.payload, 2)
    }

    func testRemoveFirst() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        let removedFirst = head.removeFirst()
        let removedSecond = head.removeFirst()

        XCTAssertTrue(removedFirst.pointee.payload == 1)
        XCTAssertTrue(removedSecond.pointee.payload == 2)
        XCTAssertTrue(head.isEmpty)
    }

    func testRemoveLast() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        let removedSecond = head.removeLast()
        let removedFirst = head.removeLast()

        XCTAssertTrue(removedSecond.pointee.payload == 2)
        XCTAssertTrue(removedFirst.pointee.payload == 1)
        XCTAssertTrue(head.isEmpty)
    }

    func testPopFirst() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var id = 0
        while let item = head.popFirst() {
            id += 1
            XCTAssertTrue(item.pointee.payload == id)
        }

        XCTAssertEqual(id, 10)
        XCTAssertTrue(head.isEmpty)
    }

    func testPopLast() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

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
