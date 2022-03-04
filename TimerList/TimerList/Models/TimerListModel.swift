//
//  TimerListModel.swift
//  TimerList
//
//  Created by 波多野充 on 2022/03/03.
//

import Foundation

class TimerListModel: ObservableObject {
    @Published var timerList = [TimerItem(sec: 100, isActive: true), TimerItem(sec: 400, isAlarmOn: true)]
    @Published var activeIndex: Int? = nil
    @Published var timer: Timer? = nil
    @Published var timerRunning: Bool = false
    func setCursor(to item: inout TimerItem) {
        guard let index = findIndex(element: item) else { return }
        activeIndex = index
        return
    }
    func findIndex(element: TimerItem) -> Int? {
        for i in timerList.indices {
            if timerList[i] == element {
                return i
            }
        }
        return nil  // the element does not exist
    }
    
    func incrementIndex() {
        guard let index = activeIndex else { return }
        self.activeIndex = (index + 1) % timerList.count
    }
    
    func startTimer() {
        assert(!timerRunning)
        timerRunning = true
        guard let activeIndex = activeIndex else { return }
        if timerList[activeIndex].secLeft <= 0 { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.countDown()
        }
    }
    
    func stopTimer() {
        assert(timerRunning)
        timerRunning = false
        timer?.invalidate()
    }
    
    func countDown() {
        guard let activeIndex = activeIndex else { return }
        timerList[activeIndex].secLeft -= 1
        if !self.checkSecLeft() {
            stopTimer()
            
            // replenish the sec
            timerList[activeIndex].secLeft = timerList[activeIndex].sec
            
            // 
        }
    }
    
    func checkSecLeft() -> Bool {
        guard let activeIndex = activeIndex else {
            return false
        }
        return timerList[activeIndex].secLeft >= 0
    }
    
}
