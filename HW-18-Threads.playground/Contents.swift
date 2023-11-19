import Foundation

public struct Chip {
    public enum ChipType: UInt32 {
        case small = 1
        case medium
        case big
    }
    
    public let chipType: ChipType
    
    public static func make() -> Chip {
        guard let chipType = Chip.ChipType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        
        return Chip(chipType: chipType)
    }
    
    public func sodering() {
        let soderingTime = chipType.rawValue
        sleep(UInt32(soderingTime))
    }
}

// MARK: Chip Storage

class ChipStorage {
    var storage = [Chip]()
    var mutex = NSCondition()
    private var count = Int()
    var isAvailable = Bool()
    
    var isEmpty: Bool {
        storage.isEmpty
    }
    
    func add(chip: Chip) {
        mutex.lock()
        isAvailable = true
        storage.append(chip)
        count += 1
        print("Chip #\(count) added in storage!")
        mutex.signal()
        mutex.unlock()
    }
    
    func remove() -> Chip {
        mutex.lock()
        while !isAvailable {
            mutex.wait()
            print("Waiting...")
        }
        isAvailable = false
        mutex.unlock()
        return storage.removeLast()
    }
}
