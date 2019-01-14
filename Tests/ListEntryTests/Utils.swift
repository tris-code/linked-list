import ListEntry

struct Container {
    var id: Int
    var entry: UnsafeMutablePointer<ListEntry<Int>>

    init(id: Int) {
        self.id = id
        entry = UnsafeMutablePointer<ListEntry>.allocate(payload: id)
    }
}

extension Array where Element == Container {
    init(head: UnsafeMutablePointer<ListEntry<Int>>, count: Int) {
        var items = [Container]()
        for i in 1...count {
            let container = Container(id: i)
            head.append(container.entry)
            items.append(container)
        }
        self = items
    }

    func deallocate() {
        for item in self {
            item.entry.deallocate()
        }
    }
}
