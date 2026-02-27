# Prayer Feature

## Overview
Handles prayer times calculation, spiritual status monitoring, and countdown to next prayers. It provides a comprehensive spiritual experience by integrating prophetic traditions with modern UI.

## Features
- **Intelligent Prayer Carousel**: Displays real-time countdown, personalized spiritual statuses, and religious events.
- **Proactive Religious Events**: Automatically finds and displays the next upcoming religious event (e.g., Ramadan, Isra' Wal Mi'raj) even if it's not today.
- **Enhanced Daily Status**: Intelligent classification of times based on Prophetic Hadith:
    - **Times of Prohibition**: Rising/Setting sun.
    - **Hours of Response**: Between Azan and Iqama.
    - **Special Virtues**: Jawf al-Layl (Night Prayer), Dhuha prayer time.
    - **Continuous Dhikr**: Default status for other times.
- **Grace Period**: 10-minute grace period indicator for maintaining prayer on time.
- **Visual Progress**: Decorative background waves synchronized with the prayer lifecycle.

## Technical Details
- **Architecture**: Separated calculation logic (`utils/`) from UI components.
- **Core Engine**: Uses `adhan` package for precise calculations and `hijri` for event mapping.
- **Performance**: Optimized UI using `ValueNotifier` for the local timer to prevent rebuilds of the whole header.
- **Initialization**: `ReligiousEventsService` is initialized at app startup for zero-delay content availability.

## Directory Structure
- `data/`: Prayer settings, local repositories, and JSON-based event services.
- `utils/`: Centralized logic for countdowns and status classifications.
- `presentation/`:
    - `controller/`: Cubit managing prayer states and service interactions.
    - `widgets/header/`: Consolidated UI for the top section, including specialized carousel cards.
