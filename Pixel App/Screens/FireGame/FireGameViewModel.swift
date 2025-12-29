//
//  FireGameViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

struct FireGameItem: Identifiable {
    let id = UUID()
    var position: CGPoint
    var isVisible: Bool = true
}

@Observable
class FireGameViewModel {
    var timeRemaining: Int = 1 // 60 секунд = 1 минута
    var score: Int = 0
    private var timer: Timer?
    private var spawnTimer: Timer?
    var fireItems: [FireGameItem] = []
    var screenSize: CGSize = .zero
    var safeAreaInsets: EdgeInsets = EdgeInsets()
    var showDialogueView: Bool = false
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "00:%02d", seconds)
        }
    }
    
    func startTimer() {
        // Останавливаем предыдущий таймер, если он существует
        stopTimer()
        
        // Создаем новый таймер, который обновляется каждую секунду
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.stopSpawning()
                self.showDialogueView = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startSpawning() {
        stopSpawning()
        scheduleNextSpawn()
    }
    
    private func scheduleNextSpawn() {
        guard timeRemaining > 0 else { return }
        
        // 4 огонька в секунду = каждые 0.25 секунды
        let delay = 0.25
        spawnTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            guard let self = self, self.timeRemaining > 0 else { return }
            self.spawnFireItem()
            self.scheduleNextSpawn()
        }
    }
    
    func stopSpawning() {
        spawnTimer?.invalidate()
        spawnTimer = nil
    }
    
    func spawnFireItem() {
        guard screenSize.width > 0 && screenSize.height > 0 else { return }
        
        // Генерируем случайную позицию на экране
        let minX: CGFloat = 50
        let maxX = screenSize.width
        let minY: CGFloat = 100
        let maxY = screenSize.height
        
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        let newItem = FireGameItem(position: CGPoint(x: randomX, y: randomY))
        fireItems.append(newItem)
    }
    
    func tapFireItem(_ item: FireGameItem) {
        if let index = fireItems.firstIndex(where: { $0.id == item.id }) {
            fireItems.remove(at: index)
            incrementScore()
        }
    }
    
    func initializeGame(in screenSize: CGSize, safeAreaInsets: EdgeInsets) {
        self.screenSize = screenSize
        self.safeAreaInsets = safeAreaInsets
        // Спавним первую картинку сразу
        spawnFireItem()
        startSpawning()
    }
    
    func incrementScore() {
        score += 1
    }
    
    var dialogueText: String {
        "GOOD JOB! \n SCORE: \(score)"
    }
    
    func resetGame() {
        timeRemaining = 60
        score = 0
        fireItems.removeAll()
        showDialogueView = false
        stopTimer()
        stopSpawning()
    }
    
    deinit {
        stopTimer()
        stopSpawning()
    }
}

