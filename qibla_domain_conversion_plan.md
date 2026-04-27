# Qibla Feature: Domain Layer Conversion Plan

## Current Issue (The "Why")
- **Business Logic Leakage**: The UI (`QiblaCompassStreamWidget`) is currently performing business calculations (angle difference, rotation angles, message mapping) by directly calling `IQiblaService`.
- **Architectural Inconsistency**: According to `CLAUDE.md`, features with multiple data sources (Location + Sensor) and complex rules should be **Tier 1 (3-Layer)**. Qibla is currently Tier 2.
- **Testability**: Logic trapped in widgets or data implementations is harder to unit test.

## Proposed Domain Layer (The "What")
The Domain layer will encapsulate the "How to calculate Qibla" logic, making it independent of Flutter and the specific sensor packages.

### 1. Entities (Pure Dart)
Move/Create entities that represent the business data:
- `QiblaLocationEntity`: Latitude and Longitude.
- `QiblaDirectionEntity`: The calculated degree towards Kaaba.
- `QiblaCompassDataEntity`: Ready-to-render data for the UI (rotation, arrow angle, messages).

### 2. Repository Interface
- Move `IQiblaRepository` from `data/repos/` to `domain/repositories/`.
- Ensure it returns `ApiResult<Entity>` instead of `ApiResult<Model>`.

### 3. Use Cases (The "Core")
- `GetQiblaDirectionUseCase`:
    - Logic: Gets location -> calculates direction -> returns `QiblaDirectionEntity`.
- `GetQiblaCompassStreamUseCase`:
    - Logic: Takes the raw sensor stream (`CompassEvent`) and the pre-calculated `qiblaDirection`, then transforms them into a stream of `QiblaCompassDataEntity`.
    - **This removes all logic from the Widget.**

## Implementation Steps

### Phase 1: Foundation
1. Create directory structure: `lib/features/qibla/domain/{entities,repositories,use_cases}`.
2. Define Entities (without any Flutter dependencies).
3. Move `IQiblaRepository` to `domain/repositories/` and update its methods.

### Phase 2: Data Layer Refactor
1. Update `QiblaRepoImpl` to implement the interface from Domain.
2. Update `QiblaLocationModel` to include a `toEntity()` mapper.

### Phase 3: Domain Logic
1. Implement `GetQiblaDirectionUseCase`.
2. Implement `GetQiblaCompassStreamUseCase` (Move the logic from `QiblaCompassStreamWidget` and `IQiblaService` here).

### Phase 4: Presentation Refactor
1. Update `QiblaCubit` to depend on `GetQiblaDirectionUseCase` instead of the repository.
2. Update `QiblaCompassStreamWidget` to consume the stream from the Use Case.
3. Clean up `IQiblaService` or keep it as a helper for the Use Case.

## Benefits
- **Clean UI**: The Widget only receives "ready-to-render" angles and strings.
- **Framework Independent**: The logic for calculating Qibla can be tested in pure Dart.
- **Consistency**: Matches the Tier 1 architecture defined in `CLAUDE.md`.
