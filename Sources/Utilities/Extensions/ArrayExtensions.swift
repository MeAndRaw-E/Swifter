import LoggingTime

extension Array where Element: Identifiable {
    mutating func insertItem(_ newItem: Element, afterID: Element.ID) {
        guard let currentIndex = firstIndex(where: { $0.id == afterID }) else { return }
        insert(newItem, at: Swift.min(currentIndex + 1, count))
    }
    @discardableResult
    mutating func removeItem(withID id: Element.ID) -> Element? {
        guard let index = firstIndex(where: { $0.id == id }) else { return nil }
        return remove(at: index)
    }
}

public func addItem<T: Identifiable>(to list: inout [T], item: T, after id: T.ID) {
    list.insertItem(item, afterID: id)
}

public func removeItem<T: Identifiable>(from list: inout [T], at id: T.ID) {
    list.removeItem(withID: id)
}
