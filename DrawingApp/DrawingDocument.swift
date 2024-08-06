//
//  DrawingDocument.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/4/24.
//

import Foundation

class DrawingDocument: ObservableObject {
    // MARK: Lifecycle

    init() {
        if FileManager.default
            .fileExists(atPath: self.url.path), let data = try? Data(
                contentsOf: url)
        {
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
            } catch {
                print("decoding error: \(error)")
            }
        }
    }

    // MARK: Internal

    @Published var lines = [Line]() {
        didSet {
            self.save()
        }
    }

    var url: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        return documentsDirectory
            .appendingPathComponent("drawing")
            .appendingPathExtension("json")
    }

    func save() {
        let encoder = JSONEncoder()

        let data = try? encoder.encode(self.lines)

        do {
            try data?.write(to: self.url)
        } catch {
            print("error saving: \(error)")
        }
    }
}
