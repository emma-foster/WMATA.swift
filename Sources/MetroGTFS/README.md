#  MetroGTFS

Use [WMATA's Static GTFS data](https://developer.wmata.com/docs/services/gtfs/operations/bus-gtfs-static).

## Usage

See base [README.md](../../README.md).

## Warning

This package is in active development and is likely to change.

## Support

This package currently only supports WMATA's Rail GTFS data. Bus GTFS data will be added eventually.

The following GTFS data types are supported

| GTFS Files | Supported? |  
| - | - |
| agency.txt | ✅ | 
| areas.txt | ✅ |
| calendar.txt | ✅ | 
| calendar_dates.txt | ✅ | 
| fare_leg_rules.txt | ❌ |
| fare_media.txt | ❌ |
| fare_products.txt | ❌ |
| feed_info.txt | ✅ | 
| levels.txt | ✅ |
| network.txt | 🟡 Not provided by WMATA but supported |
| pathways.txt | ❌ | 
| routes.txt | ✅ | 
| shapes.txt | ❌ | 
| stops.txt | ✅ | 
| stop_times.txt | ❌ |
| stop_areas.txt | ❌ |
| timeframes.txt | ❌ |
| timepoints.txt | ❌ |
| timepoints_times.txt | ❌ |
| trips.txt | ❌ | 


Unlisted GTFS files are not provided by WMATA.
