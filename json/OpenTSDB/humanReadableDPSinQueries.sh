#!/bin/bash
json -ga -e 'dps = this.dps
readableDps = Object.keys(dps).reduce(function(result, key) {
    humanReadableDate = new Date(0);
    humanReadableDate.setSeconds(key);
    result[humanReadableDate] = dps[key];
    return result;
}, {});'
