/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

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
