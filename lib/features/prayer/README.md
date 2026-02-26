# Prayer Feature

## Overview
Handles prayer times calculation, status, and countdown.

## Features
- **Prayer Carousel**: Displays countdown, spiritual status, and religious events.
- **Grace Period**: 10-minute grace period for current prayer.
- **Background Waves**: Visual indicator of time progress.
- **Status Calculator**: Intelligent classification of daily times (Makruh, Istijabah, etc).

## Technical Details
- Uses `adhan` package for core calculations.
- Integrated with `AppDateCubit` for Hijri-based religious events.
- Optimized UI using `ValueNotifier` for the countdown timer.
