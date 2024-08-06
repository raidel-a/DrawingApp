//
//  CommandManager.swift
//  DrawingApp
//
//  Created by Raidel Almeida on 8/5/24.
//

import Foundation

protocol DrawingCommand {
    func execute(on lines: inout [Line])
    func undo(on lines: inout [Line])
}

struct AddLineCommand: DrawingCommand {
    let line: Line
    
    func execute(on lines: inout [Line]) {
        lines.append(line)
    }
    
    func undo(on lines: inout [Line]) {
        lines.removeLast()
    }
}

struct RemoveLineCommand: DrawingCommand {
    let index: Int
    let removedLine: Line
    
    func execute(on lines: inout [Line]) {
        lines.remove(at: index)
    }
    
    func undo(on lines: inout [Line]) {
        lines.insert(removedLine, at: index)
    }
}

class CommandManager: ObservableObject {
    @Published private var undoStack: [DrawingCommand] = []
    @Published private var redoStack: [DrawingCommand] = []
    
    func executeCommand(_ command: DrawingCommand, on lines: inout [Line]) {
        command.execute(on: &lines)
        undoStack.append(command)
        redoStack.removeAll()
    }
    
    func undo(on lines: inout [Line]) {
        guard let command = undoStack.popLast() else { return }
        command.undo(on: &lines)
        redoStack.append(command)
    }
    
    func redo(on lines: inout [Line]) {
        guard let command = redoStack.popLast() else { return }
        command.execute(on: &lines)
        undoStack.append(command)
    }
    
    var canUndo: Bool {
        !undoStack.isEmpty
    }
    
    var canRedo: Bool {
        !redoStack.isEmpty
    }
}
