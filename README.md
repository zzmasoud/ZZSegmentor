# ZZSegmentor

<p align="left">
<img src="https://img.shields.io/badge/platforms-iOS%2C%20macOS%2C%20watchOS%2C%20tvOS-informational.svg">
<img src="https://github.com/zzmasoud/ZZSegmentor/workflows/CI/badge.svg">
<img src="https://img.shields.io/badge/coverage-99.5%25-success">
<img src="https://img.shields.io/github/license/zzmasoud/ZZSegmentor?color=lightgray">
</p>

  
ZZSegmentor is one of the main module in my timetracker app, [CLOC](https://zzmasoud.github.io/CLOC).

It can help you with two main purpose:
1. timeframe
2. segmentation (based on hourly/daily/monthly unit)

> I used this module to show average and total time spent on a timeframe and also, bar charts for segmented times based on a specific unit.

## How does it work?
To understand the module, we need to understand the problem.
### Edges
There are situations where user is tracking the time and it passes a unit, e.g. date changes to a *new hour, day or month*. When we use a simple if statement to show average and total time, side effects happens. the simplest code to get the total time in a timeframe is:
``` swift
import ZZSegmentor

let items: [DateItem] = [...]

// items between startOfDay .... now
let end = Date()
let start = end.startOfDay()

let filteredItems = items.filter(\.start >=  start && \.end <= end)
let totalTime: TimeInterval = filteredItems.map(\.duration).reduce(0, +)
```
But this is not 100% accurate. Let me explain it with this timeline:
![Timeline](/DOCS/Timeline.png)

The above code will reomve first and last item because of the filter code and also we can't forget about filtering items.
To solve this problem `ZZSegmentor` first finds **edges** and then it just cosiders intersections if needed.

``` swift
import ZZSegmentor

let items: [DateItem] = [...]

// items between startOfDay .... now
let end = Date()
let start = end.startOfDay()

let segmentor = ZZSegmentor(items: items, start: start, end: end)
let totalTime = segmentor.totalTime
let accurateItemsInTheBounds = segmentor.itemsInTimeframe
```
To demonstrate what just happened using `ZZSegmentor`:

![Timeline](/DOCS/Edges.png)
