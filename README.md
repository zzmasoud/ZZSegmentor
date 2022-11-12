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

![Edges](/DOCS/Edges.png)

### Segments
There is a special bar chart on the statics page of my app which shows total time for a specific unit, e.g. total time spent daily in October. Apple has been provided `DateInterval` that works perfect with intervals and intersections. But loop through intervals based on units is not as easy as using it itself. `ZZSegmentor` makes it easy to do.

Consider we have some datas for only 1 to 3 October and the module wants to segment them day by day. Again, we have edges and also looping through the desired unit. (in this image the iterator is on 2 OCT)

![Segments](/DOCS/Segments.png)

``` swift
import ZZSegmentor

let items: [DateItem] = [...]

// items between startOfDay .... now
let end = Date()
let start = end.startOfDay()

let segmentor = ZZSegmentor(items: items, start: start, end: end)
segmentor.update(unit: .daily)
let segmentes = segmentor.getSegments()
/*
 it prints [
DateUnitShare(key: 1, value: totalTimeOf1OCT)
DateUnitShare(key: 2, value: totalTimeOf2OCT)
DateUnitShare(key: 3, value: totalTimeOf3OCT)
]
*/
```
This method ***getSegments()*** also accepts a `Boolean` parameter called `allUnits` which will add all shares even if it is not in the desired bounds, so for the above code it will print out the first tree `DateUnitShare` and the rest of share items with value 0 to the end of month.

## To-Do
- [ ] 100% test coverage
- [ ] Currently `DateUnit`'s range is using constanst, e.g. `.daily` is always `1..<31` which is wrong
- [ ] Daylight saving failure
- [ ] iOS App example with timeline preview like images used in the README

## License
ZZSegmentor is available under the MIT license. See the LICENSE file for more info.
