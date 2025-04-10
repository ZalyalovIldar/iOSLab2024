//
//  StorageServiceViewModel.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 7.04.25.
//

import Foundation

class StorageServiceViewModel {
    private var storageService: StorageService<TaskItem>
    var notes: [TaskItem] = []
    
    init(storageService: StorageService<TaskItem>) {
        self.storageService = storageService
        self.notes = storageService.load()
    }
    
    var numberOfTasks: Int {
        return notes.count
    }
    
    func getNoteAtIndex(at index: Int) -> TaskItem {
        return notes[index]
    }
    
    func addNote(title: String) {
        let newNote = TaskItem(description: title)
        notes.append(newNote)
        storageService.save(items: notes)
    }
    
    func toggleCompletion(at index: Int) {
        var note = notes[index]
        note.isDone.toggle()
        notes[index] = note
        storageService.update(item: note)
    }
    
    
    
}
