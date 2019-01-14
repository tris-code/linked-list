import Test
@testable import ListEntry

class ListEntryTests: TestCase {
    func testList() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        assertNotNil(head)
    }

    func testEmpty() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        assertTrue(head.isEmpty)

        let c = Container(id: 1)
        assertTrue(c.entry.isEmpty)

        head.insert(c.entry)
        assertFalse(c.entry.isEmpty)
    }

    func testInitialization() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let container = Container(id: 1)

        head.insert(container.entry)

        assertEqual(head.next, container.entry)
        assertEqual(head.prev, container.entry)
        assertEqual(container.entry.next, head)
        assertEqual(container.entry.prev, head)

        assertEqual(head.next.pointee.payload, container.id)
    }

    func testInsert() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let first = Container(id: 1)
        let second = Container(id: 2)
        head.insert(first.entry)
        head.insert(second.entry)

        assertEqual(head.next, second.entry)
        assertEqual(head.next.next, first.entry)

        assertEqual(head.prev, first.entry)
        assertEqual(head.prev.prev, second.entry)

        assertEqual(head.next.payload, 2)
        assertEqual(head.prev.payload, 1)
    }

    func testAppend() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let first = Container(id: 1)
        let second = Container(id: 2)
        head.append(first.entry)
        head.append(second.entry)

        assertEqual(head.next, first.entry)
        assertEqual(head.next.next, second.entry)

        assertEqual(head.prev, second.entry)
        assertEqual(head.prev.prev, first.entry)

        assertEqual(head.next.payload, 1)
        assertEqual(head.prev.payload, 2)
    }

    func testRemove() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let container = Container(id: 1)

        head.insert(container.entry)

        assertFalse(head.isEmpty)
        assertFalse(container.entry.isEmpty)

        container.entry.remove()

        assertTrue(head.isEmpty)
        assertTrue(container.entry.isEmpty)
    }

    func testFirst() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        assertNil(head.first)

        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        guard let first = head.first else {
            fail("first item is nil")
            return
        }
        assertEqual(first.payload, 1)
    }

    func testLast() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        assertNil(head.last)

        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        guard let last = head.last else {
            fail("last item is nil")
            return
        }
        assertEqual(last.pointee.payload, 2)
    }

    func testRemoveFirst() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        let removedFirst = head.removeFirst()
        let removedSecond = head.removeFirst()

        assertEqual(removedFirst.pointee.payload, 1)
        assertEqual(removedSecond.pointee.payload, 2)
        assertTrue(head.isEmpty)
    }

    func testRemoveLast() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 2)
        defer { items.deallocate() }

        let removedSecond = head.removeLast()
        let removedFirst = head.removeLast()

        assertEqual(removedSecond.pointee.payload, 2)
        assertEqual(removedFirst.pointee.payload, 1)
        assertTrue(head.isEmpty)
    }

    func testPopFirst() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var id = 0
        while let item = head.popFirst() {
            id += 1
            assertTrue(item.pointee.payload == id)
        }

        assertEqual(id, 10)
        assertTrue(head.isEmpty)
    }

    func testPopLast() {
        var head = UnsafeMutablePointer<ListEntry>.allocate(payload: 0)
        defer { head.deallocate() }
        let items = [Container](head: head, count: 10)
        defer { items.deallocate() }

        var id = 10
        while let item = head.popLast() {
            assertTrue(item.pointee.payload == id)
            id -= 1
        }

        assertEqual(id, 0)
        assertTrue(head.isEmpty)
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
