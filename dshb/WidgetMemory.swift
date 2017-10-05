//
// WidgetMemory.swift
// dshb
//
// The MIT License
//
// Copyright (C) 2014-2017  beltex <https://beltex.github.io>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

struct WidgetMemory: WidgetType {

    let name = "Memory"
    let displayOrder = 2
    var title: WidgetUITitle
    var stats = [WidgetUIStat]()

    fileprivate static let maxValueGB = System.physicalMemory(.gigabyte)
    fileprivate static let maxValueMB = System.physicalMemory(.megabyte)
    
    init(window: Window = Window()) {
        title = WidgetUITitle(name: name, window: window)


        for stat in ["Free", "Wired", "Active", "Inactive", "Compressed"] {
            stats.append(WidgetUIStat(name: stat, unit: .Gigabyte,
                                      max: WidgetMemory.maxValueGB))
        }


        stats[0].Nominal.range = 0.45..<1.0
        stats[0].Danger.range = 0.2..<0.45
        stats[0].Crisis.range = 0..<0.2
    }
    
    mutating func draw() {
        let values = System.memoryUsage()
        unitCheck(values.free, index: 0)
        unitCheck(values.wired, index: 1)
        unitCheck(values.active, index: 2)
        unitCheck(values.inactive, index: 3)
        unitCheck(values.compressed, index: 4)
    }
    
    fileprivate mutating func unitCheck(_ val: Double, index: Int) {
        if val < 1.0 {
            stats[index].unit = .Megabyte
            let value = val * 1000.0
            stats[index].draw(String(Int(value)),
                              percentage: value / WidgetMemory.maxValueMB)
        }
        else {
            stats[index].unit = .Gigabyte
            stats[index].draw(NSString(format:"%.2f", val) as String,
                              percentage: val / WidgetMemory.maxValueGB)
        }
    }
}
