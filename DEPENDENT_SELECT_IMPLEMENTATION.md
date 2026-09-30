# Dependent Select Implementation for Staff Pages

## Overview
Implemented cascading/dependent select dropdowns for Country → State → LGA in both `adminAddStaff.jsp` and `updateStaff.jsp`, following the same pattern used in `genappDashboard.jsp`.

## Entity Relationships
- **Countries** (1) → (Many) **States** via `States.countryId`
- **States** (1) → (Many) **Lgas** via `Lgas.stateId`

## Implementation Details

### 1. adminAddStaff.jsp (Add New Staff)

#### Changes Made:
1. **Added Country Select Field** for location context
   - ID: `countrySelect`
   - Auto-selects Nigeria (ID: 160) by default
   - Triggers `loadStates()` on change

2. **Modified State Select Field**
   - ID: `stateSelect`
   - Now populated dynamically via AJAX based on selected country
   - Triggers `loadLgas()` on change

3. **LGA Select Field** (already existed)
   - ID: `lgaSelect`
   - Populated dynamically via AJAX based on selected state

4. **JavaScript Functions Added:**
   - `loadStates()` - Loads states when country changes
   - `callloadStates()` - Callback to populate state dropdown
   - `loadLgas()` - Loads LGAs when state changes (enhanced)
   - `callloadLgas()` - Callback to populate LGA dropdown
   - Auto-initialization on page load to load states for pre-selected Nigeria

#### AJAX Endpoints Used:
- `AjaxServlet?action=loadState&id={countryId}` - Returns states for a country
- `AjaxServlet?action=loadlga&id={stateId}` - Returns LGAs for a state

### 2. updateStaff.jsp (Update Existing Staff)

#### Changes Made:
1. **Added Country Select Field** for location context
   - ID: `countrySelect`
   - Auto-selects the country based on existing staff's state
   - Falls back to Nigeria (ID: 160) if no state exists
   - Triggers `loadStates()` on change

2. **Modified State Select Field**
   - ID: `stateSelect`
   - Uses `data-selected-state` attribute to preserve existing selection
   - Populated dynamically via AJAX
   - Shows existing state initially, then reloads on country change

3. **Modified LGA Select Field**
   - ID: `lgaSelect`
   - Uses `data-selected-lga` attribute to preserve existing selection
   - Shows existing LGA initially, then reloads on state change

4. **JavaScript Functions Added:**
   - `loadStates()` - Loads states and preserves existing selection
   - `callloadStates()` - Callback that re-selects previous state and loads LGAs
   - `loadLgas()` - Loads LGAs and preserves existing selection
   - `callloadLgas()` - Callback that re-selects previous LGA
   - Auto-initialization on page load to load states for selected country

## How It Works

### Add Staff Flow:
1. Page loads with Nigeria pre-selected in Country dropdown
2. JavaScript auto-loads Nigerian states on page load
3. User selects a state → LGAs for that state are loaded
4. User selects an LGA
5. Form submission includes stateId and lgaId

### Update Staff Flow:
1. Page loads with existing staff data
2. Country is auto-selected based on staff's existing state (or Nigeria as default)
3. State dropdown shows existing state initially
4. JavaScript loads all states for the selected country
5. After states load, the existing state is re-selected
6. LGAs are loaded for the existing state
7. After LGAs load, the existing LGA is re-selected
8. User can change country → states reload → LGAs clear
9. User can change state → LGAs reload

## Key Features

1. **Cascading Behavior**: Changing country clears and reloads states; changing state clears and reloads LGAs
2. **Data Preservation**: In edit mode, existing selections are preserved after AJAX reloads
3. **Auto-initialization**: States load automatically on page load
4. **Error Handling**: Console errors logged if elements not found
5. **Consistent Pattern**: Uses same AJAX endpoints and structure as genappDashboard.jsp

## Testing Checklist

### adminAddStaff.jsp:
- [ ] Page loads with Nigeria selected
- [ ] States dropdown populates automatically
- [ ] Selecting a state populates LGAs
- [ ] Changing country reloads states and clears LGAs
- [ ] Form submission saves correct stateId and lgaId

### updateStaff.jsp:
- [ ] Existing staff's country, state, and LGA are displayed correctly
- [ ] Changing country reloads states
- [ ] Changing state reloads LGAs
- [ ] Previous selections are preserved after AJAX reloads
- [ ] Form submission updates correct stateId and lgaId

## Files Modified
1. `src/main/webapp/adminAddStaff.jsp`
2. `src/main/webapp/updateStaff.jsp`

## Dependencies
- AjaxServlet with actions: `loadState` and `loadlga`
- Session methods: `getAllCountries()`, `getAllStatesInCountry(countryId)`, `getAllLgas()`
- Entity classes: Countries, States, Lgas with proper relationships
